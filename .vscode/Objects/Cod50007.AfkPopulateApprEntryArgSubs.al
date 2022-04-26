codeunit 50007 AfkPopulateApprEntryArgSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure RunWorkflowOnOnPopulateApprovalEntryArgument(VAR RecRef: RecordRef; VAR ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        EmpLoanWorkflowMgt: codeunit AfkEmpLoanWorkflowMgt;
    begin
        EmpLoanWorkflowMgt.PopulateApprovalEntryArgument(RecRef ,WorkflowStepInstance, ApprovalEntryArgument);
    end;
}