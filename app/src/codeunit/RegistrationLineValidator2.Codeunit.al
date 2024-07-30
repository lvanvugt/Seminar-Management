#if solidComponent
codeunit 123456712 RegistrationLineValidator implements IRegistrationLineValidator
{
    procedure VerifyRegLineForPosting(var SeminarRegistrationLine: Record "Seminar Registration Line ASD")
    begin
        SeminarRegistrationLine.TestField("Bill-to Customer No.");
        SeminarRegistrationLine.TestField("Participant Contact No.");
    end;
}
#endif