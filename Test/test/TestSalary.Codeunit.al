namespace Demo.Salary;

using Microsoft.Projects.TimeSheet;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Receivables;
using Microsoft.CRM.Team;
using Microsoft.Foundation.NoSeries;
using Microsoft.HumanResources.Employee;
using Microsoft.Projects.Resources.Resource;

codeunit 60152 "Test - Salary"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryERM: Codeunit "Library - ERM";
        LibraryRes: Codeunit "Library - Resource";
        LibraryHR: Codeunit "Library - Human Resource";
        LibrarySales: Codeunit "Library - Sales";
        IsInitialized: Boolean;
        TimeSheetNos: Code[20];

    [Test]
    procedure Test_FixedSalary()
    var
        Employee: Record Employee;
        Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
        Salary: Record MonthlySalary;
    begin
        // [SCENARIO] Salary calculation - fixed salary
        Initialize();

        // [GIVEN] A resource to be used by the employee
        LibraryRes.CreateResourceNew(Resource);

        // [GIVEN] A salesperson to be used by the employee
        LibrarySales.CreateSalesperson(Salesperson);

        // [GIVEN] A staff employee with fixed salary calculation
        LibraryHR.CreateEmployee(Employee);
        Employee."Resource No." := Resource."No.";
        Employee."Salespers./Purch. Code" := Salesperson."Code";
        Employee.Seniority := Seniority::Staff;
        Employee.SalaryType := SalaryType::Fixed;
        Employee.BaseSalary := 2000;
        Employee."Employment Date" := CalcDate('<CM-62M>', Today());
        Employee.Modify(false);

        // [WHEN] Calculating Salary
        Salary := Employee.CalculateSalary(Today);

        // [THEN] Salary must not be adjusted from base salary
        Assert.AreEqual(2000, Salary.Salary, 'Salary calculated incorrectly');
        Assert.AreEqual(0, Salary.Bonus, 'Bonus calculated incorrectly');
        Assert.AreEqual(200, Salary.Incentive, 'Incentive calculated incorrectly');
    end;

    [Test]
    procedure Test_TimesheetSalary_Undertime()
    var
        Employee: Record Employee;
        Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        Salary: Record MonthlySalary;
    begin
        // [SCENARIO] Salary calculation
        Initialize();

        // [GIVEN] A resource to be used by the employee
        LibraryRes.CreateResourceNew(Resource);

        // [GIVEN] A salesperson to be used by the employee
        LibrarySales.CreateSalesperson(Salesperson);

        // [GIVEN] A staff employee with timesheet salary calculation
        LibraryHR.CreateEmployee(Employee);
        Employee."Resource No." := Resource."No.";
        Employee."Salespers./Purch. Code" := Salesperson."Code";
        Employee.Seniority := Seniority::Staff;
        Employee.SalaryType := SalaryType::Timesheet;
        Employee.BaseSalary := 2000;
        Employee."Employment Date" := CalcDate('<CM-6M>', Today());
        Employee.Modify(false);

        // [GIVEN] Time sheet entries for current month to not exceed the maximum hours
        CreateTimeSheetHeader(TimeSheetHeader, Resource."No.");
        CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, 55);
        CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, 50);

        // [WHEN] Calculating Salary
        Salary := Employee.CalculateSalary(Today);

        // [THEN] Salary must not be adjusted from base salary
        Assert.AreEqual(2000, Salary.Salary, 'Salary calculated incorrectly');
        Assert.AreEqual(-250, Salary.Bonus, 'Bonus calculated incorrectly');
        Assert.AreEqual(0, Salary.Incentive, 'Incentive calculated incorrectly');
    end;

    [Test]
    procedure Test_CommissionSalary()
    var
        Employee: Record Employee;
        Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Salary: Record MonthlySalary;
    begin
        // [SCENARIO] Salary calculation
        Initialize();

        // [GIVEN] A resource to be used by the employee
        LibraryRes.CreateResourceNew(Resource);

        // [GIVEN] A salesperson to be used by the employee
        LibrarySales.CreateSalesperson(Salesperson);

        // [GIVEN] A staff employee with commission salary calculation
        LibraryHR.CreateEmployee(Employee);
        Employee."Resource No." := Resource."No.";
        Employee."Salespers./Purch. Code" := Salesperson."Code";
        Employee.Seniority := Seniority::Staff;
        Employee.SalaryType := SalaryType::Commission;
        Employee.BaseSalary := 2000;
        Employee.CommissionBonusPct := 25;
        Employee."Employment Date" := CalcDate('<CM-6M>', Today());
        Employee.Modify(false);

        // [GIVEN] Two customer ledger entries
        if CustLedgEntry.FindLast() then;
        CustLedgEntry.Init();
        CustLedgEntry."Entry No." += 1;
        CustLEdgEntry."Document Type" := "Gen. Journal Document Type"::Invoice;
        CustLedgEntry."Posting Date" := Today();
        CustLedgEntry."Salesperson Code" := Salesperson."Code";
        CustLedgEntry."Profit (LCY)" := 150;
        CustLedgEntry.Insert(false);
        CustLedgEntry."Entry No." += 1;
        CustLedgEntry."Profit (LCY)" := 100;
        CustLedgEntry.Insert(false);

        // [WHEN] Calculating Salary
        Salary := Employee.CalculateSalary(Today);

        // [THEN] Salary must not be adjusted from base salary
        Assert.AreEqual(2000, Salary.Salary, 'Salary calculated incorrectly');
        Assert.AreEqual(62.5, Salary.Bonus, 'Bonus calculated incorrectly');
        Assert.AreEqual(0, Salary.Incentive, 'Incentive calculated incorrectly');
    end;

    [Test]
    procedure Test_TargetSalary()
    var
        Employee: Record Employee;
        Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Salary: Record MonthlySalary;
    begin
        // [SCENARIO] Salary calculation
        Initialize();

        // [GIVEN] A resource to be used by the employee
        LibraryRes.CreateResourceNew(Resource);

        // [GIVEN] A salesperson to be used by the employee
        LibrarySales.CreateSalesperson(Salesperson);

        // [GIVEN] A staff employee with commission salary calculation
        LibraryHR.CreateEmployee(Employee);
        Employee."Resource No." := Resource."No.";
        Employee."Salespers./Purch. Code" := Salesperson."Code";
        Employee.Seniority := Seniority::Staff;
        Employee.SalaryType := SalaryType::Target;
        Employee.BaseSalary := 2000;
        Employee.TargetRevenue := 125000;
        Employee.TargetBonus := 1000;
        Employee.MaximumTargetBonus := 1500;
        Employee."Employment Date" := CalcDate('<CM-37M>', Today());
        Employee.Modify(false);

        // [GIVEN] Two customer ledger entries
        if CustLedgEntry.FindLast() then;
        CustLedgEntry.Init();
        CustLedgEntry."Entry No." += 1;
        CustLEdgEntry."Document Type" := "Gen. Journal Document Type"::Invoice;
        CustLedgEntry."Posting Date" := Today();
        CustLedgEntry."Salesperson Code" := Salesperson."Code";
        CustLedgEntry."Sales (LCY)" := 80000;
        CustLedgEntry.Insert(false);
        CustLedgEntry."Entry No." += 1;
        CustLedgEntry."Sales (LCY)" := 70000;
        CustLedgEntry.Insert(false);

        // [WHEN] Calculating Salary
        Salary := Employee.CalculateSalary(Today);

        // [THEN] Salary must not be adjusted from base salary
        Assert.AreEqual(2000, Salary.Salary, 'Salary calculated incorrectly');
        Assert.AreEqual(1200, Salary.Bonus, 'Bonus calculated incorrectly');
        Assert.AreEqual(120, Salary.Incentive, 'Incentive calculated incorrectly');
    end;

    local procedure CreateTimeSheetHeader(var TimeSheetHeader: Record "Time Sheet Header"; ResourceNo: Code[20])
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        TimeSheetHeader."No." := NoSeriesMgt.GetNextNo(TimeSheetNos, Today(), true);
        TimeSheetHeader."Starting Date" := Today();
        TimeSheetHeader."Ending Date" := Today();
        TimeSheetHeader."Resource No." := ResourceNo;
        TimeSheetHeader.Insert(false);
    end;

    local procedure CreateTimeSheetLine(TimeSheetHeader: Record "Time Sheet Header"; var TimeSheetLine: Record "Time Sheet Line"; Quantity: Decimal)
    var
        TimeSheetDetail: Record "Time Sheet Detail";
    begin
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        if not TimeSheetLine.FindLast() then;

        TimeSheetLine.Init();
        TimeSheetLine."Time Sheet No." := TimeSheetHeader."No.";
        TimeSheetLine."Line No." += 10000;
        TimeSheetLine.Status := TimeSheetLine.Status::Approved;
        TimeSheetLine.Insert(false);

        TimeSheetDetail."Time Sheet No." := TimeSheetLine."Time Sheet No.";
        TimeSheetDetail."Time Sheet Line No." := TimeSheetLine."Line No.";
        TimeSheetDetail.Date := Today();
        TimeSheetDetail.Quantity := Quantity;
        TimeSheetDetail.Insert(false);
    end;

    local procedure InitializeSetup()
    var
        SalarySetup: Record SalarySetup;
    begin
        if not SalarySetup.Get() then
            SalarySetup.Insert();

        SalarySetup.BaseSalary := 1000;
        SalarySetup.MinimumHours := 120;
        SalarySetup.OvertimeThreshold := 180;
        SalarySetup.YearlyIncentivePct := 2;
        SalarySetup.Modify();
    end;

    local procedure InitializeTimeSheetNos()
    begin
        TimesheetNos := LibraryERM.CreateNoSeriesCode();
    end;

    local procedure Initialize()
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Test - Salary");

        if IsInitialized then exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Test - Salary");

        InitializeSetup();
        InitializeTimeSheetNos();

        IsInitialized := true;
        Commit();
        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Test - Salary");
    end;
}
