namespace Demo.Salary;

table 60105 Department
{
    Caption = 'Department';
    DataClassification = CustomerContent;
    LookupPageId = Departments;
    DrillDownPageId = Departments;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
        }

        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }

        field(3; BaseSalary; Decimal)
        {
            Caption = 'Base Salary';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
