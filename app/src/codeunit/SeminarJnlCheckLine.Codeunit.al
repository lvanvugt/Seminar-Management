codeunit 123456731 "Seminar Jnl.-Check Line ASD"
{
    // ASD8.03 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 3 - Dimensions functionality

    TableNo = "Seminar Journal Line ASD";

    var
        CannotBeClosingDateErr: Label 'cannot be a closing date.';
        // ASD8.03<
        DimensionsCombinationBlockedErr: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        DimensionUsedCausedErrorErr: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
    // ASD8.03>

    trigger OnRun()
    begin
        RunCheck(Rec)
    end;

    // TODO: testable unit
    procedure RunCheck(var SeminarJnlLine: Record "Seminar Journal Line ASD")
    // ASD8.03<
    var
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    // ASD8.03>
    begin
        if SeminarJnlLine.EmptyLine() then
            exit;

        SeminarJnlLine.TestField("Posting Date");
        SeminarJnlLine.TestField("Seminar No.");

        case SeminarJnlLine."Charge Type" of
            SeminarJnlLine."Charge Type"::Instructor:
                SeminarJnlLine.TestField("Instructor Resource No.");
            SeminarJnlLine."Charge Type"::Room:
                SeminarJnlLine.TestField("Room Resource No.");
            SeminarJnlLine."Charge Type"::Participant:
                SeminarJnlLine.TestField("Participant Contact No.");
        end;

        if SeminarJnlLine.Chargeable then
            SeminarJnlLine.TestField("Bill-to Customer No.");

        CheckPostingDate(SeminarJnlLine);

        if SeminarJnlLine."Document Date" <> 0D then
            if SeminarJnlLine."Document Date" <> NormalDate(SeminarJnlLine."Document Date") then
                SeminarJnlLine.FieldError("Document Date", CannotBeClosingDateErr);

        // ASD8.03<
        if not DimensionManagement.CheckDimIDComb(SeminarJnlLine."Dimension Set ID") then
            Error(
              DimensionsCombinationBlockedErr,
              SeminarJnlLine.TableCaption, SeminarJnlLine."Journal Template Name",
              SeminarJnlLine."Journal Batch Name",
              SeminarJnlLine."Line No.",
              DimensionManagement.GetDimCombErr());

        TableID[1] := Database::"Seminar ASD";
        No[1] := SeminarJnlLine."Seminar No.";
        TableID[2] := Database::Resource;
        No[2] := SeminarJnlLine."Instructor Resource No.";
        TableID[3] := Database::Resource;
        No[3] := SeminarJnlLine."Room Resource No.";
        if not DimensionManagement.CheckDimValuePosting(TableID, No, SeminarJnlLine."Dimension Set ID") then
            if SeminarJnlLine."Line No." <> 0 then
                Error(
                    DimensionUsedCausedErrorErr,
                    SeminarJnlLine.TableCaption, SeminarJnlLine."Journal Template Name",
                    SeminarJnlLine."Journal Batch Name",
                    SeminarJnlLine."Line No.",
                    DimensionManagement.GetDimValuePostingErr())
            else
                Error(DimensionManagement.GetDimValuePostingErr);
        // ASD8.03>
    end;

    local procedure CheckPostingDate(SeminarJnlLine: Record "Seminar Journal Line ASD")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        if SeminarJnlLine."Posting Date" <> NormalDate(SeminarJnlLine."Posting Date") then
            SeminarJnlLine.FieldError("Posting Date", CannotBeClosingDateErr);

        UserSetupManagement.CheckAllowedPostingDate(SeminarJnlLine."Posting Date");
    end;
}