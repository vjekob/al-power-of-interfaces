namespace Demo.Salary;

page 60100 TimetrackerSetup
{
    Caption = 'Timetracker Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    SourceTable = TimetrackerSetup;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(ServiceURL; Rec."Service URL")
                {
                    ToolTip = 'The URL of the Timetracker service.';
                }

                field(ServiceUser; Rec."Access Key")
                {
                    ToolTip = 'Access key for the Timetracker service.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;
}