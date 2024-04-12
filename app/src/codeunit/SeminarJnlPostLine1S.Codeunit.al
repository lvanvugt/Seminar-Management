#if unstructured_spaghetti or structured_spaghetti
codeunit 123456732 "Seminar Jnl.-Post Line ASD"
{
    Permissions = tabledata "Seminar Ledger Entry ASD" = imd,
                    tabledata "Seminar Register ASD" = imd;
    TableNo = "Seminar Journal Line ASD";

    var
        SeminarJnlLine: Record "Seminar Journal Line ASD";
        SeminarRegister: Record "Seminar Register ASD";
        SeminarJnlCheckLine: Codeunit "Seminar Jnl.-Check Line ASD";
        NextEntryNo: Integer;

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    procedure RunWithCheck(var SeminarJnlLine2: Record "Seminar Journal Line ASD")
    begin
        SeminarJnlLine.Copy(SeminarJnlLine2);
        Code();
        SeminarJnlLine2 := SeminarJnlLine;
    end;

    local procedure Code()
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
        Seminar: Record "Seminar ASD";
    begin
        if SeminarJnlLine.EmptyLine() then
            exit;

        SeminarJnlCheckLine.RunCheck(SeminarJnlLine);

        if NextEntryNo = 0 then begin
            SeminarLedgerEntry.LockTable();
            NextEntryNo := SeminarLedgerEntry.GetLastEntryNo() + 1;
        end;

        if SeminarJnlLine."Document Date" = 0D then
            SeminarJnlLine."Document Date" := SeminarJnlLine."Posting Date";

        if SeminarRegister."No." = 0 then begin
            SeminarRegister.LockTable();
            if (not SeminarRegister.FindLast()) or (SeminarRegister."To Entry No." <> 0) then begin
                SeminarRegister.Init();
                SeminarRegister."No." := SeminarRegister."No." + 1;
                SeminarRegister."From Entry No." := NextEntryNo;
                SeminarRegister."To Entry No." := NextEntryNo;
                SeminarRegister."Creation Date" := Today();
                SeminarRegister."Creation Time" := Time();
                SeminarRegister."Source Code" := SeminarJnlLine."Source Code";
                SeminarRegister."Journal Batch Name" := SeminarJnlLine."Journal Batch Name";
                SeminarRegister."User ID" := UserId();
                SeminarRegister.Insert();
            end;
        end;
        SeminarRegister."To Entry No." := NextEntryNo;
        SeminarRegister.Modify();

        Seminar.Get(SeminarJnlLine."Seminar No.");
        Seminar.TestField(Blocked, false);

        SeminarLedgerEntry.Init();
        SeminarLedgerEntry.CopyFromSeminarJnlLine(SeminarJnlLine);

        SeminarLedgerEntry."Total Price" := Round(SeminarLedgerEntry."Total Price");
        if SeminarLedgerEntry.Description = Seminar.Name then
            SeminarLedgerEntry.Description := '';
        SeminarLedgerEntry."User ID" := UserId();
        SeminarLedgerEntry."Entry No." := NextEntryNo;
        SeminarLedgerEntry.Insert();

        NextEntryNo := NextEntryNo + 1;
    end;
}
#endif