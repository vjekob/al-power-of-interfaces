namespace Demo.Salary;

page 60104 Departments
{
    Caption = 'Departments';
    PageType = List;
    SourceTable = Department;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the department.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the department.';
                }

                field(BaseSalary; Rec.BaseSalary)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base salary of the department.';
                }
            }
        }
    }
}
