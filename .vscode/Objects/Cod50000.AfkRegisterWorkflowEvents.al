codeunit 50000 AfkRegisterWorkflowEvents
{
    trigger OnRun()
    begin

    end;

    procedure RegisterAddWorkflowEventsToLibrary()

    begin
        WEventHandling.AddEventToLibrary(RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK, DATABASE::"AfkEmployeeLoan",
            EmployeeLoanSendForApprovalEventDescTxt_AFK, 0, FALSE);
        WEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseEmployeeLoanCode_AFK, DATABASE::"AfkEmployeeLoan",
            EmployeeLoanReleasedEventDescTxt_AFK, 0, FALSE);
        WEventHandling.AddEventToLibrary(RunWorkflowOnCancelEmployeeLoanApprovalRequestCode_AFK, DATABASE::"AfkEmployeeLoan",
            EmployeeLoanApprReqCancelledEventDescTxt_AFK, 0, FALSE);
    end;

    procedure RegisterAddWorkflowEventPredecessorsToLibrary(var EventFunctionName: code[128])

    begin
        case EventFunctionName of
            RunWorkflowOnCancelEmployeeLoanApprovalRequestCode_AFK:
                WEventHandling.AddEventPredecessor(RunWorkflowOnCancelEmployeeLoanApprovalRequestCode_AFK, RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK);
            WEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WEventHandling.AddEventPredecessor(WEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK);
            WEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WEventHandling.AddEventPredecessor(WEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK);
            WEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                WEventHandling.AddEventPredecessor(WEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK);
        end;
    end;

    procedure RegisterOnCanceEmployeeLoanApprovalRequest_AFK(var EmployeeLoan: Record "AfkEmployeeLoan")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelEmployeeLoanApprovalRequestCode_AFK, EmployeeLoan);
    end;

    procedure RegisterOnSendEmployeeLoanForApproval_AFK(var EmployeeLoan: Record "AfkEmployeeLoan")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK, EmployeeLoan);
    end;

    procedure RunWorkflowOnSendEmployeeLoanForApprovalCode_AFK(): Text[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendEmployeeLoanForApproval'));
    end;

    local procedure RunWorkflowOnAfterReleaseEmployeeLoanCode_AFK(): Text[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseEmployeeLoan'));
    end;

    local procedure RunWorkflowOnCancelEmployeeLoanApprovalRequestCode_AFK(): Text[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelEmployeeLoanApprovalRequest'));
    end;

    var
        WEventHandling: Codeunit "Workflow Event Handling";
        EmployeeLoanSendForApprovalEventDescTxt_AFK: Label 'Approval of a loan document is requested.';
        EmployeeLoanReleasedEventDescTxt_AFK: Label 'A loan document is released.';
        EmployeeLoanApprReqCancelledEventDescTxt_AFK: Label 'An approval request for a loan document is canceled.';
        WorkflowManagement: Codeunit "Workflow Management";
}