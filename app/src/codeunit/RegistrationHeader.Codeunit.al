Codeunit 123456711 "RegistrationHeader_ASD" implements IRegistrationHeader_ASD
{
    var
        _status: enum "Seminar Document Status ASD";
        _postingDate: Date;
        _documentDate: Date;
        _seminarNo: Code[20];
        _duration: Decimal;
        _instructorResourceNo: Code[20];
        _roomResourceNo: Code[20];

    procedure GetStatus(): enum "Seminar Document Status ASD"
    begin
        exit(_status);
    end;

    procedure GetPostingDate(): Date
    begin
        exit(_postingDate);
    end;

    procedure GetDocumentDate(): Date
    begin
        exit(_documentDate);
    end;

    procedure GetSeminarNo(): Code[20]
    begin
        exit(_seminarNo);
    end;

    procedure GetDuration(): Integer
    begin
        exit(_duration);
    end;

    procedure GetInstructorResourceNo(): Code[20]
    begin
        exit(_instructorResourceNo);
    end;

    procedure GetRoomResourceNo(): Code[20]
    begin
        exit(_roomResourceNo);
    end;

    procedure PopulateFromSeminarRegistrationHeader(SemRegistrationHeaderASD: Record "Sem. Registration Header ASD")
    begin
        _status := SemRegistrationHeaderASD.Status;
        _postingDate := SemRegistrationHeaderASD."Posting Date";
        _documentDate := SemRegistrationHeaderASD."Document Date";
        _seminarNo := SemRegistrationHeaderASD."Seminar No.";
        _duration := SemRegistrationHeaderASD.Duration;
        _instructorResourceNo := SemRegistrationHeaderASD."Instructor Resource No.";
        _roomResourceNo := SemRegistrationHeaderASD."Room Resource No.";
    end;
}