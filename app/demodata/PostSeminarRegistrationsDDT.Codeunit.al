codeunit 123456792 "PostSeminarRegistrationsDDTASD"
{
    trigger OnRun();
    var
        SeminarRegHeader: Record "Sem. Registration Header ASD";
        CreateSeminarRegistrations: Codeunit CreateSemRegistrationsDDTASD;
        UtilsSeminarDDT: Codeunit UtilsSeminarDDTASD;
    begin
        if SeminarRegHeader.IsEmpty() then
            CreateSeminarRegistrations.Run();

        SetSourceCodeSetup(UtilsSeminarDDT.GetSeminarSourceCode());

        if SeminarRegHeader.FindSet() then
            repeat
                PostSeminarRegistration(SeminarRegHeader);
            until SeminarRegHeader.Next() = 0
    end;

    procedure PostSeminarRegistration(SeminarRegHeader: Record "Sem. Registration Header ASD");
    var
        SeminarPost: Codeunit "Seminar-Post ASD";
    begin
        if SeminarRegHeader.Status <> SeminarRegHeader.Status::Closed then begin
            SeminarRegHeader.Status := SeminarRegHeader.Status::Closed;
            SeminarRegHeader.Modify(true);
        end;
        SeminarPost.Run(SeminarRegHeader);
    end;

    local procedure SetSourceCodeSetup(NewSourceCode: Code[10]);
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        CreateSourceCode(NewSourceCode);

        if not SourceCodeSetup.Get() then
            SourceCodeSetup.Insert();

        SourceCodeSetup."Seminar ASD" := NewSourceCode;
        SourceCodeSetup.Modify();
    end;

    local procedure CreateSourceCode(NewSourceCode: Code[10]);
    var
        SourceCode: Record "Source Code";
    begin
        if not SourceCode.Get(NewSourceCode) then begin
            SourceCode.Code := NewSourceCode;
            SourceCode.Description := NewSourceCode;
            SourceCode.Insert();
        end
    end;
}