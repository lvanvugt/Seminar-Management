codeunit 123456700 "Company-Initialize - Evts ASD"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure OnCompanyInitialize()
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        SeminarSetup.InsertRecord();
    end;
}