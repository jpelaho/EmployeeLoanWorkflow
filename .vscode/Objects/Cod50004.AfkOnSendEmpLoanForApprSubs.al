codeunit 50004 AfkOnSendEmpLoanForApprSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AfkEmpLoanWorkflowMgt", 'OnSendEmployeeLoanForApproval_AFK', '', false, false)]
    local procedure RunWorkflowOnSendEmployeeLoanForApproval_AFK(EmployeeLoan: Record "AfkEmployeeLoan")
    var
        RegisterEmployeeLoanW: codeunit AfkRegisterWorkflowEvents;
    begin
        RegisterEmployeeLoanW.RegisterOnSendEmployeeLoanForApproval_AFK(EmployeeLoan);
    end;
}