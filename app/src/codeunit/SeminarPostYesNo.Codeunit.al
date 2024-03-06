codeunit 123456721 "Seminar-Post (Yes/No) ASD"
{
    TableNo = "Sem. Registration Header ASD";

    var
        SeminarRegHeader: Record "Sem. Registration Header ASD";
        SeminarPost: Codeunit "Seminar-Post ASD";
        DoYouWantToPostQst: Label 'Do you want to post the %1?';

    trigger OnRun();
    begin
        SeminarRegHeader.Copy(Rec);
        Code();
        Rec := SeminarRegHeader;
    end;

    local procedure "Code"();
    begin
        if not Confirm(DoYouWantToPostQst, false, SeminarRegHeader.TableCaption) then
            exit;
        SeminarPost.Run(SeminarRegHeader);
    end;
}