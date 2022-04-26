codeunit 50005 AfkEmpLoanWorkflowMgt
{

    [IntegrationEvent(false, false)]
    procedure OnSendEmployeeLoanForApproval_AFK(EmployeeLoan: Record "AfkEmployeeLoan")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelEmployeeLoanApprovalRequest_AFK(EmployeeLoan: Record "AfkEmployeeLoan")
    begin
    end;

    procedure OpenApprovalsEmplLoan(EmpLoan: Record AfkEmployeeLoan)
    begin
        ApprovMgt.RunWorkflowEntriesPage(
              EmpLoan.RecordId(), DATABASE::AfkEmployeeLoan, Enum::"Approval Document Type"::" ", EmpLoan."No.");
    end;

    procedure SetStatusToPendingApproval(RecRef: RecordRef; Variant: Variant; var IsHandled: Boolean)
    var
        EmployeeLoan: Record "AfkEmployeeLoan";
    begin
        case RecRef.Number of
            DATABASE::"AfkEmployeeLoan":
                begin
                    RecRef.SETTABLE(EmployeeLoan);
                    EmployeeLoan.VALIDATE(Status, EmployeeLoan.Status::"Pending Approval");
                    EmployeeLoan.MODIFY(TRUE);
                    Variant := EmployeeLoan;
                    IsHandled := true;
                end;
        end;
    end;

    procedure ReleaseEmployeeLoanDoc(RecRef: RecordRef; VAR Handled: Boolean)
    var
        EmployeeLoan: Record "AfkEmployeeLoan";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"AfkEmployeeLoan":
                begin
                    RecRef.SETTABLE(EmployeeLoan);
                    EmployeeLoan.PerformManualRelease();
                    Handled := true;
                end;
        end;
    end;
    procedure ShowEmployeeLoanApprovalStatus_AFK(EmployeeLoan: Record "AfkEmployeeLoan")
    begin
        EmployeeLoan.FIND;

        CASE EmployeeLoan.Status OF
            EmployeeLoan.Status::Released:
                MESSAGE(DocStatusChangedMsg, LoanTypeDocumentText_AFK, EmployeeLoan."No.", EmployeeLoan.Status);
            EmployeeLoan.Status::"Pending Approval":
                IF ApprovMgt.HasOpenOrPendingApprovalEntries(EmployeeLoan.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
        END;
    end;

    local procedure CalcEmployeeLoanAmount_AFK(EmployeeLoan: Record "AfkEmployeeLoan"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    begin
        ApprovalAmount := EmployeeLoan."Loan Amount";
        ApprovalAmountLCY := EmployeeLoan."Loan Amount (LCY)";
    end;

    procedure PopulateApprovalEntryArgument(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; VAR ApprovalEntryArgument: Record "Approval Entry")
    var
        EmployeeLoan: Record "AfkEmployeeLoan";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"AfkEmployeeLoan":
                begin
                    RecRef.SETTABLE(EmployeeLoan);
                    CalcEmployeeLoanAmount_AFK(EmployeeLoan, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document No." := EmployeeLoan."No.";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := EmployeeLoan."Currency Code";
                end;
        end;
    end;


    procedure IsSufficientApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsSufficient: Boolean)
    begin
        CASE ApprovalEntryArgument."Table ID" OF
            DATABASE::"AfkEmployeeLoan":
                IsSufficient := IsSufficientEmployeeLoanApprover_AFK(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;

    local procedure IsSufficientEmployeeLoanApprover_AFK(UserSetup: Record "User Setup"; ApprovalAmountLCY: Decimal): Boolean
    begin
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(true);

        IF UserSetup."Unlimited Loan Approval" OR
            ((ApprovalAmountLCY <= UserSetup."Loan Amount Approval Limit") AND (UserSetup."Loan Amount Approval Limit" <> 0))
        THEN
            exit(true);


        exit(false);
    end;

    procedure IsEmployeeLoanApprovalsWorkflowEnabled_AFK(var EmployeeLoan: Record "AfkEmployeeLoan"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(EmployeeLoan, WorkflowEventHandling.RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK));
    end;

    procedure IsEmployeeLoanPendingApproval_AFK(var EmployeeLoan: Record "AfkEmployeeLoan"): Boolean
    begin
        IF EmployeeLoan.Status <> EmployeeLoan.Status::Open THEN
            EXIT(FALSE);

        EXIT(IsEmployeeLoanApprovalsWorkflowEnabled_AFK(EmployeeLoan));
    end;

    procedure CheckEmployeeLoanApprovalPossible_AFK(var EmployeeLoan: Record "AfkEmployeeLoan"): Boolean
    begin
        IF NOT IsEmployeeLoanApprovalsWorkflowEnabled_AFK(EmployeeLoan) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure ShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean)
    var
        EmployeeLoan: Record "AfkEmployeeLoan";
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"AfkEmployeeLoan":
                begin
                    RecRef.SETTABLE(EmployeeLoan);
                    ShowEmployeeLoanApprovalStatus_AFK(EmployeeLoan);
                    IsHandle := true;
                end;
        end;
    end;







    var
        ApprovMgt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit AfkRegisterWorkflowEvents;
        WorkflowManagement: Codeunit "Workflow Management";
        LoanTypeDocumentText_AFK: Label 'Employee loan';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';

}