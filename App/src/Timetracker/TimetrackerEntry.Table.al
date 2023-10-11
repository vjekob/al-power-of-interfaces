namespace Demo.Salary;

using Microsoft.HumanResources.Employee;

table 60103 TimetrackerEntry
{
    Caption = 'Timetracker Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }

        field(2; Date; Date)
        {
            Caption = 'Date';
        }

        field(3; Hours; Decimal)
        {
            Caption = 'Hours';
        }
    }

    keys
    {
        key(PK; "Employee No.", Date)
        {
            Clustered = true;
        }
    }
}
