namespace Demo.Salary;

page 60105 SenioritySetup
{
    Caption = 'Seniority Setup';
    SourceTable = SenioritySetup;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(Seniority; Rec.Seniority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the seniority level to which this setup applies.';
                }

                field(BaseSalary; Rec.BaseSalary)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base salary for this seniority level.';
                }
            }
        }
    }
}
