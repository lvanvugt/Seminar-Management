pageextension 123456700 "Resource Card Ext ASD" extends "Resource Card" //76
{
    layout
    {
        addafter(Type)
        {
            field("Internal/External ASD"; Rec."Internal/External ASD")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies whether the resource is used internal or external.';
            }
        }

        addafter("Base Unit of Measure")
        {
            field("Quantity per Day ASD"; Rec."Quantity per Day ASD")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies the quantity per day.';
            }
        }

        addlast(Content)
        {
            group(RoomASD)
            {
                Caption = 'Room';

                field("Maximum Participants ASD"; Rec."Maximum Participants ASD")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the maximum number of participants the room resource can store.';
                }
            }
        }
    }
}