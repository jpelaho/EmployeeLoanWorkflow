codeunit 50008 AfkIsSufficientApproverSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterIsSufficientApprover', '', false, false)]
    local procedure RunAfkIsSufficientApproverSubs(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; VAR IsSufficient: Boolean)
    var
        EmpLoanWorkflowMgt: codeunit AfkEmpLoanWorkflowMgt;
    begin
        EmpLoanWorkflowMgt.IsSufficientApprover(UserSetup, ApprovalEntryArgument, IsSufficient);
    end;
}