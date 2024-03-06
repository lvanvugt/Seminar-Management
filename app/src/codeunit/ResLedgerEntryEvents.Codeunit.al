codeunit 123456701 "Res. Ledger Entry - Events ASD"
{
    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterCopyFromResJnlLine', '', false, false)]
    local procedure OnAfterCopyFromResJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line");
    begin
        ResLedgerEntry."Seminar No. ASD" := ResJournalLine."Seminar No. ASD";
        ResLedgerEntry."Seminar Registration No. ASD" := ResJournalLine."Seminar Registration No. ASD";
    end;
}