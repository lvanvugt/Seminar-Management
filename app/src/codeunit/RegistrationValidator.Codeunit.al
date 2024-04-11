codeunit 123456709 RegistrationHeaderValidator implements IRegistrationHeaderValidator
{
    procedure CheckMandatoryHeaderFields(IRegistrationHeader_ASD: interface IRegistrationHeader_ASD)
    begin
        if IRegistrationHeader_ASD.GetStatus() <> "Seminar Document Status ASD"::Closed then
            Error('Status must be equal to ''Closed''');
        if IRegistrationHeader_ASD.GetPostingDate() = 0D then
            Error('Posting Date cannot be zero or empty.');
        if IRegistrationHeader_ASD.GetDocumentDate() = 0D then
            Error('Document Date cannot be zero or empty.');
        if IRegistrationHeader_ASD.GetSeminarNo() = '' then
            Error('Seminar No. cannot be zero or empty.');
        if IRegistrationHeader_ASD.GetDuration() = 0 then
            Error('Duration cannot be zero or empty.');
        if IRegistrationHeader_ASD.GetInstructorResourceNo() = '' then
            Error('Instructor Resource No. cannot be zero or empty.');
        if IRegistrationHeader_ASD.GetRoomResourceNo() = '' then
            Error('Room Resource No. cannot be zero or empty.');
    end;
}