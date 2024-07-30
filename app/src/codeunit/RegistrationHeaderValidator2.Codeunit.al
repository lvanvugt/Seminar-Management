#if solidComponent
codeunit 123456709 RegistrationHeaderValidator implements IRegistrationHeaderValidator
{

    procedure CheckMandatoryHeaderFields(var SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    begin
        SeminarRegistrationHeader2.TestField(Status, SeminarRegistrationHeader2.Status::Closed);
        SeminarRegistrationHeader2.TestField("Posting Date");
        SeminarRegistrationHeader2.TestField("Document Date");
        SeminarRegistrationHeader2.TestField("Seminar No.");
        SeminarRegistrationHeader2.TestField(Duration);
        SeminarRegistrationHeader2.TestField("Instructor Resource No.");
        SeminarRegistrationHeader2.TestField("Room Resource No.");
    end;
}
#endif