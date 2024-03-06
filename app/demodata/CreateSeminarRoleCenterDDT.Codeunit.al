codeunit 123456795 "CreateSeminarRoleCenterDDTASD"
{
    trigger OnRun();
    begin
        CreateCueSetups;
        CreateMySeminars();
    end;

    local procedure CreateCueSetups()
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
    begin
        RecRef.Open(Database::"Seminar Cue ASD");
        for i := 2 to RecRef.FieldCount() do begin
            FieldRef := RecRef.FieldIndex(i);
            CreateCueSetup(Database::"Seminar Cue ASD", FieldRef.Number());
        end;
    end;

    local procedure CreateCueSetup(TableID: Integer; FieldID: Integer);
    var
        CuesAndKPIs: Codeunit "Cues And KPIs";
        CuesAndKPIsStyle: Enum "Cues And KPIs Style";
    begin
        CuesAndKPIs.InsertData(TableID, FieldID, CuesAndKPIsStyle::Favorable, FieldID, CuesAndKPIsStyle::Ambiguous, FieldID * 2, CuesAndKPIsStyle::Unfavorable);
    end;

    local procedure CreateMySeminars()
    var
        Seminar: Record "Seminar ASD";
        SeminarNo: Code[20];
    begin
        if Seminar.FindFirst() then
            CreateMySeminar(Seminar."No.");
        SeminarNo := Seminar."No.";
        if Seminar.FindLast() and (SeminarNo <> Seminar."No.") then
            CreateMySeminar(Seminar."No.");
    end;

    local procedure CreateMySeminar(SeminarNo: Code[20])
    var
        MySeminar: Record "My Seminar ASD";
    begin
        if not MySeminar.Get(UserId(), SeminarNo) then begin
            MySeminar."User ID" := UserId();
            MySeminar."Seminar No." := SeminarNo;
            MySeminar.Insert();
        end;
    end;
}