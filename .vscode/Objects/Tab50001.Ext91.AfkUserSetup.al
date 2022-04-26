tableextension 50001 AfkUserSetupExt extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Loan Amount Approval Limit"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Loan Amount Approval Limit';
        }
        field(50001; "Unlimited Loan Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unlimited Loan Approval';
        }
    }

}