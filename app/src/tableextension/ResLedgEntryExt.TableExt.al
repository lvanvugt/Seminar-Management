tableextension 123456703 "Res. Ledg. Entry Ext ASD" extends "Res. Ledger Entry" //203
{
    fields
    {
        field(123456700; "Seminar No. ASD"; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "Seminar ASD";
        }
        field(123456701; "Seminar Registration No. ASD"; Code[20])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "Posted Sem. Reg. Header ASD";
        }
    }
}