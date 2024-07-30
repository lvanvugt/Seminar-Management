#if solid
codeunit 123456712 RegistrationLineValidator implements IRegistrationLineValidator
{
    procedure VerifyRegLineForPosting(IRegistrationLine_ASD: interface IRegistrationLine_ASD)
    begin
        if IRegistrationLine_ASD.GetBillToCustomerNo() = '' then
            Error('Bill-to Customer No. must have a value.');
        if IRegistrationLine_ASD.GetParticipantContactNo() = '' then
            Error('Participant Contact No. must have a value.');
    end;
}
#endif