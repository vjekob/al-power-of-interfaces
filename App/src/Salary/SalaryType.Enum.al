namespace Demo.Salary;

enum 60101 SalaryType
{
    Caption = 'Salary Type';
    Extensible = true;

    value(1; Fixed)
    {
        Caption = 'Fixed Salary';
    }

    value(2; Timesheet)
    {
        Caption = 'Timesheet Salary';
    }

    value(3; Commission)
    {
        Caption = 'Commission Salary';
    }

    value(4; Target)
    {
        Caption = 'Target Salary';
    }
}
