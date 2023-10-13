# Liskov Substitution Principle

In this exercise, you implement the improvements that follow the Liskov Substitution Principle.

## Scenario

The customer wants to implement a new time tracking system. Instead of using Timesheets from BC, they want to use a new, automated, smart-card based cloud system named "Timetracker". Some employees will still keep using the old system, and eventually, after [*canary release*](https://en.wikipedia.org/wiki/Feature_toggle#Canary_release) period, everyone will migrate to the new system, and abandon the old system.

The customer is not 100% convinced that the new system is going to pass this canary release, and maybe after a few months they realize that they want something else.

The solution you develop must be ready to accept any future time tracking system without much effort from your side.

## Problem statement

Sometimes you have a single task that may be achieved in different ways. Remember the "Print Button" example from the introduction where the button didn't have to know exactly how the printing will be achieved - any printer you choose will get the job done. Or, remember the scale example in which you may want to exchange your default (Tefal) scale with a different one (B-TEK or Mettler-Toledo) and you also wanted to be able to configure different customers with different scale types, all while not having to change any of the existing code.

When code is tightly coupled (again, remember the starting point of the scale demo), you cannot replace the existing scale functionality with a different one without changing the code. This is a violation of the Liskov Substitution Principle. Liskov Substitution Principle states that you should be able to replace any instance of a class with an instance of its subclass without breaking the code. In other words, you should be able to replace any implementation of an interface with a different implementation of the same interface without breaking the code.

## Instructions

1. Create a new interface called `IWorkHoursProvider` that will be used to get the work hours for a given employee. The interface should have a single method:
   ```AL
   procedure CalculateHours(Employee: Record Employee; StartingDate: Date; EndingDate: Date): Decimal;
   ```

2. Create a codeunit called `BCWorkHoursProvider` that implements the `IWorkHoursProvider` interface. Move the code from `SalaryCalculatorTimesheet` that calculates work hours based on BC TimeSheet headers and lines into the implementation inside `BCWorkHoursProvider`.

3. You need another codeunit called `TimetrackingWorkHoursProvider` that implements the `IWorkHoursProvider` interface and reads the data from the Timetracker cloud system. This codeunit should implement the API protocol of Timetracker, read the data from the cloud, write it to the database, and return the calculated work hours.

> Hint: **DO NOT** create this codeunit. It is provided for you already. You can find it inside the `Timetracker` folder that already contains some more objects you need for Timetracker (setup table and page, a table to keep Timetracker entries, and a factbox to present those entries on the Employee card). The code in this codeunit is commented out to not cause any compile-time errors that may result from different naming you used for the interface or its methods.

4. Uncomment the code in `TimetrackingWorkHoursProvider` codeunit.

5. Add a new field to the `Employee` table called `TimetrackerEmployeeId` of type `Text[10]`. This field will be used to store the ID of the employee in the Timetracker cloud system. Add the same field to the `Employee Card` page.

6. Add a new action to the `Employee Card` page:
    ```AL
        action(GetTimetrackerData)
        {
            Caption = 'Get Timetracker Data';
            Promoted = true;
            Image = Timesheet;
            ApplicationArea = All;
            ToolTip = 'Gets employee''s worksheet data from Timetracker.';

            trigger OnAction()
            var
                TimetrackerProvider: Codeunit TimetrackerWorkHoursProvider;
            begin
                TimetrackerProvider.CalculateHours(Rec, WorkDate(), WorkDate());
                CurrPage.Update(false);
            end;
        }
    ```
6. You need a way to provide the correct implementation of the `IWorkHoursProvider` interface to the `SalaryCalculatorTimesheet` codeunit. Create a new function in the `EmployeeExt` table extension that will serve as a factory for this interface:
    ```AL
    internal procedure GetWorkHoursProvider(): Interface IWorkHoursProvider
    var
        BCWorkHoursProvider: Codeunit BCWorkHoursProvider;
        TimetrackerWorkHoursProvider: Codeunit TimetrackerWorkHoursProvider;
    begin
        if Rec.TimetrackerEmployeeId <> '' then
            exit(TimetrackerWorkHoursProvider)
        else
            exit(BCWorkHoursProvider);
    end;
    ```

7. Modify the code in `SalaryCalculatorTimesheet` codeunit to retrieve the correct implementation of the `IWorkHoursProvider` interface and then call this interface to calculate work hours. You do this in place of the original code that used timesheets to calculate work hours.

At this point, you applied Liskov Substitution Principle by making it possible to substitute one type of work hours calculation with any other without changing `SalaryCalculatorTimesheet` (its consumer) ever in the future. As long as you retain your factory function in the `Employee` table, you can always just add more implementations of the `IWorkHoursProvider` interface and maintain the factory function accordingly. Substituting one workhours calculator with another one has no influence on correctness of the entire salary calculation process.

> Hint: you could have added an enum for this, it would have achieved the same. However, the point of this exercise was to show that enums are not the only way of addressing the dependency substitution problem, and that simple factory functions can often be used instead. It all depends on your end goals. If you intend for third parties to be able to add their own work hours providers, then you would have done it with an enum. If you intend to fully control the process, then the approach you just did works better (especially for canary release or other types of continuous deployment techniques).

## Configuring Timetracker

You can configure your Timetracker integration in the `TimetrackerSetup` page by providing the following info:

| Field       | Value                                                      |
| ----------- | ---------------------------------------------------------- |
| Service URL | `https://demo-timetracker.azurewebsites.net`               |
| Access Key  | `41gbjkHHRgdpXNFdOFLs71QLnOP0OXFe2z_XMzd0oNpRAzFudh-lHA==` |

You can use any of these employee IDs to configure the Timetracker integration for some employees. Do not pick the first one, just pick a random one.

```
9gIeqbZs
0Rqv01eg
xq3l0wlB
CyxFSeIU
rcvLIiLo
7J3GBTsQ
k5LOfSsz
cG1ZRcmy
mqGulwuc
4fHOMXm5
AQL9vMCI
QwKraAPf
66idIoXV
hEtGUtPs
ZCuClZ5H
4BHbJc56
3exRy1m8
vxuwlRMh
xjcoqK3U
O91YVS1W
0pHQ1PTk
Qlzdjexz
AvgLX00V
VjTXEqRF
sMVKduMb
qsU1me8V
m2LVznkD
38XeFnXh
hH5Atq95
XWSlpz4Q
tOjWmj8v
8sW4WHkS
aI6lB87j
MZHnmULv
OjiEKymc
qAM16m9U
VOCMrP38
lbzBaxC5
jCGg5qEI
5oDv0CIy
```

There is also a file named `test.azure.http` that uses the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for Visual Studio Code. You can use this file to test the Timetracker API, learn about about its integration protocol, and see why the implementation in `TimetrackerWorkHoursProvider` codeunit is the way it is.
