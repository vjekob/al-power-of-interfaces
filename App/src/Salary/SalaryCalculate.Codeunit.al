namespace Demo.Salary;

using Microsoft.HumanResources.Employee;
using Microsoft.Projects.TimeSheet;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 60100 SalaryCalculate
{
    procedure CalculateSalary(var Employee: Record Employee; AtDate: Date) Result: Record MonthlySalary
    var
        Setup: Record SalarySetup;
        Department: Record Department;
        DepartmentSenioritySetup: Record DepartmentSenioritySetup;
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        MonthlySalary: Record MonthlySalary;
        SubordinateEmployee: Record Employee;
        Salary: Decimal;
        Bonus: Decimal;
        Incentive: Decimal;
        WorkHours: Decimal;
        YearsOfTenure: Integer;
        StartingDate: Date;
        EndingDate: Date;
    begin
        Setup.Get();
        Setup.TestField(BaseSalary);
        Setup.TestField(MinimumHours);
        Setup.TestField(OvertimeThreshold);
        Setup.TestField(YearlyIncentivePct);
        Employee.TestField("Resource No.");
        Employee.TestField("Salespers./Purch. Code");

        // Calculate base salary
        Salary := Employee.BaseSalary;

        if Employee.BaseSalary = 0 then
            if Employee.DepartmentCode <> '' then begin
                Department.Get(Employee.DepartmentCode);
                Salary := Department.BaseSalary;
                if DepartmentSenioritySetup.Get(Employee.DepartmentCode, Employee.Seniority) then
                    Salary := DepartmentSenioritySetup.BaseSalary;
            end;

        // Calculate bonus
        StartingDate := CalcDate('<CM+1D-1M>', AtDate);
        EndingDate := CalcDate('<CM>', AtDate);
        if Employee.Seniority in [Seniority::Staff, Seniority::Lead] then
            case Employee.SalaryType of
                SalaryType::Timesheet:
                    begin
                        TimeSheetHeader.SetRange("Resource No.", Employee."Resource No.");
                        TimeSheetHeader.SetRange("Starting Date", StartingDate, EndingDate);
                        TimeSheetHeader.SetRange("Ending Date", StartingDate, EndingDate);
                        if TimeSheetHeader.FindSet() then
                            repeat
                                TimeSheetLine.Reset();
                                TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
                                TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Approved);
                                TimeSheetLine.SetAutoCalcFields("Total Quantity");
                                if TimeSheetLine.FindSet() then
                                    repeat
                                        WorkHours += TimeSheetLine."Total Quantity";
                                    until TimeSheetLine.Next() = 0;
                            until TimeSheetHeader.Next() = 0;

                        if WorkHours < Setup.MinimumHours then
                            Bonus := -Salary * (1 - WorkHours / Setup.MinimumHours)
                        else
                            if (WorkHours > Setup.OvertimeThreshold) then
                                Bonus := Salary * (1 - WorkHours / Setup.OvertimeThreshold);
                    end;
                SalaryType::Commission:
                    begin
                        CustLedgEntry.SetRange("Posting Date", StartingDate, EndingDate);
                        CustLedgEntry.SetRange("Salesperson Code", Employee."Salespers./Purch. Code");
                        CustLedgEntry.SetFilter("Document Type", '%1|%2', "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo");
                        CustLedgEntry.CalcSums("Profit (LCY)");
                        Bonus := (Employee.CommissionBonusPct / 100) * CustLedgEntry."Profit (LCY)";
                    end;

                SalaryType::Target:
                    begin
                        CustLedgEntry.SetRange("Posting Date", StartingDate, EndingDate);
                        CustLedgEntry.SetRange("Salesperson Code", Employee."Salespers./Purch. Code");
                        CustLedgEntry.SetFilter("Document Type", '%1|%2', "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo");
                        CustLedgEntry.CalcSums("Sales (LCY)");
                        Bonus := Employee.TargetBonus * (CustLedgEntry."Sales (LCY)" / Employee.TargetRevenue);
                        if (Bonus > Employee.MaximumTargetBonus) and (Employee.MaximumTargetBonus > 0) then
                            Bonus := Employee.MaximumTargetBonus
                        else
                            if (Bonus < Employee.MaximumTargetMalus) and (Employee.MaximumTargetMalus < 0) then
                                Bonus := Employee.MaximumTargetMalus;
                    end;
            end
        else
            if Employee.Seniority in [Seniority::Manager, Seniority::Director] then begin
                Bonus := 0;
                SubordinateEmployee.SetRange("Manager No.", Employee."No.");
                if SubordinateEmployee.FindSet() then
                    repeat
                        MonthlySalary.Reset();
                        MonthlySalary.SetRange(EmployeeNo, SubordinateEmployee."No.");
                        MonthlySalary.SetRange(Date, AtDate);
                        if not MonthlySalary.FindFirst() then
                            MonthlySalary := SubordinateEmployee.CalculateSalary(AtDate);
                        Bonus += MonthlySalary.Bonus;
                    until SubordinateEmployee.Next() = 0;
                Bonus := Bonus * (1 + Employee.TeamBonusPct / 100);
            end;

        // Calculate incentives
        if Employee.Seniority in [Seniority::Staff, Seniority::Lead] then begin
            YearsOfTenure := Round((AtDate - Employee."Employment Date") / 365, 1, '<');
            Incentive := Salary * (YearsOfTenure * Setup.YearlyIncentivePct) / 100;
        end else
            if Employee.Seniority = Seniority::Manager then begin
                Incentive := 0;
                SubordinateEmployee.SetRange("Manager No.", Employee."No.");
                if SubordinateEmployee.FindSet() then
                    repeat
                        MonthlySalary.Reset();
                        MonthlySalary.SetRange(EmployeeNo, SubordinateEmployee."No.");
                        MonthlySalary.SetRange(Date, AtDate);
                        if not MonthlySalary.FindFirst() then
                            MonthlySalary := SubordinateEmployee.CalculateSalary(AtDate);
                        Incentive += MonthlySalary.Incentive;
                    until SubordinateEmployee.Next() = 0;
                Incentive := Incentive * (1 + Employee.TeamIncentivePct / 100);
            end;

        Result.EmployeeNo := Employee."No.";
        Result.Date := AtDate;
        Result.Salary := Salary;
        Result.Bonus := Bonus;
        Result.Incentive := Incentive;
    end;
}
