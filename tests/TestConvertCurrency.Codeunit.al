namespace Demo.Exercise1;

using Microsoft.Finance.Currency;

codeunit 50140 TestCovertCurrency
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryERM: Codeunit "Library - ERM";
        Assert: Codeunit Assert;
        ConvertCurrency: Codeunit ConvertCurrency;

    [Test]
    procedure Test_01_ConvertCurrency_Success()
    var
        CurrencyFrom, CurrencyTo : Record Currency;
        Permission: Record CurrencyExchPermission;
        ExchangeLog: Record CurrencyExchangeLog;
        Amount: Decimal;
    begin
        // [GIVEN] Two currencies
        LibraryERM.CreateCurrency(CurrencyFrom);
        LibraryERM.CreateCurrency(CurrencyTo);

        // [GIVEN] Exchange rate between the two currencies
        LibraryERM.CreateExchangeRate(CurrencyFrom.Code, WorkDate(), 10, 10);
        LibraryERM.CreateExchangeRate(CurrencyTo.Code, WorkDate(), 0.1, 0.1);

        // [GIVEN] Permission to exchange between two currencies
        Permission."From Currency Code" := CurrencyFrom.Code;
        Permission."To Currency Code" := CurrencyTo.Code;
        Permission."User ID" := UserId();
        Permission.Insert();

        // [WHEN] Convert currency
        Amount := ConvertCurrency.Convert(1, CurrencyFrom.Code, CurrencyTo.Code);

        // [THEN] Amount is converted
        Assert.AreEqual(0.01, Amount, 'Amount is not converted correctly');

        // [THEN] Log entry is written
        ExchangeLog.FindLast();
        Assert.AreEqual(CurrencyFrom.Code, ExchangeLog."From Currency Code", 'From currency code is not correct');
        Assert.AreEqual(CurrencyTo.Code, ExchangeLog."To Currency Code", 'To currency code is not correct');
        Assert.AreEqual(1, ExchangeLog."From Amount", 'From amount is not correct');
        Assert.AreEqual(0.01, ExchangeLog."To Amount", 'To amount is not correct');
        Assert.AreEqual(UserId(), ExchangeLog."User ID", 'User ID is not correct');
    end;

    [Test]
    procedure Test_02_ConvertCurrency_NoPermission_Fails()
    var
        CurrencyFrom, CurrencyTo : Record Currency;
        ExchangeLog1, ExchangeLog2 : Record CurrencyExchangeLog;
        Amount: Decimal;
    begin
        // [GIVEN] Two currencies
        LibraryERM.CreateCurrency(CurrencyFrom);
        LibraryERM.CreateCurrency(CurrencyTo);

        // [GIVEN] Exchange rate between the two currencies
        LibraryERM.CreateExchangeRate(CurrencyFrom.Code, WorkDate(), 10, 10);
        LibraryERM.CreateExchangeRate(CurrencyTo.Code, WorkDate(), 0.1, 0.1);

        // [GIVEN] No permission to exchange between two currencies

        // [GIVEN] Last log entry
        if ExchangeLog1.FindLast() then;

        // [WHEN] Attempting to convert currency
        asserterror ConvertCurrency.Convert(1, CurrencyFrom.Code, CurrencyTo.Code);

        // [THEN] An error must have occurred

        // [THEN] There must be no new log entries
        if ExchangeLog2.FindLast() then;
        Assert.AreEqual(ExchangeLog1."Entry No.", ExchangeLog2."Entry No.", 'Log entry was written');
    end;

    [Test]
    procedure Test_03_ConvertCurrency_NoFromExchangeRate_Fails()
    var
        CurrencyFrom, CurrencyTo : Record Currency;
        ExchangeLog1, ExchangeLog2 : Record CurrencyExchangeLog;
        Permission: Record CurrencyExchPermission;
        Amount: Decimal;
    begin
        // [GIVEN] Two currencies
        LibraryERM.CreateCurrency(CurrencyFrom);
        LibraryERM.CreateCurrency(CurrencyTo);

        // [GIVEN] Exchange rate only for "To" currency
        LibraryERM.CreateExchangeRate(CurrencyTo.Code, WorkDate(), 0.1, 0.1);

        // [GIVEN] Permission to exchange between two currencies
        Permission."From Currency Code" := CurrencyFrom.Code;
        Permission."To Currency Code" := CurrencyTo.Code;
        Permission."User ID" := UserId();
        Permission.Insert();

        // [GIVEN] Last log entry
        if ExchangeLog1.FindLast() then;

        // [WHEN] Attempting to convert currency
        asserterror ConvertCurrency.Convert(1, CurrencyFrom.Code, CurrencyTo.Code);

        // [THEN] An error must have occurred

        // [THEN] There must be no new log entries
        if ExchangeLog2.FindLast() then;
        Assert.AreEqual(ExchangeLog1."Entry No.", ExchangeLog2."Entry No.", 'Log entry was written');
    end;

    [Test]
    procedure Test_04_ConvertCurrency_NoToExchangeRate_Fails()
    var
        CurrencyFrom, CurrencyTo : Record Currency;
        ExchangeLog1, ExchangeLog2 : Record CurrencyExchangeLog;
        Permission: Record CurrencyExchPermission;
        Amount: Decimal;
    begin
        // [GIVEN] Two currencies
        LibraryERM.CreateCurrency(CurrencyFrom);
        LibraryERM.CreateCurrency(CurrencyTo);

        // [GIVEN] Exchange rate only for "From" currency
        LibraryERM.CreateExchangeRate(CurrencyFrom.Code, WorkDate(), 0.1, 0.1);

        // [GIVEN] Permission to exchange between two currencies
        Permission."From Currency Code" := CurrencyFrom.Code;
        Permission."To Currency Code" := CurrencyTo.Code;
        Permission."User ID" := UserId();
        Permission.Insert();

        // [GIVEN] Last log entry
        if ExchangeLog1.FindLast() then;

        // [WHEN] Attempting to convert currency
        asserterror ConvertCurrency.Convert(1, CurrencyFrom.Code, CurrencyTo.Code);

        // [THEN] An error must have occurred

        // [THEN] There must be no new log entries
        if ExchangeLog2.FindLast() then;
        Assert.AreEqual(ExchangeLog1."Entry No.", ExchangeLog2."Entry No.", 'Log entry was written');
    end;
}