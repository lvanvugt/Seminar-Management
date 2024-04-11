codeunit 123456708 RegistrationLineASD implements IRegistrationLine_ASD
{
    var
        _billToCustomerNo: Code[20];
        _participantContactNo: Code[20];

    procedure GetBillToCustomerNo(): Code[20]
    begin
        exit(_billToCustomerNo);
    end;

    procedure GetParticipantContactNo(): Code[20]
    begin
        exit(_participantContactNo);
    end;

    procedure PopulateFromSeminarRegistrationLine(SeminarRegistrationLineASD: Record "Seminar Registration Line ASD")
    begin
        _billToCustomerNo := SeminarRegistrationLineASD."Bill-to Customer No.";
        _participantContactNo := SeminarRegistrationLineASD."Participant Contact No.";
    end;
}