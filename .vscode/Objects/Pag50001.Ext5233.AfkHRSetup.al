pageextension 50001 AfkHRSetup extends "Human Resources Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Employee Loan Nos."; Rec."Employee Loan Nos.")
            {
                ApplicationArea = Suite;
            }
            field("Emp. Loan Duration Max"; Rec."Emp. Loan Duration Max")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}