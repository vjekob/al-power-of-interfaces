namespace Demo.Exercise1;

using System.Security.User;
using Microsoft.Finance.Currency;

table 50101 CurrencyExchPermission
{
    Caption = 'Currency Exchange Permission';

    fields
    {
        field(1; "User ID"; Text[50])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }

        field(2; "From Currency Code"; Code[10])
        {
            Caption = 'From Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }

        field(3; "To Currency Code"; Code[10])
        {
            Caption = 'To Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Primary; "User ID", "From Currency Code", "To Currency Code") { }
    }
}
