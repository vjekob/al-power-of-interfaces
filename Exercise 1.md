# Exercise 1: Create your first interface

## Create Interface

Create an interface for document posting. It must have these methods:

```AL
procedure Confirm(): Boolean;
procedure Post(var SalesHeader: Record "Sales Header");
procedure Notify(MessageToShow: Text; IsError: Boolean);
```

## Implement Interface
Create three codeunits that implement this interface:
* WebClientPosting
* POSPosting
* APIPosting

In each of these codeunits, implement the logic in the simplest possible way. Just showing different messages to know that they executed is completely okay

## Provide Enum

Create an enum with corresponding options that maps each interface implementation to an enum value.

## Try

1. Add a new field to `Sales & Receivables Setup` table and page to allow users to specify which type of posting to use.
2. Add a new action to `Sales Order` page to invoke the configured posting routine

