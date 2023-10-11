permissionset 60100 Salary
{
    Assignable = true;
    Permissions = tabledata Department = RIMD,
        tabledata DepartmentSenioritySetup = RIMD,
        tabledata MonthlySalary = RIMD,
        tabledata SalarySetup = RIMD,
        tabledata SenioritySetup = RIMD,
        tabledata TimetrackerEntry = RIMD,
        tabledata TimetrackerSetup = RIMD,
        table Department = X,
        table DepartmentSenioritySetup = X,
        table MonthlySalary = X,
        table SalarySetup = X,
        table SenioritySetup = X,
        table TimetrackerEntry = X,
        table TimetrackerSetup = X,
        codeunit SalaryCalculate = X,
        page Departments = X,
        page DepartmentSenioritySetup = X,
        page MonthlySalaries = X,
        page SalarySetup = X,
        page SenioritySetup = X,
        page TimetrackerEntriesFactbox = X,
        page TimetrackerSetup = X;
}