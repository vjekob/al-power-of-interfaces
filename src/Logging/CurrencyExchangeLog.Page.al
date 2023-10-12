namespace Demo.Exercise1;

page 50100 CurrencyExchangeLog
{
    Caption = 'Currency Exchange Log';
    PageType = List;
    SourceTable = CurrencyExchangeLog;
    Editable = false;
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Log)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Date and Time"; Rec."Date and Time")
                {
                    ApplicationArea = All;
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }

                field("From Currency Code"; Rec."From Currency Code")
                {
                    ApplicationArea = All;
                }

                field("To Currency Code"; Rec."To Currency Code")
                {
                    ApplicationArea = All;
                }

                field("From Amount"; Rec."From Amount")
                {
                    ApplicationArea = All;
                }

                field("To Amount"; Rec."To Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
