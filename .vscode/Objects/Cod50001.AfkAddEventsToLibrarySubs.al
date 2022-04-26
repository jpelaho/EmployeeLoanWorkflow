codeunit 50001 AfkAddEventsToLibrarySubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AfkOnAddWorkflowEventsToLibrary()
    var
        RegisterEmployeeLoanW: codeunit AfkRegisterWorkflowEvents;
    begin
        RegisterEmployeeLoanW.RegisterAddWorkflowEventsToLibrary();
    end;
}