namespace Demo.Salary;

page 60107 MonhtlySalaryPreview
{
    Caption = 'Salary Preview';
    SourceTable = MonthlySalary;
    PageType = StandardDialog;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            field(Date; Rec.Date)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date for which the salary is calculated';
            }

            field(Salary; Rec.Salary)
            {
                ApplicationArea = All;
                ToolTip = 'Contains the calculated base salary for the specified date';
            }

            field(Bonus; Rec.Bonus)
            {
                ApplicationArea = All;
                ToolTip = 'Contains the calculated bonus for the specified date';
            }

            field(Incentive; Rec.Incentive)
            {
                ApplicationArea = All;
                ToolTip = 'Contains the calculated incentive for the specified date';
            }

            field(Total; Rec.Salary + Rec.Bonus + Rec.Incentive)
            {
                ApplicationArea = All;
                ToolTip = 'Contains the calculated total salary for the specified date';
            }
        }
    }
}
