table 50000 "AfkEmployeeLoan"
{
    Caption = 'Employee Loan';
    DataCaptionFields = "No.";
    DataClassification = ToBeClassified;
    LookupPageId = AfkEmployeeLoanList;
    DrillDownPageId = AfkEmployeeLoanList;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Employee Loan Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            Caption = 'Employee No.';
            TableRelation = "Employee";

            trigger OnValidate()
            begin
                Employee.GET("Employee No.");
                Rec."Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";
                TestStatusOpen();
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Employee Name';
        }
        field(4; "Loan Type"; Enum "AfkEmployeeLoanType")
        {
            Caption = 'Type';
        }
        field(5; "Loan Reason"; Text[100])
        {
            Caption = 'Reason';
            DataClassification = ToBeClassified;
        }
        field(6; "Duration"; Integer)
        {
            Caption = 'Duration (Months)';
            DataClassification = ToBeClassified;

            trigger OnValidate()

            begin
                Rec.TESTFIELD(Duration);
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Emp. Loan Duration Max");
                IF (Rec.Duration > HumanResSetup."Emp. Loan Duration Max") THEN
                    ERROR(Text001);
            end;
        }
        field(7; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec.TESTFIELD("Document Date");

                IF "Currency Code" = '' THEN
                    "Loan Amount (LCY)" := "Loan Amount"
                ELSE
                    "Loan Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Document Date", "Currency Code",
                          "Loan Amount", "Currency Factor"));
            end;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = "Currency";

            trigger OnValidate()
            begin
                TestStatusOpen();

                "Currency Factor" := CurrExchRate.ExchangeRate("Document Date", "Currency Code");
                VALIDATE("Loan Amount");
            end;
        }
        field(9; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(10; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Status"; Enum "AfkEmployeeLoanStatus")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(12; "Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = ToBeClassified;
            TableRelation = "User";
            Editable = false;
            //TestTableRelation = false;
        }
        field(13; "Modified By"; Code[50])
        {
            Caption = 'Modified By';
            DataClassification = ToBeClassified;
            TableRelation = "User";
            Editable = false;
            //TestTableRelation = false;
        }
        field(14; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            Editable = false;
            DecimalPlaces = 0 : 15;
        }
        field(18; "Loan Amount (LCY)"; Decimal)
        {
            Caption = 'Loan Amount (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        CurrExchRate: Record "Currency Exchange Rate";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

        Text001: Label 'Duration must not exceed %1 months';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';

    trigger OnInsert()
    var

    begin
        if "No." = '' then begin
            HumanResSetup.Get();
            HumanResSetup.TestField("Employee Loan Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Employee Loan Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            InitHeader();
        end;
    end;

    trigger OnModify()
    begin
        Rec."Last Modified Date" := Today;
        Rec."Modified By" := UserId;
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;

    trigger OnRename()
    begin

    end;

    local procedure InitHeader()
    begin
        Rec."Document Date" := WorkDate();
        Rec."Create By" := UserId;
        rec."Creation Date" := Today;
    end;

    local procedure TestStatusOpen()
    begin
        Rec.TestField(Status, Status::Open);
    end;

    procedure AssistEdit(OldEmpLoan: Record AfkEmployeeLoan): Boolean
    var
        EmpLoan: Record "AfkEmployeeLoan";
    begin

        EmpLoan := Rec;
        HumanResSetup.Get();
        HumanResSetup.TestField("Employee Loan Nos.");
        if NoSeriesMgt.SelectSeries(HumanResSetup."Employee Loan Nos.", OldEmpLoan."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := EmpLoan;
            exit(true);
        end;

    end;

    procedure PerformManualRelease()
    var
        ApprovalsMgmt: Codeunit AfkEmpLoanWorkflowMgt;
    begin

        IF ApprovalsMgmt.IsEmployeeLoanPendingApproval_AFK(Rec) THEN
            ERROR(Text002);

        IF Status = Status::Released THEN
            EXIT;

        Rec.TESTFIELD("Employee No.");
        Rec.TESTFIELD("Loan Amount");
        Rec.TESTFIELD(Rec.Duration);
        Rec.TESTFIELD("Document Date");
        Rec.Status := Rec.Status::Released;
        Rec.MODIFY();

    end;

    procedure PerformManualReOpen()
    var

    begin

        IF Rec.Status = Rec.Status::"Pending Approval" THEN
            ERROR(Text003);

        IF Rec.Status = Rec.Status::Open THEN
            EXIT;

        Rec.Status := Rec.Status::Open;
        Rec.MODIFY();

    end;

    procedure ReOpen()
    var

    begin

        IF Rec.Status = Rec.Status::Open THEN
            EXIT;

        Rec.Status := Rec.Status::Open;
        Rec.MODIFY();

    end;

}