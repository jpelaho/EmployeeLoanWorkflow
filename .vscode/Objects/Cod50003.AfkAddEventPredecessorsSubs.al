codeunit 50003 AfkAddEventPredecessorsSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnWorkflowPredecessorsToLibrary(EventFunctionName: code[128])
    var
        RegisterEmployeeLoanW: codeunit AfkRegisterWorkflowEvents;
    begin
        RegisterEmployeeLoanW.RegisterAddWorkflowEventPredecessorsToLibrary(EventFunctionName);
    end;
}