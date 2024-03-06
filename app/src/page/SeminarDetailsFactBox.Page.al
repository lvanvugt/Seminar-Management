page 123456717 "Seminar Details FactBox ASD"
{
    Caption = 'Seminar Details';
    PageType = CardPart;
    SourceTable = "Seminar ASD";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Seminar No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the seminar.';

                trigger OnDrillDown();
                begin
                    ShowDetails();
                end;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the seminar''s name.';
            }
            field("Duration"; Rec.Duration)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the seminar''s duration in days.';
            }
            field("Minimum Participants"; Rec."Minimum Participants")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the minimum number of participants needed for to the seminar.';
            }
            field("Maximum Participants"; Rec."Maximum Participants")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the maximum number of participants needed for to the seminar.';
            }
            field(Price; Rec.Price)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the price of the seminar.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = "Action";
                action(Comments)
                {
                    Caption = 'Comments';
                    ToolTip = 'View or add comments for the record.';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                }
            }
        }
    }

    local procedure ShowDetails();
    begin
        Page.Run(Page::"Seminar Card ASD", Rec);
    end;
}