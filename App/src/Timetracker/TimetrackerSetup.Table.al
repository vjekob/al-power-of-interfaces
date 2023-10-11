namespace Demo.Salary;

table 60102 TimetrackerSetup
{
    Caption = 'Timetracker Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            NotBlank = true;
        }

        field(2; "Service URL"; Text[250])
        {
            Caption = 'Service URL';
        }

        field(3; "Access Key"; Text[250])
        {
            Caption = 'Access Key';
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure CreateRequest(Path: Text) Request: HttpRequestMessage
    var
        Headers: HttpHeaders;
    begin
        Rec.Get();
        Rec.TestField("Service URL");
        Rec.TestField("Access Key");

        Request.Method := 'GET';
        Request.SetRequestUri(StrSubstNo('%1/api/v2.0/%2', Rec."Service URL", Path));
        Request.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('X-Functions-Key', Rec."Access Key");
    end;
}
