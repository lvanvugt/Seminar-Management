codeunit 123456790 "CreateSeminarsDDTASD"
{
    trigger OnRun();
    var
        UtilsSeminarDDT: Codeunit UtilsSeminarDDTASD;
    begin
        CreateSeminarNoSeries(UtilsSeminarDDT.GetSeminarNoSeriesCode(), UtilsSeminarDDT.GetSeminarNoSeriesName());
        CreateSeminarNoSeries(UtilsSeminarDDT.GetSeminarRegNoSeriesCode(), UtilsSeminarDDT.GetSeminarRegNoSeriesName());
        CreateSeminarNoSeries(UtilsSeminarDDT.GetPstdSeminarRegNoSeriesCode(), UtilsSeminarDDT.GetPstdSeminarRegNoSeriesName());

        CreateSeminarSetup();

        CreateSeminar('DEV1', 'D365 BC AL Introduction', 4, 6, 15, 1375, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
        CreateSeminar('DEV2', 'D365 BC AL Solution Development', 3, 4, 12, 1250, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
        CreateSeminar('INT', 'D365 BC Introduction', 1, 4, 10, 395, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
        CreateSeminar('FIN', 'D365 BC Finance', 2, 3, 10, 770, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
        CreateSeminar('MAN1', 'D365 BC Manufacturing 1', 2, 3, 10, 775, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
        CreateSeminar('MAN2', 'D365 BC Manufacturing 2', 2, 3, 10, 775, UtilsSeminarDDT.GetGenProdPostingGroup(), UtilsSeminarDDT.GetVATProdPostingGroup());
    end;

    local procedure CreateSeminarNoSeries(NewCode: Code[10]; NewDescription: Text[100]);
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.Get(NewCode) then begin
            NoSeries.Init();
            NoSeries.Code := NewCode;
            NoSeries.Description := NewDescription;
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := NoSeries.Code;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := CopyStr(StrSubstNo('%1%2', NewCode, 1), 1, MaxStrLen(NoSeriesLine."Starting No."));
            NoSeriesLine.Insert();
        end;
    end;

    local procedure CreateSeminarSetup();
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        if not SeminarSetup.Get() then
            SeminarSetup.InsertRecord();
        SeminarSetup.Init();
        SeminarSetup.Validate("Seminar Nos.", 'SEM');
        SeminarSetup.Validate("Seminar Registration Nos.", 'SEMREG');
        SeminarSetup.Validate("Posted Seminar Reg. Nos.", 'PSEMREG');
        SeminarSetup.Modify();
    end;

    local procedure CreateSeminar(NewNo: Code[20]; NewName: Text[100]; NewDuration: Decimal; NewMinParticipants: Integer; NewMaxParticipants: Integer; NewPrice: Decimal; NewGenProdPostingGroup: Code[20]; NewVATProdPostingGroup: Code[20]);
    var
        Seminar: Record "Seminar ASD";
        i: Integer;
        N: Integer;
    begin
        if not Seminar.Get(NewNo) then begin
            Seminar.Init();
            Seminar.Validate("No.", NewNo);
            Seminar.Validate(Name, NewName);
            Seminar."Duration" := NewDuration;
            Seminar."Minimum Participants" := NewMinParticipants;
            Seminar."Maximum Participants" := NewMaxParticipants;
            Seminar.Price := NewPrice;
            Seminar.Validate("Gen. Prod. Posting Group", NewGenProdPostingGroup);
            Seminar.Validate("VAT Prod. Posting Group", NewVATProdPostingGroup);
            Seminar.Insert();

            N := Random(5);
            for i := 1 to N do
                CreateSeminarComment(Seminar."No.", "Comment Line Table Name"::Seminar);
        end;
    end;

    procedure CreateSeminarComment(NewSeminarNo: Code[20]; NewTableName: Enum "Comment Line Table Name");
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", NewTableName);
        CommentLine.SetRange("No.", NewSeminarNo);

        if not CommentLine.FindLast() then
            CommentLine."Table Name" := NewTableName;

        CommentLine.Init();
        CommentLine."No." := NewSeminarNo;
        CommentLine."Line No." := CommentLine."Line No." + 10000;
        CommentLine."Date" := WorkDate();
        CommentLine.Comment := CopyStr(StrSubstNo('%1 %2 - %3', 'Comment', CommentLine."Line No.", CurrentDateTime()), 1, MaxStrLen(CommentLine.Comment));
        CommentLine.Insert();
    end;
}