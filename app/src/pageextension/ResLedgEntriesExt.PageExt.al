pageextension 123456703 "Res. Ledg. Entries Ext ASD" extends "Resource Ledger Entries" //202
{
    layout
    {
        addbefore("Job No.")
        {
            field("Seminar No.ASD"; Rec."Seminar No. ASD")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies the seminar number that the entry is linked to.';
            }
            field("Seminar Registration No.ASD"; Rec."Seminar Registration No. ASD")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies the posted seminar registration that the entry is linked to.';
            }
        }
    }
}