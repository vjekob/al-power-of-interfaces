namespace Demo.Salary;

page 60103 MonthlySalaries
{
    Caption = 'Monthly Salaries';
    SourceTable = MonthlySalary;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Shows the entry number of the monthly salary.';
                }

                field(EmployeeNo; Rec.EmployeeNo)
                {
                    ToolTip = 'Indicates the employee number of the monthly salary.';
                }

                field(Date; Rec.Date)
                {
                    ToolTip = 'Shows the date of the monthly salary.';
                }

                field(SalaryAmount; Rec.Salary)
                {
                    ToolTip = 'Shows the salary amount of the monthly salary.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Caption = 'Calculate';
                Promoted = true;
                PromotedCategory = Process;
                Image = Calculate;

                trigger OnAction()
                begin
                    Rec.CalculateMonthlySalaries();
                end;
            }
        }
    }
}