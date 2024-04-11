codeunit 123456725 StubRegHdrInValidSeminarNoASD implements IRegistrationHeader_ASD
{
    procedure GetStatus(): enum "Seminar Document Status ASD"
    begin
        Exit("Seminar Document Status ASD"::Closed);
    end;

    procedure GetPostingDate(): Date
    begin
        exit(Today());
    end;

    procedure GetDocumentDate(): Date
    begin
        exit(Today());
    end;

    procedure GetSeminarNo(): Code[20]
    begin
        exit('');
    end;

    procedure GetDuration(): Integer
    begin
        exit(10);
    end;

    procedure GetInstructorResourceNo(): Code[20]
    begin
        exit('TEST');
    end;

    procedure GetRoomResourceNo(): Code[20]
    begin
        exit('TEST');
    end;
}