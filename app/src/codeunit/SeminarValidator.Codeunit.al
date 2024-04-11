Codeunit 123456707 SeminarValidator
{
    procedure CheckMandatoryHeaderFields(SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    begin
        SeminarRegistrationHeader2.TestField(Status, SeminarRegistrationHeader2.Status::Closed);
        SeminarRegistrationHeader2.TestField("Posting Date");
        SeminarRegistrationHeader2.TestField("Document Date");
        SeminarRegistrationHeader2.TestField("Seminar No.");
        SeminarRegistrationHeader2.TestField(Duration);
        SeminarRegistrationHeader2.TestField("Instructor Resource No.");
        SeminarRegistrationHeader2.TestField("Room Resource No.");
    end;

    procedure CheckSeminarLinesExist(SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    var
        SeminarRegistrationLine2: Record "Seminar Registration Line ASD";
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        SeminarRegistrationLine2.SetRange("Document No.", SeminarRegistrationHeader2."No.");
        if SeminarRegistrationLine2.IsEmpty() then
            Error(NothingToPostErr);
    end;

    procedure CheckMandatoryLineFields(SeminarRegistrationLine2: Record "Seminar Registration Line ASD")
    begin
        SeminarRegistrationLine2.TestField("Bill-to Customer No.");
        SeminarRegistrationLine2.TestField("Participant Contact No.");
    end;
}