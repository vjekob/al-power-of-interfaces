namespace Demo.Salary;

using Microsoft.HumanResources.Employee;

table 60101 MonthlySalary
{
    Caption = 'Monthly Salary';
    DataClassification = CustomerContent;
    LookupPageId = MonthlySalaries;
    DrillDownPageId = MonthlySalaries;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; EmployeeNo; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }

        field(3; Date; Date)
        {
            Caption = 'Date';
        }

        field(4; Salary; Decimal)
        {
            Caption = 'Salary Amount';
        }

        field(5; Bonus; Decimal)
        {
            Caption = 'Bonus Amount';
        }

        field(6; Incentive; Decimal)
        {
            Caption = 'Incentive Amount';
        }
    }

    procedure CalculateMonthlySalaries()
    var
        Employee: Record "Employee";
        MonthlySalary: Record MonthlySalary;
        AtDate: Date;
    begin
        AtDate := CalcDate('CM', WorkDate());

        MonthlySalary.SetRange(Date, AtDate);
        MonthlySalary.DeleteAll(false);

        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindSet() then
            repeat
                MonthlySalary := Employee.CalculateSalary(AtDate);
                MonthlySalary.Insert(false);
            until Employee.Next() = 0;
    end;
}
