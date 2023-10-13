// namespace Demo.Salary;

// using Microsoft.HumanResources.Employee;

// codeunit 60110 TimetrackerWorkHoursProvider implements IWorkHoursProvider
// {
//     procedure CalculateHours(Employee: Record Employee; StartingDate: Date; EndingDate: Date): Decimal;
//     var
//         Ticket: Text;
//         TicketResult: JsonArray;
//         Token: JsonToken;
//         Entry: JsonObject;
//         Value: Text;
//         EntryDate: Date;
//         Hours: Decimal;
//         CannotParseResponseErr: Label 'Error parsing response from Timetracker';
//     begin
//         Ticket := GetTimetrackerTicket(Employee, WorkDate());
//         while GetTimetrackerTicketStatus(Ticket) <> 'done' do
//             Sleep(1000);
//         TicketResult := GetTimetrackerTicketResult(Ticket);
//         foreach Token in TicketResult do begin
//             if not Token.IsObject() then
//                 Error(CannotParseResponseErr);
//             Entry := Token.AsObject();

//             if not Entry.Get('date', Token) or not Token.IsValue() then
//                 Error(CannotParseResponseErr);
//             Value := Token.AsValue().AsText();
//             Evaluate(EntryDate, Value);

//             if not Entry.Get('hours', Token) or not Token.IsValue() then
//                 Error(CannotParseResponseErr);
//             Value := Token.AsValue().AsText();
//             Evaluate(Hours, Value);

//             WriteTimetrackerEntry(Employee, EntryDate, Hours);
//         end;
//     end;

//     local procedure WriteTimetrackerEntry(Employee: Record Employee; Date: Date; Hours: Decimal)
//     var
//         TimetrackerEntry: Record TimetrackerEntry;
//     begin
//         TimetrackerEntry.Init();
//         TimetrackerEntry."Employee No." := Employee."No.";
//         TimetrackerEntry.Date := Date;
//         if not TimetrackerEntry.Find('=') then begin
//             TimetrackerEntry.Hours := Hours;
//             TimetrackerEntry.Insert();
//         end;
//     end;

//     local procedure GetTimetrackerTicket(Employee: Record Employee; AtDate: Date): Text
//     var
//         TimetrackerSetup: Record TimetrackerSetup;
//         Client: HttpClient;
//         Request: HttpRequestMessage;
//         Response: HttpResponseMessage;
//         Content: Text;
//         Ticket: JsonObject;
//         Token: JsonToken;
//         Year, Month : Integer;
//         CannotGetTicketErr: Label 'Error getting ticket from Timetracker';
//         CannotParseResponseErr: Label 'Error parsing response from Timetracker';
//     begin
//         Year := Date2DMY(AtDate, 3);
//         Month := Date2DMY(AtDate, 2);
//         Employee.TestField(TimetrackerEmployeeId);
//         Request := TimetrackerSetup.CreateRequest(StrSubstNo('workhours/%1/%2/%3', Employee.TimetrackerEmployeeId, Year, Month));
//         Client.Send(Request, Response);
//         if not Response.IsSuccessStatusCode then
//             Error(CannotGetTicketErr);

//         Response.Content.ReadAs(Content);
//         if not Ticket.ReadFrom(Content) then
//             Error(CannotParseResponseErr);

//         Ticket.ReadFrom(Content);
//         if (not Ticket.Get('ticket', Token)) or not (Token.IsValue()) then
//             Error(CannotParseResponseErr);

//         exit(Token.AsValue().AsText());
//     end;

//     local procedure GetTimetrackerTicketStatus(Ticket: Text): Text
//     var
//         TimetrackerSetup: Record TimetrackerSetup;
//         Client: HttpClient;
//         Request: HttpRequestMessage;
//         Response: HttpResponseMessage;
//         Content: Text;
//         TicketStatus: JsonObject;
//         Token: JsonToken;
//         CannotGetTicketStatusErr: Label 'Error getting ticket status from Timetracker';
//         CannotParseResponseErr: Label 'Error parsing response from Timetracker';
//     begin
//         Request := TimetrackerSetup.CreateRequest(StrSubstNo('status/%1', Ticket));
//         Client.Send(Request, Response);
//         if not Response.IsSuccessStatusCode then
//             Error(CannotGetTicketStatusErr);

//         Response.Content.ReadAs(Content);
//         if not TicketStatus.ReadFrom(Content) then
//             Error(CannotParseResponseErr);

//         TicketStatus.ReadFrom(Content);
//         if (not TicketStatus.Get('status', Token)) or not (Token.IsValue()) then
//             Error(CannotParseResponseErr);

//         exit(Token.AsValue().AsText());
//     end;

//     local procedure GetTimetrackerTicketResult(Ticket: Text) Results: JsonArray
//     var
//         TimetrackerSetup: Record TimetrackerSetup;
//         Client: HttpClient;
//         Request: HttpRequestMessage;
//         Response: HttpResponseMessage;
//         Content: Text;
//         TicketStatus: JsonArray;
//         CannotGetTicketStatusErr: Label 'Error getting ticket data from Timetracker';
//         CannotParseResponseErr: Label 'Error parsing response from Timetracker';
//     begin
//         Request := TimetrackerSetup.CreateRequest(StrSubstNo('results/%1', Ticket));
//         Client.Send(Request, Response);
//         if not Response.IsSuccessStatusCode then
//             Error(CannotGetTicketStatusErr);

//         Response.Content.ReadAs(Content);
//         if not TicketStatus.ReadFrom(Content) then
//             Error(CannotParseResponseErr);

//         if not Results.ReadFrom(Content) then
//             Error(CannotParseResponseErr);
//     end;

// }