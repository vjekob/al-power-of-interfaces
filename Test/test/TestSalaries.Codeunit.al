namespace Demo.Salary;

using Microsoft.CRM.Team;
using Microsoft.HumanResources.Employee;
using Microsoft.Projects.Resources.Resource;

codeunit 60153 "Test - Salaries"
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
    procedure Test_CalculateMonthlySalaries()
    var
        Employee: Record Employee;
        Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
        MonthlySalary: Record MonthlySalary;
    begin
        // [SCENARIO] Salaries calculation
        Initialize();

        // [GIVEN] No salaries in the database
        MonthlySalary.DeleteAll();

        // [GIVEN] A resource to be used by the employee
        LibraryRes.CreateResourceNew(Resource);

        // [GIVEN] A salesperson to be used by the employee
        LibrarySales.CreateSalesperson(Salesperson);

        // [GIVEN] All employees correctly configured for salary calculation
        if Employee.FindSet() then
            repeat
                ConfigureEmployee(Employee, Resource."No.", Salesperson.Code);
            until Employee.Next() = 0;

        // [GIVEN] Three more staff employee with fixed salary calculation
        Clear(Employee);
        LibraryHR.CreateEmployee(Employee);
        ConfigureEmployee(Employee, Resource."No.", Salesperson.Code);
        Clear(Employee);
        LibraryHR.CreateEmployee(Employee);
        ConfigureEmployee(Employee, Resource."No.", Salesperson.Code);
        Clear(Employee);
        LibraryHR.CreateEmployee(Employee);
        ConfigureEmployee(Employee, Resource."No.", Salesperson.Code);

        // [WHEN] Calculating salaries
        MonthlySalary.CalculateMonthlySalaries();

        // [THEN] Salary must be written for every employee
        Employee.Reset();
        MonthlySalary.Reset();
        Assert.AreEqual(Employee.Count(), MonthlySalary.Count(), 'Salary not calculated for every employee');
        if Employee.FindSet() then
            repeat
                MonthlySalary.SetRange(Date, Today());
                MonthlySalary.SetRange(EmployeeNo, Employee."No.");
                Assert.IsTrue(MonthlySalary.IsEmpty(), StrSubstNo('Salary not calculated for employee %1', Employee."No."));
            until Employee.Next() = 0;
    end;

    local procedure ConfigureEmployee(var Employee: Record Employee; ResourceNo: Code[20]; SalespersonCode: Code[20])
    begin
        Employee."Resource No." := ResourceNo;
        Employee."Salespers./Purch. Code" := SalespersonCode;
        Employee.Seniority := Seniority::Staff;
        Employee.SalaryType := SalaryType::Fixed;
        Employee.BaseSalary := 2000;
        Employee."Employment Date" := CalcDate('<CM-62M>', Today());
        Employee.Modify(false);
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
