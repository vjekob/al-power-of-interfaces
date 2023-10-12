# Exercise 2: Create your first interface

## Split your interface

Split the interface you created in the first exercise into three interfaces:
* `IConfirmationProvider`
* `IPostingRoutine`
* `INotificationProvider`

Each of these interfaces declares only the single corresponding method from the original interface you created in Exercise 1.

You may delete the original interface, you won't need it anymore.

## Create codeunit implementations

Create two codeunits that implements `IConfirmationProvider`:
* `DialogConfirmationProvider`: it will show the dialog
* `AutoConfirmProvider`: it simply returns `true`

Create one codeunit that implements `IPostingRoutine`:
* `SalesPostRoutine`: in real life, this one would invoke the sales post codeunit, but here you may just show a message

Create two codeunits that implements `INotificationProvider`:
* `DialogNotificationProvider`: it will show the dialog
* `TelemetryNotificationProvider`: in real life, this one would send notifications to telemetry, but here you may just show a message

## Redefine your enum

In the original posting routine type enum you created in Exercise 1, remove the implementation definitions for the original interface from the enum itself and from all of its values.

Then, specify that the enum implements all three interfaces you created earlier in this exercise.

Then, declare the default implementation for `IPostingRoutine` to be `SalesPostRoutine`. Also, declare the default implementation for `IConfirmationProvider` to be `DialogConfirmationProvider`. **Do not declare a default implementation for `INotificationProvider`.**

Finally, declare how the values implement interfaces:
* `WebClientPosting` implements `IDialogNotificationProvider` through `DialogNotificationProvider` codeunit.
* `POSPosting` implements `IDialogNotificationProvider` through `DialogNotificationProvider` codeunit.
* `APIPosting` implements `IDialogNotificationProvider` through `TelemetryNotificationProvider` codeunit, and `IConfirmationProvider` through `AutoConfirmProvider` codeunit.

## Modify your consumer code

In your page extension for Sales Order, change the code to retrieve all three individual interfaces from the same enum value. Then invoke each individual method through its own interface.
