interface "IRegistrationHeader_ASD"
{
    procedure GetStatus(): Enum "Seminar Document Status ASD";
    procedure GetPostingDate(): Date;
    procedure GetDocumentDate(): Date;
    procedure GetSeminarNo(): Code[20];
    procedure GetDuration(): Integer;
    procedure GetInstructorResourceNo(): Code[20];
    procedure GetRoomResourceNo(): Code[20];
}