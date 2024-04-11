codeunit 123456740 StubRegLineInValidBillToCust implements IRegistrationLine_ASD
{
    procedure GetBillToCustomerNo(): Code[20]
    begin
        exit('');
    end;

    procedure GetParticipantContactNo(): Code[20]
    begin
        exit('TEST');
    end;
}