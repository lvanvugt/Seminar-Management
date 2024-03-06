page 123456723 "Seminar Report Selections ASD"
{
    Caption = 'Seminar Report Selection';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Seminar Report Selections ASD";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(ReportUsage; ReportUsage)
            {
                Caption = 'Usage';
                ApplicationArea = All;
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate();
                begin
                    SetUsageFilter();
                    ReportUsageOnAfterValidate();
                end;
            }
            repeater(RepeaterControl)
            {
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the object ID of the report.';
                    LookupPageID = Objects;
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the display name of the report.';
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.NewRecord();
    end;

    trigger OnOpenPage();
    begin
        SetUsageFilter();
    end;

    var
        ReportUsage: Enum "Seminar Report Selection Usage ASD";

    local procedure SetUsageFilter();
    begin
        Rec.FilterGroup(2);
        case ReportUsage of
            ReportUsage::"S. Registration":
                Rec.SetRange(Usage, Rec.Usage::"S. Registration");
        end;
        Rec.FilterGroup(0);
    end;

    local procedure ReportUsageOnAfterValidate();
    begin
        CurrPage.Update();
    end;
}