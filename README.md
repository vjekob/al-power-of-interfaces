# Interface Segregation Principle

In this exercise, you implement the improvements that follow the Interface Segregation Principle.

## Problem Statement

At this point your code follows a lot of best practices and good principles, but there are still issues. You have massive amounts of duplication across your implementation codeunits, you have many methods that do nothing, all of which indicates that your code possibly violates the Interface Segregation Principle.

## Fixing the `ISalaryCalculator` interface

The `ISalaryCalculator` interface contains three methods. The first one, `CalculateBaseSalary` contains exactly the same code in four different implementation codeunits, and one one implementation provides a different calculation. The same is true about the `CalculateIncentive` method. The only method that provides five distinct implementations is `CalculateBonus`.

By splitting this interface into three distinct interfaces, we can eliminate all duplication from the `ISalaryCalculator` implementations.

1. Create three interfaces called `IBaseSalaryCalculator`, `IBonusCalculator` and `IIncentiveCalculator`, and move the three methods from the `ISalaryCalculator` interface into the matching new interface. Delete the `ISalaryCalculator` interface.

2. Create a new codeunit named `DefaultBaseSalaryCalculator` that implements the `IBaseSalaryCalculator` interface and copy the code from `CalculateBaseSalary` function in `SalaryCalculatorFixed` into it.

3. Create a new codeunit named `DefaultIncentiveCalculator` that implements the `IIncentiveCalculator` interface and copy the code from `CalculateIncentive` function in `SalaryCalculatorFixed` into it.

4. Delete the `SalaryCalculatorFixed` codeunit.

5. Rename each of remaining `SalaryCalculator...` codeunits into `BonusCalculator...`. In each of them, change the `implements` clause to `IBonusCalculator`, and then remove the `CalculateBaseSalary` and `CalculateIncentive` functions.

6. Create two new codeunits named `NoBaseSalary` and `NoIncentive` that implement the respective interfaces. Inside each of the implementations, exit with 0 explicitly.

    > It's always better to indicate your intention explicitly when implementing interfaces. In this case, you could have just left the implementation bodies empty, but that doesn't explain your intention as well as `exit(0)` does.

7. For `SalesType` enum, change the `implements` clause to specify the three new calculator interfaces instead of the original one. Add the `DefaultImplementation` property and specify both default implementations (for base salary and incentives) as defaults. Then modify each of the salary types by changing implementations according to the changes you did before. Finally, for the `Performance` value, specify `NoBaseSalary` and `NoIncentive` as implementations for respective interfaces.

## Fixing the `ISeniorityBonus` interface

The `ISeniorityBonus` interface has some problems, too. Two of the implementations share the exact same code for the `CalculateBonus` method. Also, two of the implementations provide no implementation for `CalculateIncentive` method. Again, this indicates problems with interface segregation.

A further problem that we can also identify is that there is no need to have multiple interfaces defining essentially the same methods. Since `CalculateBonus` and `CalculateIncentive` methods are already defined in their respective interfaces, then we could take advantage of those interfaces and in some way have the `Seniority` enum use them, too. Technically, if - instead of implementing the `ISeniorityBonus` interface, we make the `Seniority` enum implement `IBonusCalculator` and `IIncentiveCalculator`, and then provide matching implementations, we would resolve all duplication issues we have here.

However, this would not solve the problem we had earlier that we solved by adding the `ISeniorityBonus` interface. We cannot just assign different bonus and incentive calculators to different seniority levels, because the actual calculation depends both on seniority and salary calculation model.

The business logic says that bonus and incentive calculation depend first on seniority level, and only if seniority level does not provide its own implementation, should we select the calculation from the salary model. This is not something we can achieve simply by statically declaring interface implementations in `SalaryType` and `Seniority` enums - we need to write some code that makes this decision.

What we can do, though, is rethink our `ISeniorityBonus` interface to still take advantage of our new specific interfaces for bonus and incentive calculation. Instead of simply answering `true` or `false` to question of "do you provide your own implementation?", we could turn the `ISeniorityBonus` interface into a type of factory that we can use to create a relevant instance of `IBonusCalculator` and `IIncentiveCalculator` instance.

1. Create two new codeunits called `TeamBonus` and `TeamIncentive` and have them implement the `IBonusCalculator` and `IIncentiveCalculator` interfaces respectively. Then move the relevant team bonus and incentive calculations from `SeniorityBonusManager` codeunit into them.

2. Delete the `ISeniorityBonus` interface and all codeunits that implement it.

3. Create a new `ISeniorityScheme` interface and have it declare these two methods:
   ```AL
    procedure GetBonusCalculator(Employee: Record Employee): Interface IBonusCalculator;
    procedure GetIncentiveCalculator(Employee: Record Employee): Interface IIncentiveCalculator;
   ```

    > Since seniority level has precendence over salary model when deciding how to calculate bonus or incentives, the idea here is that we ask the seniority to provide us with an instance of bonus and incentive calculators. If a seniority level provides its own implementation of these interfaces, it can return those instances, otherwise it uses the `Employee` record to retrieve those instances from their `SalaryType` field. This way we can elegantly solve the problem of interdependency between seniority and salary type and remove all code duplication at the same time.

4. Create a new codeunit called `DefaultSeniorityScheme` that implements the `ISeniorityScheme` interface. Exit both functions with `Employee.SalaryType` value.

    > This performs the implicit factory work by converting the `SalaryType` enum value to an instance of an interface you are returning from the method. You can use this seniority scheme for those seniority levels that do not provide their own implementation but fall back to salary model rules.

5. Create new codeunit called `SenioritySchemeNone` that implements the `ISeniorityScheme` interface. Exit both functions with an instance of `NoBonus` and `NoIncentive` codeunits respectively.

6. Create new codeunits called `SenioritySchemeManager` and `SenioritySchemeDirector` that implement the `ISeniorityScheme` interface, and have them return instances of `TeamBonus`, `TeamIncentive`, and `NoIncentive` as appropriate according to their business rules.

> Some of your bonus and incentive implementation codeunits may not compile at this time. That's because That's because some implementations depend on `StratingDate` and `EndingDate` and some depend only on `AtDate`. Since each of implementations that depend on `StartingDate` and `EndingDate` can obtain them easily based on `AtDate`, we have simplified the signatures by providing the minimum set of input needed by all implementations to be able to perform their work.

7. In `SalaryCalculate` codeunit, create this public function:
    ```AL
    procedure GetMonthForDate(AtDate: Date; var StartingDate: Date; var EndingDate: Date)
    begin
        StartingDate := CalcDate('<CM+1D-1M>', AtDate);
        EndingDate := CalcDate('<CM>', AtDate);
    end;
    ```

8. Call this function from all those bonus and incentive calculation codeunits that do not compile at this point to obtain their starting and ending dates.

## Finishing the changes

Now that you have nicely sorted out all of your interface segregation issues, the code in `SalaryCalculate` codeunit doesn't compile anymore. Let's fix that.

1. At the beginning of the `CalculateSalary` function, extract an instance of `ISeniorityScheme` from employee's `Seniority` field. Then use this instance to obtain instances of `IBonusCalculator` and `IIncentiveCalculator`.

2. Simplify the `if...then` logic for bonus and incentive calculation by simply invoking the calculations on the instances you have obtained in the previous step. At this point, during execution, those variables will contain the correct implementation of `IBonusCalculator` and `IIncentiveCalculator` interfaces, because the factory methods in `ISeniorityScheme` took responsibility of providing them.

3. Cleanup any remaining unneeded variables and code from this codeunit.

