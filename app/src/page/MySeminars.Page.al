page 123456742 "My Seminars ASD"
{
    Caption = 'My Seminars';
    PageType = ListPart;
    SourceTable = "My Seminar ASD";

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(SeminarNo; Rec."Seminar No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the seminar number that are displayed in the My Seminars Cue on the Role Center.';

                    trigger OnValidate()
                    begin
                        GetSeminar();
                    end;
                }
                field(SeminarName; Seminar.Name)
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the seminar.';
                    ApplicationArea = Basic;
                }
                field(SeminarDuration; Seminar.Duration)
                {
                    Caption = 'Duration';
                    ToolTip = 'Specifies the seminar''s duration in days.';
                    ApplicationArea = Basic;
                }
                field(SeminarPrice; Seminar.Price)
                {
                    Caption = 'Price';
                    ToolTip = 'Specifies the price of the seminar.';
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                ToolTip = 'Open the card for the selected record.';
                Image = Edit;
                ShortCutKey = 'Return';

                trigger OnAction();
                begin
                    OpenSeminarCard()
                end;
            }
        }
    }

    var
        Seminar: Record "Seminar ASD";

    trigger OnAfterGetRecord();
    begin
        GetSeminar();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Clear(Seminar);
    end;

    trigger OnOpenPage();
    begin
        Rec.SetRange("User ID", UserId());
    end;

    local procedure GetSeminar(): Boolean;
    begin
        Clear(Seminar);
        exit(Seminar.Get(Rec."Seminar No."));
    end;

    local procedure OpenSeminarCard();
    begin
        if GetSeminar() then
            Page.Run(Page::"Seminar Card ASD", Seminar);
    end;
}