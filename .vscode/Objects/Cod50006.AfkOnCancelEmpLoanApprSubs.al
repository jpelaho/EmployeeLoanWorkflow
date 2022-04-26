codeunit 50006 AfkOnCancelEmpLoanApprSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AfkEmpLoanWorkflowMgt", 'OnCancelEmployeeLoanApprovalRequest_AFK', '', false, false)]
    local procedure RunWorkflowOnCanceEmployeeLoanApprovalRequest_AFK(EmployeeLoan: Record "AfkEmployeeLoan")
    var
        RegisterEmployeeLoanW: codeunit AfkRegisterWorkflowEvents;
    begin
        RegisterEmployeeLoanW.RegisterOnCanceEmployeeLoanApprovalRequest_AFK(EmployeeLoan);
    end;
}