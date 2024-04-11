codeunit 123456730 StubRegLineValid implements IRegistrationLine_ASD
{
    procedure GetBillToCustomerNo(): Code[20]
    begin
        exit('TEST');
    end;

    procedure GetParticipantContactNo(): Code[20]
    begin
        exit('TEST');
    end;
}