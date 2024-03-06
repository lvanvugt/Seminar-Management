codeunit 123456734 "Seminar Reg.-Show Ledger ASD"
{
    TableNo = "Seminar Register ASD";

    trigger OnRun()
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        Page.Run(Page::"Seminar Ledger Entries ASD", SeminarLedgerEntry);
    end;
}