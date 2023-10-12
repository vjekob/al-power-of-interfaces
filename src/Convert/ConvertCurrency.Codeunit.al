namespace Demo.Exercise1;

using Microsoft.Finance.Currency;

codeunit 50100 ConvertCurrency
{
    procedure Convert(FromAmount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]) Result: Decimal
    var
        Permission: Record CurrencyExchPermission;
        ExchRate: Record "Currency Exchange Rate";
        ExchangeLog: Record CurrencyExchangeLog;
    begin
        // Check permissions
        Permission.SetRange("User ID", UserID);
        Permission.SetFilter("From Currency Code", '%1|%2', '', FromCurrencyCode);
        Permission.SetFilter("To Currency Code", '%1|%2', '', ToCurrencyCode);
        if not Permission.FindFirst() then
            Error('Currency exchange is not allowed for %1 from %2 to %3.', UserId, FromCurrencyCode, ToCurrencyCode);

        // Perform conversion
        Result := ExchRate.ExchangeAmtFCYToFCY(WorkDate(), FromCurrencyCode, ToCurrencyCode, FromAmount);

        // Log operation
        ExchangeLog."Date and Time" := CurrentDateTime;
        ExchangeLog."User ID" := UserID;
        ExchangeLog."From Currency Code" := FromCurrencyCode;
        ExchangeLog."To Currency Code" := ToCurrencyCode;
        ExchangeLog."From Amount" := FromAmount;
        ExchangeLog."To Amount" := Result;
        ExchangeLog.Insert();
    end;
}
