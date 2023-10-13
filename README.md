# Open Closed Principle

In this exercise, you implement the improvements that follow the Open Closed Principle.

## Scenario

The customer has decided to implement a new salary calculation model. This one has no base salary at all, and calculates bonus based on company performance. It rewards the employees in special roles, who are willing to take personal responsibility in the company's overall success, by allowing them to share on the profits on the company.

You realize that to accommodate for this change, you need to change existing code, potentially breaking both the code and tests. You anticipate that in the future the customer may want to implement even more different salary calculation models, and want to make sure that any future additions follow the Open Closed Principle.

## Instructions

1. Create a new interface named `ISalaryCalculator` with methods for calculating base salary, bonus, and incentive.
   > Hint: If you are a copy/paste person, here's the code for you:
   > ```AL
   > namespace Demo.Salary;
   >
   > using Microsoft.HumanResources.Employee;
   >
   > interface ISalaryCalculator
   > {
   >     procedure CalculateBaseSalary(Employee: Record Employee; Setup: Record SalarySetup): Decimal;
   >     procedure CalculateBonus(Employee: Record Employee; Setup: Record SalarySetup; Salary: Decimal; StartingDate: Date; EndingDate: Date): Decimal;
   >     procedure CalculateIncentive(Employee: Record Employee; Setup: Record SalarySetup; Salary: Decimal; AtDate: Date): Decimal;
   > }
   >```

2. Create four codeunits, one each for fixed, timesheet, commission, and target calculation models. All four must implement `ISalaryCalculator`. Copy the relevant code from `SalaryCalculate` codeunit into these codeunits, so that each of those codeunits performs the full work of what the original functions did in `SalaryCalculate` where you copied them from.

    > Hint: At this point, you'll see that you are generating a lot of duplication, and duplication is never good. However, you'll fix that in one of the next exercises. In real life, duplicated code very often occurs and when it does, it's usually an indicator of other problems. We'll cover those problems when we talk about Liskov Substitution Principle and Interface Segregation Principle. So, for now, just keep the duplication.

3. Modify the `SalaryType` enum to add the `implements` clause for your new interface. Provide a matching implementation for each of the enum values.

4. Modify the code inside the `CalculateSalary` function in the `SalaryCalculate` codeunit to retrieve the correct implementation of `ISalaryCalculator` interface from `SalaryType`, and then invoke the methods from the interface, instead of calling local functions you copied into interface implementations.

5. Clean up the code inside the `SalaryCalculate` codeunit to remove any remaining unused code or `using` declarations.

> At this point, you have correctly implemented the Open Closed Principle by allowing easy addition of a new implementation. Good job!

## Extending without modification

In this task, you take advantage of the fact that your solution now supports Open Closed Principle. You are going to add a new salary calculation model without touching any of the existing code that calculates salaries.

1. Create a new codeunit named `SalaryCalculatorPerformance` that implements the `ISalaryCalculator` interface and provides the new performance-based salary calculation model. This model has no base salary and no incentives. Bonus calculation for this model works like this:
    ```AL
    procedure CalculateBonus(Employee: Record Employee; Setup: Record SalarySetup; Salary: Decimal; StartingDate: Date; EndingDate: Date) Bonus: Decimal;
    var
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        Income: Decimal;
        Expense: Decimal;
        Profit: Decimal;
    begin
        GLEntry.SetRange("Posting Date", StartingDate, EndingDate);

        GLAccount.Get(Setup.IncomeAccountNo);
        GLEntry.SetFilter("G/L Account No.", GLAccount.Totaling);
        GLEntry.CalcSums(Amount);
        Income := GLEntry.Amount;

        GLAccount.Get(Setup.ExpenseAccountNo);
        GLEntry.SetFilter("G/L Account No.", GLAccount.Totaling);
        GLEntry.CalcSums(Amount);
        Expense := GLEntry.Amount;

        Profit := Income - Expense;
        if (Profit > 0) then
            Bonus := (Employee.PerformanceBonusPct / 100) * Profit;
    end;
    ```

2. The function above does not compile. You need to add fields `IncomeAccountNo` and `ExpenseAccountNo` to the `SalarySetup` table. Both fields should define this property: `TableRelation = "G/L Account" where("Account Type" = const(Total));`. Also, add a new field `PerformanceBonusPct` to the `Employee` table.

3. Add a new value to the `SalaryType` enum, named `Performance`, and provide a matching implementation for it.

> At this point, you are already reaping fruit from the fact that your code has supported the Open Closed Principle: to add a new model, the only thing you had to do was provide its implementation. Adding new models in the future will be equally simple for you, or for anyone else who extends your app.

## Going one step further

You notice that while you correctly managed to get rid of any explicit decisions (`case` blocks) that handled `SalaryType`, but you still have many decision points that introduce logical branching around the `Seniority` of an employee. For example, bonus is different for managers and directors than for other levels, and incentives are different for managers than for other levels. Adding more seniority levels in the future would require you to modify your code, and extending it by third-party apps would be outright impossible. Both of these things violate the Open Closed Principle, so you decide to fix that, too!

1. Create a new interface named `ISeniorityBonus` like this:

    ```AL
    namespace Demo.Salary;

    using Microsoft.HumanResources.Employee;

    interface ISeniorityBonus
    {
        procedure ProvidesBonusCalculation(): Boolean;
        procedure ProvidesIncentiveCalculation(): Boolean;
        procedure CalculateBonus(Employee: Record Employee; AtDate: Date): Decimal;
        procedure CalculateIncentive(Employee: Record Employee; AtDate: Date): Decimal
    }
    ```

2. Create a default implementation that returns `false` from both `Provides...` methods, and provides no code inside the other two methods. 

3. Create a manager implementation that returns `true` from both `Provides...` methods. Move the appropriate code from `CalculateTeamBonus` and `CalculateTeamIncentive` functions of any of salary calculation codeunits (all contain the exact same code, so it doesn't matter which one) into this codeunit.

4. Create a director implementation that returns `true` from both `Provides...` methods. Move the appropriate code from `CalculateTeamBonus` function, just like you did in the previous step. Do not provide any calculation for `CalculateIncentive` as directors don't have incentives.

5. Modify all salary calculation codeunits to remove any logic that checks `Seniority`. Those codeunits provide the existing incentive calculation. The team-based calculation is moved to the new interface and its implementations. Remove any unnecessary functions from all of them (`CalculateTeamBonus` and `CalculateIncentive`).

6. In `SalaryCalculate` retrieve the correct implementation of `ISeniorityBonus` interface from `Seniority` of the employee, and then invoke the `CalculateBonus` and `CalculateIncentive` from `ISeniorityBonus` if it provides own implementation, and otherwise call it from `ISalaryCalculator`. Do the same for incentive calculation.

> At this point, you have fully supported Open Closed Principle on all your enums, making them extensible without any further need for changes. Anyone can add new seniority levels with their own custom logic, without ever requiring any changes in your existing code.

