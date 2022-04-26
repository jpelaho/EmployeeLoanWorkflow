codeunit 50009 AfkSetStatusToPendingApprSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure RunSetStatusToPendingApprSubs(RecRef: RecordRef; VAR Variant: Variant; VAR IsHandled: Boolean)
    var
        EmpLoanWorkflowMgt: codeunit AfkEmpLoanWorkflowMgt;
    begin
        EmpLoanWorkflowMgt.SetStatusToPendingApproval(RecRef,Variant,IsHandled);
    end;
}