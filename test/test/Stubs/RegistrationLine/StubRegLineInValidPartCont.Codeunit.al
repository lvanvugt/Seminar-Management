codeunit 123456741 StubRegLineInValidPartCont implements IRegistrationLine_ASD
{
    procedure GetBillToCustomerNo(): Code[20]
    begin
        exit('TEST');
    end;

    procedure GetParticipantContactNo(): Code[20]
    begin
        exit('');
    end;
}