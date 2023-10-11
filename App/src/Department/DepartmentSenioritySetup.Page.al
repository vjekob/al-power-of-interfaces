page 60106 DepartmentSenioritySetup
{
    Caption = 'Department Seniority Setup';
    PageType = List;
    SourceTable = DepartmentSenioritySetup;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(DepartmentCode; Rec.DepartmentCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies department code for this setup line.';
                }

                field(Seniority; Rec.Seniority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies seniority for this setup line.';
                }

                field(BaseSalary; Rec.BaseSalary)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies base salary for this setup line.';
                }
            }
        }
    }
}
