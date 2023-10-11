namespace Demo.Salary;

page 60101 TimetrackerEntriesFactbox
{
    Caption = 'Timetracker Entries';
    PageType = ListPart;
    SourceTable = TimetrackerEntry;

    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Date of the timetracker entry';
                }

                field(Hours; Rec.Hours)
                {
                    ApplicationArea = All;
                    ToolTip = 'Hours logged at date';
                }
            }
        }
    }
}