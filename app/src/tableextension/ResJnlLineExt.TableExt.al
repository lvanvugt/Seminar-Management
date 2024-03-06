tableextension 123456702 "Res. Jnl. Line Ext ASD" extends "Res. Journal Line" //207
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