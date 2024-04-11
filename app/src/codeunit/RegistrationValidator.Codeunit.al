codeunit 123456709 RegistrationValidatorASD implements IRegistrationValidatorASD
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

    procedure VerifyRegLineForPosting(IRegistrationLine_ASD: interface IRegistrationLine_ASD)
    begin
        if IRegistrationLine_ASD.GetBillToCustomerNo() = '' then
            Error('Bill-to Customer No. cannot be zero or empty.');
        if IRegistrationLine_ASD.GetParticipantContactNo() = '' then
            Error('Participant Contact No. cannot be zero or empty.');
    end;

    procedure HandleLinesExists(IsEmpty: Boolean)
    var
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        if IsEmpty then
            Error(NothingToPostErr);
    end;
}