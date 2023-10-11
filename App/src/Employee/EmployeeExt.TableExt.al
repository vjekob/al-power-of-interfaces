namespace Demo.Salary;

using Microsoft.HumanResources.Employee;

tableextension 60100 EmployeeExt extends Employee
{
    fields
    {
        field(60100; Seniority; Enum Seniority)
        {
            Caption = 'Seniority';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec.Seniority = xRec.Seniority then
                    exit;

                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then begin
                    Clear(Rec.CommissionBonusPct);
                    Clear(Rec.TargetRevenue);
                    Clear(Rec.TargetBonus);
                    Clear(Rec.MaximumTargetBonus);
                    Clear(Rec.MaximumTargetMalus);
                    Clear(Rec.TeamBonusPct);
                    Clear(Rec.TeamIncentivePct);
                end;

                if (xRec.Seniority in [Seniority::Manager, Seniority::Director]) and (not (Rec.Seniority in [Seniority::Manager, Seniority::Director])) then
                    Clear(Rec.TeamBonusPct);

                if (xRec.Seniority = Seniority::Manager) then
                    Clear(Rec.TeamIncentivePct);
            end;
        }

        field(60101; SalaryType; Enum SalaryType)
        {
            Caption = 'Salary Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec.SalaryType = xRec.SalaryType then
                    exit;

                case xRec.SalaryType of
                    SalaryType::Commission:
                        Clear(Rec.CommissionBonusPct);
                    SalaryType::Target:
                        begin
                            Clear(Rec.TargetBonus);
                            Clear(Rec.TargetRevenue);
                            Clear(MaximumTargetBonus);
                            Clear(MaximumTargetMalus);
                        end;
                end;
            end;
        }

        field(60102; DepartmentCode; Code[10])
        {
            Caption = 'Department Code';
            TableRelation = Demo.Salary.Department;
        }

        field(60103; BaseSalary; Decimal)
        {
            Caption = 'Base Salary';
            DataClassification = CustomerContent;
        }

        field(60104; CommissionBonusPct; Decimal)
        {
            Caption = 'Commission Bonus %';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(SalaryType, SalaryType::Commission);
                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60105; TargetRevenue; Decimal)
        {
            Caption = 'Target Revenue';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(SalaryType, SalaryType::Target);
                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60106; TargetBonus; Decimal)
        {
            Caption = 'Target Bonus';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(SalaryType, SalaryType::Target);
                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60107; MaximumTargetBonus; Decimal)
        {
            Caption = 'Minimum Hours';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(SalaryType, SalaryType::Target);
                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60108; MaximumTargetMalus; Decimal)
        {
            Caption = 'Maximum Malus';
            DataClassification = CustomerContent;
            MaxValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(SalaryType, SalaryType::Target);
                if Rec.Seniority in [Seniority::Trainee, Seniority::Executive] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60110; TeamBonusPct; Decimal)
        {
            Caption = 'Team Bonus %';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec.Seniority in [Seniority::Manager, Seniority::Director] then
                    Rec.FieldError(Seniority);
            end;
        }

        field(60111; TeamIncentivePct; Decimal)
        {
            Caption = 'Team Incentive %';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.TestField(Seniority, Seniority::Manager);
            end;
        }
    }

    procedure CalculateSalary(AtDate: Date) Salary: Record MonthlySalary
    var
        Calculate: Codeunit SalaryCalculate;
    begin
        exit(Calculate.CalculateSalary(Rec, AtDate))
    end;
}
