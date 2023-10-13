# Single Responsibility Principle

In this exercise, you implement the improvements that follow the Single Responsibility Principle.

## Instructions

1. In `SalaryCalculate` codeunit, create three new functions: one to calculate base salary, one to calculate bonus, and one to calculate incentives. Then, delegate the work for base salary calculation, bonus calculation, and incentive calculation into those functions by removing it from the original function into these new functions.

2. Create a new function named `CalculateManagerBonus` and delegate the code responsible for calculating manager bonus into this function. Do the same for incentive calculation.

3. Move any relevant `TestField` invocations from the original place into relevant places in the new functions you created. With this, you make sure that the responsibility for testing individual fields needed for an individual function is only happening inside that function, and not in a central place like before.

4. Make sure that the `CalculateSalary` function inside `SalaryCalculate` codeunit never reads the `Setup` record from the database. Instead, have this function receive the `Setup` record as a parameter, and create an overload of the function that does not receive the `Setup` record as a parameter. This overload should call the other overload, passing the `Setup` record as a parameter. This achieves that we don't break any existing code that calls the `CalculateSalary` function, while making database retrieval no longer the responsibility of this main salary calculation function.

    > Hint: to create an overload, simply create a function with the same name, but different signature, like this:
    >```AL
    >// Original signature
    >procedure CalculateSalary(var Employee: Record Employee; AtDate: Date) Result: Record MonthlySalary
    >// New signature
    >procedure CalculateSalary(var Employee: Record Employee; Setup: Record SalarySetup; AtDate: Date) Result: Record MonthlySalary
    >```

5. In `MonthlySalary` table, move the `AtDate` declaration from local variables into the function's signature as a parameter. Then create an overload for `CalculateMonthlySalaries` that retains the original signature. Move the `AtDate` calculation from original `CalculateMonthlySalaries` to this new overload, and invoke the original by passing `AtDate` into it as a parameter. This is primarily to improve the testability, but it also makes the original function have clearer responsibility.

