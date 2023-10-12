namespace Demo.Exercise1;

using System.Security.User;
using Microsoft.Finance.Currency;

table 50100 CurrencyExchangeLog
{
    Caption = 'Currency Exchange Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(2; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time';
            DataClassification = CustomerContent;
        }

        field(3; "User ID"; Text[50])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }

        field(4; "From Currency Code"; Code[10])
        {
            Caption = 'From Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }

        field(5; "To Currency Code"; Code[10])
        {
            Caption = 'To Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }

        field(6; "From Amount"; Decimal)
        {
            Caption = 'From Amount';
            DataClassification = CustomerContent;
        }

        field(7; "To Amount"; Decimal)
        {
            Caption = 'To Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Primary; "Entry No.") { }
    }
}
