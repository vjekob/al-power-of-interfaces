namespace Demo.Salary;

page 60102 SalarySetup
{
    Caption = 'Salary Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = SalarySetup;
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(BaseSalary; Rec.BaseSalary)
                {
                    ToolTip = 'Specifies the base salary for salary calculation';
                }

            }

            group(Timesheet)
            {
                Caption = 'Timesheet Calculation';

                field(MinimumHours; Rec.MinimumHours)
                {
                    ToolTip = 'Specifies the minimum hours for salary calculation';
                }

                field(OvertimeThreshold; Rec.OvertimeThreshold)
                {
                    ToolTip = 'Specifies the threshold over which overtime is paid';
                }
            }

            group(Incentive)
            {
                Caption = 'Incentive';

                field(YearlyIncrease; Rec.YearlyIncentivePct)
                {
                    ToolTip = 'Specifies the yearly increase in percentage';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert()
    end;
}