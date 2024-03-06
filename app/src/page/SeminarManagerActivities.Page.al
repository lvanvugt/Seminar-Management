page 123456741 "Seminar Manager Activities ASD"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Seminar Cue ASD";

    layout
    {
        area(Content)
        {
            cuegroup(Registrations)
            {
                Caption = 'Registrations';
                field(Planned; Rec.Planned)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of seminars in planning.';
                    DrillDownPageID = "Seminar Registration List ASD";
                    Image = Calendar;
                }
                field(Registered; Rec.Registered)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of seminars open for registration.';
                    DrillDownPageID = "Seminar Registration List ASD";
                    Image = Time;
                }
                field("Days before Next"; Rec."Days before Next")
                {
                    ToolTip = 'Specifies the number of days before the next seminar starts.';
                    Image = Calendar;
                }

                actions
                {
                    action(New)
                    {
                        ApplicationArea = All;
                        Caption = 'New';
                        ToolTip = 'Create a new seminar registration.';
                        Image = TileNew;
                        RunObject = Page "Seminar Registration List ASD";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(ForPosting)
            {
                Caption = 'For Posting';
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of closed seminar registrations and ready for posting.';
                    DrillDownPageID = "Seminar Registration List ASD";
                    Image = Library;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetUpCues)
            {
                ApplicationArea = All;
                Caption = 'Set Up Cues';
                ToolTip = 'Set up the cues (status tiles) related to the role.';
                Image = Setup;

                trigger OnAction();
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number());
                end;
            }
        }
    }

    var
        CueSetup: Codeunit "Cues And KPIs";

    trigger OnOpenPage()
    begin
        Rec.InsertRecord();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues();
    end;

    local procedure CalculateCueFieldValues()
    begin
        if Rec.FieldActive("Days before Next") then
            Rec."Days before Next" := Rec.CalculateDaysToNext();
    end;
}