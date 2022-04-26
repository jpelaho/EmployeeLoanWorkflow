pageextension 50000 AfkApprovalUserSetup extends "Approval User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Loan Amount Approval Limit"; Rec."Loan Amount Approval Limit")
            {
                ApplicationArea = Suite;
            }
            field("Unlimited Loan Approval"; Rec."Unlimited Loan Approval")
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