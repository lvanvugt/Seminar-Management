pageextension 123456702 "Source Code Setup Ext ASD" extends "Source Code Setup" //279
{
    layout
    {
        addafter("Cost Accounting")
        {
            group(SeminarManagementASD)
            {
                Caption = 'Seminar Management';
                field("Seminar ASD"; Rec."Seminar ASD")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code assigned to entries that are posted from a seminar document.';
                }
            }
        }
    }

}