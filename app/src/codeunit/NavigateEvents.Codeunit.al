codeunit 123456702 "Navigate - Events ASD"
{
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text);
    var
        PstdSeminarRegHeader: Record "Posted Sem. Reg. Header ASD";
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
        Navigate: Page Navigate;
    begin
        if PstdSeminarRegHeader.ReadPermission() then begin
            PstdSeminarRegHeader.Reset();
            PstdSeminarRegHeader.SetFilter("No.", DocNoFilter);
            PstdSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(
                DocumentEntry, Database::"Posted Sem. Reg. Header ASD", "Document Entry Document Type"::" ", PstdSeminarRegHeader.TableCaption(), PstdSeminarRegHeader.Count());
        end;
        if SeminarLedgerEntry.ReadPermission() then begin
            SeminarLedgerEntry.Reset();
            SeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
            SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
            SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(
                DocumentEntry, Database::"Seminar Ledger Entry ASD", "Document Entry Document Type"::" ", SeminarLedgerEntry.TableCaption(), SeminarLedgerEntry.Count());
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean);
    var
        PstdSeminarRegHeader: Record "Posted Sem. Reg. Header ASD";
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        if ItemTrackingSearch then
            exit;

        case TableID of
            Database::"Posted Sem. Reg. Header ASD":
                begin
                    PstdSeminarRegHeader.SetFilter("No.", DocNoFilter);
                    PstdSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
                    Page.Run(0, PstdSeminarRegHeader);
                end;
            Database::"Seminar Ledger Entry ASD":
                begin
                    SeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
                    SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
                    SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
                    Page.Run(0, SeminarLedgerEntry)
                end;
        end
    end;
}