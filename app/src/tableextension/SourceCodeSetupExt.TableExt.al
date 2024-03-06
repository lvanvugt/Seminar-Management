tableextension 123456701 "Source Code Setup Ext ASD" extends "Source Code Setup" //242
{
    fields
    {
        field(123456700; "Seminar ASD"; Code[10])
        {
            Caption = 'Seminar';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
}