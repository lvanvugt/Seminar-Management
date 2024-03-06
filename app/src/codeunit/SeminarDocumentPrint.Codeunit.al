codeunit 123456704 "Seminar Document Print ASD"
{
    procedure PrintSeminarRegistrationHeader(SeminarRegHeader: Record "Sem. Registration Header ASD");
    var
        ReportSelection: Record "Seminar Report Selections ASD";
    begin
        SeminarRegHeader.SetRecFilter();
        ReportSelection.SetRange(Usage, ReportSelection.Usage::"S. Registration");
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.Ascending := false;
        ReportSelection.FindSet();
        repeat
            Report.RunModal(ReportSelection."Report ID", true, false, SeminarRegHeader);
        until ReportSelection.Next() = 0;
    end;
}