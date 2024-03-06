#if structured_spaghetti
codeunit 123456720 "Seminar-Post ASD"
{
    // ASD8.03 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 3 - Dimensions functionality

    Permissions = tabledata "Seminar Registration Line ASD" = imd,
                    tabledata "Posted Sem. Reg. Header ASD" = im,
                    tabledata "Posted Sem. Reg. Line ASD" = im;
    TableNo = "Sem. Registration Header ASD";

    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
        SeminarCharge: Record "Seminar Charge ASD";
        PstdSeminarRegistrationHeader: Record "Posted Sem. Reg. Header ASD";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        SeminarJnlPostLine: Codeunit "Seminar Jnl.-Post Line ASD";
        Window: Dialog;
        SourceCode: Code[10];
        NothingToPostErr: Label 'There is nothing to post.';
        PostingLinesMsg: Label 'Posting lines              #2######\';
        RegistrationMsg: Label 'Registration';
        RegistrationToPostedRegMsg: Label 'Registration %1  -> Posted Reg. %2';
        // ASD8.03>
        DimensionsCombinationBlockedErr: Label 'The combination of dimensions used in %1 is blocked. %2';
        DimensionsCombinationOnLineBlockedErr: Label 'The combination of dimensions used in %1,  line no. %2 is blocked. %3';
        DimensionsUsedAreInvalidErr: Label 'The dimensions used in %1 are invalid. %2';
        DimensionsUsedOnLineAreInvalidErr: Label 'The dimensions used in %1, line no. %2 are invalid. %3';
    // ASD8.03<

    trigger OnRun()
    begin
        ClearAll();
        SeminarRegistrationHeader := Rec;
        // Test Near / Test Far
        CheckAndUpdate(SeminarRegistrationHeader);

        // Do It
        Window.Update(1, StrSubstNo(RegistrationToPostedRegMsg, Rec."No.", PstdSeminarRegistrationHeader."No."));

        CopyCommentLines(
                "Seminar Document Type ASD"::"Seminar Registration",
                "Seminar Document Type ASD"::"Posted Seminar Registration",
                SeminarRegistrationHeader."No.", PstdSeminarRegistrationHeader."No."
            );
        CopyCharges(SeminarRegistrationHeader."No.", PstdSeminarRegistrationHeader."No.");

        PostLines(); // TODO: testable unit

        PostCharges(SeminarRegistrationHeader."No.");

        PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Instructor); // TODO: testable unit

        PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Room);

        // Cleanup
        FinalizePosting(SeminarRegistrationHeader);

        Rec := SeminarRegistrationHeader;
    end;

    local procedure CheckAndUpdate(var SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    var
        SeminarRegistrationLine2: Record "Seminar Registration Line ASD";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        // Test Near
        CheckMandatoryHeaderFields(SeminarRegistrationHeader2); // TODO: testable unit

        InitProgressWindow(SeminarRegistrationHeader2."No.");

        // Test Far
        SeminarRegistrationLine2.Reset(); // TODO: testable unit
        SeminarRegistrationLine2.SetRange("Document No.", SeminarRegistrationHeader2."No.");
        if SeminarRegistrationLine2.IsEmpty() then
            Error(NothingToPostErr);

        // ASD8.03>
        CheckDim(); // TODO: testable unit
        // ASD8.03<

        if UpdatePostingNos(SeminarRegistrationHeader2) then begin // TODO: testable unit
            SeminarRegistrationHeader2.Modify();
            Commit();
        end;

        SourceCodeSetup.Get();
        SourceCode := SourceCodeSetup."Seminar ASD";

        InsertPostedSeminarRegHeader(SeminarRegistrationHeader2);
    end;

    // TODO: testable unit
    local procedure CheckMandatoryHeaderFields(SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    begin
        SeminarRegistrationHeader2.TestField(Status, SeminarRegistrationHeader2.Status::Closed);
        SeminarRegistrationHeader2.TestField("Posting Date");
        SeminarRegistrationHeader2.TestField("Document Date");
        SeminarRegistrationHeader2.TestField("Seminar No.");
        SeminarRegistrationHeader2.TestField(Duration);
        SeminarRegistrationHeader2.TestField("Instructor Resource No.");
        SeminarRegistrationHeader2.TestField("Room Resource No.");
    end;

    local procedure InitProgressWindow(SeminarRegistrationHeaderNo: Code[20]);
    begin
        Window.Open(
                '#1#################################\\' +
                PostingLinesMsg
            );
        Window.Update(1, StrSubstNo('%1 %2', RegistrationMsg, SeminarRegistrationHeaderNo));
    end;

    local procedure UpdatePostingNos(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD") ModifyHeader: Boolean;
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if SeminarRegistrationHeader."Posting No." = '' then begin
            SeminarRegistrationHeader.TestField("Posting No. Series");
            SeminarRegistrationHeader."Posting No." := NoSeriesMgt.GetNextNo(SeminarRegistrationHeader."Posting No. Series", SeminarRegistrationHeader."Posting Date", true);
            ModifyHeader := true;
        end;
    end;

    local procedure InsertPostedSeminarRegHeader(SeminarRegistrationHeader: Record "Sem. Registration Header ASD");
    begin
        PstdSeminarRegistrationHeader.Init();
        PstdSeminarRegistrationHeader.TransferFields(SeminarRegistrationHeader);
        PstdSeminarRegistrationHeader."No." := SeminarRegistrationHeader."Posting No.";
        PstdSeminarRegistrationHeader."No. Series" := SeminarRegistrationHeader."Posting No. Series";
        PstdSeminarRegistrationHeader."Source Code" := SourceCode;
        PstdSeminarRegistrationHeader."User ID" := UserId();
        PstdSeminarRegistrationHeader.Insert();
    end;

    local procedure CopyCommentLines(FromDocumentType: Enum "Seminar Document Type ASD"; ToDocumentType: Enum "Seminar Document Type ASD"; FromNumber: Code[20]; ToNumber: Code[20]);
    var
        SeminarCommentLine: Record "Seminar Comment Line ASD";
        SeminarCommentLine2: Record "Seminar Comment Line ASD";
    begin
        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.Next() = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCharge: Record "Seminar Charge ASD";
        PostedSeminarCharge: Record "Posted Seminar Charge ASD";
    begin
        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", FromNumber);
        if SeminarCharge.FindSet() then
            repeat
                PostedSeminarCharge.TransferFields(SeminarCharge);
                PostedSeminarCharge."Document No." := ToNumber;
                PostedSeminarCharge.Insert();
            until SeminarCharge.Next() = 0;
    end;

    // TODO: testable unit
    local procedure PostLines()
    var
        LineCount: Integer;
    begin
        SeminarRegistrationLine.LockTable();
        LineCount := 0;
        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SeminarRegistrationLine.FindSet() then
            repeat
                LineCount := LineCount + 1;
                Window.Update(2, LineCount);

                SeminarRegistrationLine.TestField("Bill-to Customer No.");
                SeminarRegistrationLine.TestField("Participant Contact No.");

                if not SeminarRegistrationLine."To Invoice" then begin
                    SeminarRegistrationLine.Price := 0;
                    SeminarRegistrationLine."Line Discount %" := 0;
                    SeminarRegistrationLine."Line Discount Amount" := 0;
                    SeminarRegistrationLine.Amount := 0;
                end;

                PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Participant);

                InsertPostedSeminarRegistrationLine(SeminarRegistrationLine);
            until SeminarRegistrationLine.Next() = 0;
    end;

    local procedure InsertPostedSeminarRegistrationLine(SeminarRegistrationLine2: Record "Seminar Registration Line ASD");
    var
        PstdSeminarRegLine: Record "Posted Sem. Reg. Line ASD";
    begin
        PstdSeminarRegLine.Init();
        PstdSeminarRegLine.TransferFields(SeminarRegistrationLine2);
        PstdSeminarRegLine."Document No." := PstdSeminarRegistrationHeader."No.";
        PstdSeminarRegLine.Insert();
    end;

    local procedure PostSeminarJnlLine(ChargeType: Enum "Seminar Journal Charge Type ASD"): Integer
    var
        SeminarJnlLine: Record "Seminar Journal Line ASD";
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SetGeneralDataOnSeminarJnlLine(SeminarJnlLine, SeminarRegistrationHeader, ChargeType);

        case ChargeType of
            ChargeType::Instructor:
                SetInstructorDataOnSeminarJnlLineAndPostResJnlLine(SeminarJnlLine, SeminarRegistrationHeader);
            ChargeType::Room:
                SetRoomDataOnSeminarJnlLineAndPostResJnlLine(SeminarJnlLine, SeminarRegistrationHeader);
            ChargeType::Participant:
                // ASD8.03>
                //SetParticipantDataOnSeminarJnlLine(SeminarJnlLine, SeminarRegistrationLine);
                begin
                    SetParticipantDataOnSeminarJnlLine(SeminarJnlLine, SeminarRegistrationLine);
                    SeminarJnlLine."Dimension Set ID" := SeminarRegistrationLine."Dimension Set ID";
                end;
            // ASD8.03<
            ChargeType::Charge:
                SetChargeDataOnSeminarJnlLine(SeminarJnlLine, SeminarCharge);
        end;

        SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);

        SeminarLedgerEntry.FindLast();
        exit(SeminarLedgerEntry."Entry No.")
    end;

    local procedure SetGeneralDataOnSeminarJnlLine(var SeminarJournalLine: Record "Seminar Journal Line ASD"; SeminarRegistrationHeader: Record "Sem. Registration Header ASD"; ChargeType: Enum "Seminar Journal Charge Type ASD")
    begin
        SeminarJournalLine.Init();
        SeminarJournalLine."Seminar No." := SeminarRegistrationHeader."Seminar No.";
        SeminarJournalLine."Posting Date" := SeminarRegistrationHeader."Posting Date";
        SeminarJournalLine."Document Date" := SeminarRegistrationHeader."Document Date";
        SeminarJournalLine."Document No." := PstdSeminarRegistrationHeader."No.";
        SeminarJournalLine."Charge Type" := ChargeType;
        SeminarJournalLine."Starting Date" := SeminarRegistrationHeader."Starting Date";
        SeminarJournalLine."Seminar Registration No." := PstdSeminarRegistrationHeader."No.";
        SeminarJournalLine."Source Type" := SeminarJournalLine."Source Type"::Seminar;
        SeminarJournalLine."Source No." := SeminarRegistrationHeader."Seminar No.";
        SeminarJournalLine."Source Code" := SourceCode;
        SeminarJournalLine."Reason Code" := SeminarRegistrationHeader."Reason Code";
        SeminarJournalLine."Posting No. Series" := SeminarRegistrationHeader."Posting No. Series";
        // ASD8.03>
        SeminarJournalLine."Shortcut Dimension 1 Code" := SeminarRegistrationHeader."Shortcut Dimension 1 Code";
        SeminarJournalLine."Shortcut Dimension 2 Code" := SeminarRegistrationHeader."Shortcut Dimension 2 Code";
        SeminarJournalLine."Dimension Set ID" := SeminarRegistrationHeader."Dimension Set ID";
        // ASD8.03<
    end;

    local procedure SetInstructorDataOnSeminarJnlLineAndPostResJnlLine(var SeminarJournalLine: Record "Seminar Journal Line ASD"; SeminarRegistrationHeader: Record "Sem. Registration Header ASD");
    var
        Instructor: Record Resource;
    begin
        Instructor.Get(SeminarRegistrationHeader."Instructor Resource No.");
        SeminarJournalLine."Instructor Resource No." := SeminarRegistrationHeader."Instructor Resource No.";
        SeminarJournalLine.Description := Instructor.Name;
        SeminarJournalLine.Type := SeminarJournalLine.Type::Resource;
        SeminarJournalLine.Chargeable := false;
        SeminarJournalLine.Quantity := SeminarRegistrationHeader.Duration;
        SeminarJournalLine."Unit Price" := Instructor."Quantity per Day ASD";
        SeminarJournalLine."Total Price" := SeminarRegistrationHeader.Duration * SeminarJournalLine."Unit Price";
        SeminarJournalLine."Resource Ledger Entry No." := PostResJnlLine(Instructor);
    end;

    local procedure SetRoomDataOnSeminarJnlLineAndPostResJnlLine(var SeminarJournalLine: Record "Seminar Journal Line ASD"; SeminarRegistrationHeader: Record "Sem. Registration Header ASD");
    var
        Room: Record Resource;
    begin
        Room.Get(SeminarRegistrationHeader."Room Resource No.");
        SeminarJournalLine."Room Resource No." := SeminarRegistrationHeader."Room Resource No.";
        SeminarJournalLine.Description := Room.Name;
        SeminarJournalLine.Type := SeminarJournalLine.Type::Resource;
        SeminarJournalLine.Chargeable := false;
        SeminarJournalLine.Quantity := SeminarRegistrationHeader.Duration;
        SeminarJournalLine."Unit Price" := Room."Quantity per Day ASD";
        SeminarJournalLine."Total Price" := SeminarRegistrationHeader.Duration * SeminarJournalLine."Unit Price";
        SeminarJournalLine."Resource Ledger Entry No." := PostResJnlLine(Room);
    end;

    local procedure PostResJnlLine(Resource: Record Resource): Integer
    var
        ResJnlLine: Record "Res. Journal Line";
        ResourceLedgerEntry: Record "Res. Ledger Entry";
    begin
        Resource.TestField("Quantity per Day ASD");

        ResJnlLine.Init();
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := PstdSeminarRegistrationHeader."No.";
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Posting Date" := SeminarRegistrationHeader."Posting Date";
        ResJnlLine."Reason Code" := SeminarRegistrationHeader."Reason Code";
        ResJnlLine.Description := SeminarRegistrationHeader."Seminar Name";
        ResJnlLine."Gen. Prod. Posting Group" := SeminarRegistrationHeader."Gen. Prod. Posting Group";
        ResJnlLine."Source Code" := SourceCode;
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        ResJnlLine."Unit Cost" := Resource."Unit Cost";
        ResJnlLine."Qty. per Unit of Measure" := 1;
        ResJnlLine."Document Date" := SeminarRegistrationHeader."Document Date";
        ResJnlLine."Posting No. Series" := SeminarRegistrationHeader."Posting No. Series";

        ResJnlLine.Quantity := SeminarRegistrationHeader.Duration * Resource."Quantity per Day ASD";
        ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" * ResJnlLine.Quantity;
        ResJnlLine."Seminar No. ASD" := SeminarRegistrationHeader."Seminar No.";
        ResJnlLine."Seminar Registration No. ASD" := PstdSeminarRegistrationHeader."No.";
        // ASD8.03>
        ResJnlLine."Shortcut Dimension 1 Code" := SeminarRegistrationHeader."Shortcut Dimension 1 Code";
        ResJnlLine."Shortcut Dimension 2 Code" := SeminarRegistrationHeader."Shortcut Dimension 2 Code";
        ResJnlLine."Dimension Set ID" := SeminarRegistrationHeader."Dimension Set ID";
        // ASD8.03<

        ResJnlPostLine.RunWithCheck(ResJnlLine);

        ResourceLedgerEntry.FindLast();
        exit(ResourceLedgerEntry."Entry No.")
    end;

    local procedure SetParticipantDataOnSeminarJnlLine(var SeminarJournalLine: Record "Seminar Journal Line ASD"; SeminarRegistrationLine: Record "Seminar Registration Line ASD");
    begin
        SeminarJournalLine."Bill-to Customer No." := SeminarRegistrationLine."Bill-to Customer No.";
        SeminarJournalLine."Participant Contact No." := SeminarRegistrationLine."Participant Contact No.";
        SeminarRegistrationLine.CalcFields("Participant Name");
        SeminarJournalLine."Participant Name" := SeminarRegistrationLine."Participant Name";
        SeminarJournalLine.Description := SeminarRegistrationLine."Participant Name";
        SeminarJournalLine.Type := SeminarJournalLine.Type::Resource;
        SeminarJournalLine.Chargeable := SeminarRegistrationLine."To Invoice";
        SeminarJournalLine.Quantity := 1;
        SeminarJournalLine."Unit Price" := SeminarRegistrationLine.Amount;
        SeminarJournalLine."Total Price" := SeminarRegistrationLine.Amount;
    end;

    local procedure SetChargeDataOnSeminarJnlLine(var SeminarJournalLine: Record "Seminar Journal Line ASD"; SeminarCharge2: Record "Seminar Charge ASD");
    begin
        SeminarJournalLine.Description := SeminarCharge2.Description;
        SeminarJournalLine."Bill-to Customer No." := SeminarCharge2."Bill-to Customer No.";
        SeminarJournalLine.Type := SeminarCharge2.Type;
        SeminarJournalLine.Chargeable := SeminarCharge2."To Invoice";
        SeminarJournalLine.Quantity := SeminarCharge2.Quantity;
        SeminarJournalLine."Unit Price" := SeminarCharge2."Unit Price";
        SeminarJournalLine."Total Price" := SeminarCharge2."Total Price";
    end;

    local procedure PostCharges(SeminarRegistrationHeaderNo: Code[20])
    begin
        SeminarCharge.SetRange("Document No.", SeminarRegistrationHeaderNo);
        if SeminarCharge.FindSet() then
            repeat
                PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Charge);
            until SeminarCharge.Next() = 0;
    end;

    local procedure FinalizePosting(SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    var
        SeminarRegistrationLine2: Record "Seminar Registration Line ASD";
        SeminarCommentLine: Record "Seminar Comment Line ASD";
        SeminarCharge: Record "Seminar Charge ASD";
    begin
        SeminarRegistrationHeader2.Delete();

        SeminarRegistrationLine2.SetRange("Document No.", SeminarRegistrationHeader2."No.");
        SeminarRegistrationLine2.DeleteAll();

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", SeminarRegistrationHeader2."No.");
        SeminarCommentLine.DeleteAll();

        SeminarCharge.Reset();
        SeminarCharge.SetRange("No.", SeminarRegistrationHeader2."No.");
        SeminarCharge.DeleteAll();

        Window.Close();
    end;

    // ASD8.03<
    local procedure CheckDim()
    var
        SeminarRegLine2: Record "Seminar Registration Line ASD";
    begin
        SeminarRegLine2."Line No." := 0;
        CheckDimValuePosting(SeminarRegLine2);
        CheckDimComb(SeminarRegLine2);

        SeminarRegLine2.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SeminarRegLine2.FindSet() then
            repeat
                CheckDimComb(SeminarRegLine2);
                CheckDimValuePosting(SeminarRegLine2);
            until SeminarRegLine2.Next() = 0;
    end;

    local procedure CheckDimComb(SeminarRegistrationLine: Record "Seminar Registration Line ASD");
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        if SeminarRegistrationLine."Line No." = 0 then
            if not DimensionManagement.CheckDimIDComb(SeminarRegistrationHeader."Dimension Set ID") then
                Error(
                    DimensionsCombinationBlockedErr,
                    SeminarRegistrationHeader."No.",
                    DimensionManagement.GetDimCombErr());

        if SeminarRegistrationLine."Line No." <> 0 then
            if not DimensionManagement.CheckDimIDComb(SeminarRegistrationLine."Dimension Set ID") then
                Error(
                    DimensionsCombinationOnLineBlockedErr,
                    SeminarRegistrationHeader."No.",
                    SeminarRegistrationLine."Line No.",
                    DimensionManagement.GetDimCombErr());
    end;

    local procedure CheckDimValuePosting(var SeminarRegLine2: Record "Seminar Registration Line ASD");
    var
        DimensionManagement: Codeunit DimensionManagement;
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if SeminarRegLine2."Line No." = 0 then begin
            TableIDArr[1] := Database::"Seminar ASD";
            NumberArr[1] := SeminarRegistrationHeader."Seminar No.";
            TableIDArr[2] := Database::Resource;
            NumberArr[2] := SeminarRegistrationHeader."Instructor Resource No.";
            TableIDArr[3] := Database::Resource;
            NumberArr[3] := SeminarRegistrationHeader."Room Resource No.";
            if not DimensionManagement.CheckDimValuePosting(
                TableIDArr,
                NumberArr,
                SeminarRegistrationHeader."Dimension Set ID")
            then
                Error(
                    DimensionsUsedAreInvalidErr,
                    SeminarRegistrationHeader."No.",
                    DimensionManagement.GetDimValuePostingErr());
        end else begin
            TableIDArr[1] := Database::Customer;
            NumberArr[1] := SeminarRegLine2."Bill-to Customer No.";
            if not DimensionManagement.CheckDimValuePosting(
                TableIDArr,
                NumberArr,
                SeminarRegLine2."Dimension Set ID")
            then
                Error(
                    DimensionsUsedOnLineAreInvalidErr,
                    SeminarRegistrationHeader."No.",
                    SeminarRegLine2."Line No.",
                    DimensionManagement.GetDimValuePostingErr());
        end;
    end;
    // ASD8.03<
}
#endif