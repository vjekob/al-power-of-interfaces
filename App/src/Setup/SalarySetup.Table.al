namespace Demo.Salary;

using Microsoft.Finance.GeneralLedger.Account;

table 60100 SalarySetup
{
    Caption = 'Salary Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            NotBlank = true;
        }

        field(2; BaseSalary; Decimal)
        {
            Caption = 'Base Salary';
        }

        field(3; MinimumHours; Decimal)
        {
            Caption = 'Minimum Hours';
        }

        field(4; OvertimeThreshold; Decimal)
        {
            Caption = 'Overtime Threshold';
        }

        field(5; YearlyIncentivePct; Decimal)
        {
            Caption = 'Yearly Incentive %';
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

}
