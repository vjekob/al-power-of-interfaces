namespace Demo.Salary;

table 60106 SenioritySetup
{
    Caption = 'Seniority Setup';
    DataClassification = CustomerContent;
    LookupPageId = SenioritySetup;
    DrillDownPageId = SenioritySetup;

    fields
    {
        field(1; Seniority; Enum Seniority)
        {
            Caption = 'Seniority';
        }

        field(2; BaseSalary; Decimal)
        {
            Caption = 'Base Salary';
        }
    }
}
