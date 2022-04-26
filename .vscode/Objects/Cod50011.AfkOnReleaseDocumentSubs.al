codeunit 50011 AfkOnReleaseDocumentSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnWorkflowReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        RegisterEmployeeLoanW: codeunit AfkEmpLoanWorkflowMgt;
    begin
        RegisterEmployeeLoanW.ReleaseEmployeeLoanDoc(RecRef,Handled);
    end;
}