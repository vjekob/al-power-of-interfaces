# Single Responsibility Principle

In this exercise, you implement the improvements that follow the Single Responsibility Principle.

## Instructions

1. Create an interface that describes a bonus calculator. The interface should look like this:
    ```AL
    namespace Demo.Salary;

    using Microsoft.HumanResources.Employee;

    interface IBonusCalculator
    {
        procedure Initialize(Employee: Record Employee; Setup: Record SalarySetup; StartingDate: Date; EndingDate: Date);
        procedure CalculateBonus(Salary: Decimal): Decimal;
    }        
    ```
    > Hint: You choose not to implement the `CalculateSalary` function in the interface, because no matter what you do, there will be some code duplication: either the entire block that calculates base salary will have to be duplicated four times, or the block that invokes a new function would be duplicated. Also, since all salary calculators calculate the base salary in exact the same way, so there is no need to make it a responsibility of the interface (and thus of each of the implementations), but keep the responsibility inside the `SalaryCalculate` codeunit. You do a very similar thing for bonus and incentive calculation, thus delegating the responsibility for that work away from `CalculateSalary` function into separate functions.

2. Create four implementation codeunits, one for each type of salary: fixed, timesheet, commission, target.

3. Create a new function named `CalculateBaseSalary` in the `SalaryCalculate` codeunit and move the relevant base salary calculation block into this function. In other words, you delegate this work to this new function.

4. Since bonus calculation does not depend on type of salary calculator for managers, create a new function named `CalculateManagerBonus` and delegate the code responsible for calculating manager bonus into this function. Do the same for incentive calculation.

5. Move the relevant code from the `SalaryCalculate` codeunit to the new codeunits.

6. Move any relevant `TestField` invocations from `SalaryCalculate` to only those implementation codeunits that need them.

7. Make sure that the `CalculateSalary` function inside `SalaryCalculate` codeunit never reads the `Setup` record from the database. Instead, have this function receive the `Setup` record as a parameter, and create an overload of the function that does not receive the `Setup` record as a parameter. This overload should call the other overload, passing the `Setup` record as a parameter. This achieves that we don't break any existing code that calls the `CalculateSalary` function, while making database retrieval no longer the responsibility of this main salary calculation function.

    > Hint: to create an overload, simply create a function with the same name, but different signature, like this:
    >```AL
    >// Original signature
    >procedure CalculateSalary(var Employee: Record Employee; AtDate: Date) Result: Record MonthlySalary
    >// New signature
    >procedure CalculateSalary(var Employee: Record Employee; Setup: Record SalarySetup; AtDate: Date) Result: Record MonthlySalary
    >```

8. In `MonthlySalary` table, move the `AtDate` declaration from local variables into the function's signature as a parameter. Then create an overload for `CalculateMonthlySalaries` that retains the original signature. Move the `AtDate` calculation from original `CalculateMonthlySalaries` to this new overload, and invoke the original by passing `AtDate` into it as a parameter. This is primarily to improve the testability, but it also makes the original function have clearer responsibility.

