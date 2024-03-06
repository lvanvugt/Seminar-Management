pageextension 123456701 "Resource List Ext ASD" extends "Resource List" //77
{
    // ASD9.01 - 2020-09-24 D.E. Veloper - Chapter 9: Lab 1 - Column visibility

    layout
    {
        // ASD9.01<
        modify(Type)
        {
            Visible = ShowType;
        }
        // ASD9.01>

        addafter(Type)
        {
            field("Internal/External ASD"; Rec."Internal/External ASD")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies whether the resource is used internal or external.';
            }

            field("Maximum Participants ASD"; Rec."Maximum Participants ASD")
            {
                // ASD9.01<
                Visible = ShowMaxParticipants;
                // ASD9.01>
                ApplicationArea = Jobs;
                ToolTip = 'Specifies the maximum number of participants the room resource can store.';
            }
        }
    }

    // ASD9.01<
    var
        ShowType: Boolean;
        ShowMaxParticipants: Boolean;

    trigger OnOpenPage();
    begin
        Rec.FilterGroup(3);
        ShowType := Rec.GetFilter(Type) = '';
        ShowMaxParticipants := Rec.GetFilter(Type) = Format(Rec.Type::Room);
        Rec.FilterGroup(0);
    end;
    // ASD9.01>
}