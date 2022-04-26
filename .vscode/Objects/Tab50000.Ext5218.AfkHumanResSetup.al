tableextension 50000 AfkHumanResSetup extends "Human Resources Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Employee Loan Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Loan Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Emp. Loan Duration Max"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Emp. Loan Duration Max';
        }
    }
    
}