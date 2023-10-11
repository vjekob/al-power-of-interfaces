namespace Demo.Salary;

table 60107 DepartmentSenioritySetup
{
    Caption = 'Department Seniority Setup';
    DataClassification = CustomerContent;
    LookupPageId = DepartmentSenioritySetup;
    DrillDownPageId = DepartmentSenioritySetup;

    fields
    {
        field(1; DepartmentCode; Code[10])
        {
            Caption = 'Department Code';
            TableRelation = Department;
        }

        field(2; Seniority; Enum Seniority)
        {
            Caption = 'Seniority';
        }

        field(3; BaseSalary; Decimal)
        {
            Caption = 'Base Salary';
        }
    }

    keys
    {
        key(PK; DepartmentCode, Seniority)
        {
            Clustered = true;
        }
    }
}
