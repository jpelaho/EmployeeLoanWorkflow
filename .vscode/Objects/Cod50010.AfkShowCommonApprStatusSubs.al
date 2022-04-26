codeunit 50010 AfkShowCommonApprStatusSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowCommonApprovalStatus', '', false, false)]
    local procedure RunAfkShowCommonApprStatusSubs(var RecRef: RecordRef; var IsHandle: Boolean)
    var
        EmpLoanWorkflowMgt: codeunit AfkEmpLoanWorkflowMgt;
    begin
        EmpLoanWorkflowMgt.ShowCommonApprovalStatus(RecRef, IsHandle);
    end;
}