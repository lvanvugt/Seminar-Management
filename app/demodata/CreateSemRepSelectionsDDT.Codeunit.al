codeunit 123456793 "CreateSemRepSelectionsDDTASD"
{
    trigger OnRun();
    begin
        CreateSeminarReportSelections();
    end;

    local procedure CreateSeminarReportSelections();
    begin
        CreateSeminarReportSelection(123456701);
    end;

    local procedure CreateSeminarReportSelection(ReportID: Integer);
    var
        SeminarReportSelections: Record "Seminar Report Selections ASD";
    begin
        SeminarReportSelections.Usage := SeminarReportSelections.Usage::"S. Registration";
        SeminarReportSelections.NewRecord();
        SeminarReportSelections."Report ID" := ReportID;
        if SeminarReportSelections.Insert(true) then;
    end;
}