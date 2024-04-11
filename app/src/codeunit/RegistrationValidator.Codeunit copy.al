codeunit 123456712 RegistrationLineValidator implements IRegistrationLineValidator
{
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