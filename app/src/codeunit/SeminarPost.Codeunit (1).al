#if spaghetti
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
        Room: Record Resource;
        Instructor: Record Resource;
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
    var
        SeminarCommentLine: Record 123456704;
        PstdSeminarRegLine: Record "Posted Sem. Reg. Line ASD";
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineCount: Integer;
    begin
        ClearAll();
        SeminarRegistrationHeader := Rec;
        // Test Near / Test Far
        SeminarRegistrationHeader.TestField("Posting Date");
        SeminarRegistrationHeader.TestField("Document Date");
        SeminarRegistrationHeader.TestField("Seminar No.");
        SeminarRegistrationHeader.TestField(Duration);
        SeminarRegistrationHeader.TestField("Instructor Resource No.");
        SeminarRegistrationHeader.TestField("Room Resource No.");
        SeminarRegistrationHeader.TestField(Status, SeminarRegistrationHeader.Status::Closed);

        // ASD8.03>
        CheckDim;
        // ASD8.03<

        Room.Get(SeminarRegistrationHeader."Room Resource No.");
        Room.TestField("No.");
        GetInstructor();
        Instructor.TestField("No.");

        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SeminarRegistrationLine.IsEmpty() then
            Error(NothingToPostErr);

        Window.Open(
          '#1#################################\\' +
          PostingLinesMsg);
        // Do It
        Window.Update(1, StrSubstNo('%1 %2', RegistrationMsg, SeminarRegistrationHeader."No."));

        if SeminarRegistrationHeader."Posting No." = '' then begin
            SeminarRegistrationHeader.TestField("Posting No. Series");
            SeminarRegistrationHeader."Posting No." := NoSeriesMgt.GetNextNo(SeminarRegistrationHeader."Posting No. Series", SeminarRegistrationHeader."Posting Date", true);
            SeminarRegistrationHeader.Modify();
            Commit();
        end;
        SeminarRegistrationLine.LockTable();

        SourceCodeSetup.Get();
        SourceCode := SourceCodeSetup."Seminar ASD";

        // Insert posted seminar registration header
        PstdSeminarRegistrationHeader.Init();
        PstdSeminarRegistrationHeader.TransferFields(SeminarRegistrationHeader);
        PstdSeminarRegistrationHeader."No." := SeminarRegistrationHeader."Posting No.";
        PstdSeminarRegistrationHeader."No. Series" := SeminarRegistrationHeader."Posting No. Series";
        PstdSeminarRegistrationHeader."Source Code" := SourceCode;
        PstdSeminarRegistrationHeader."User ID" := USERID;
        PstdSeminarRegistrationHeader.Insert();

        Window.Update(1, StrSubstNo(RegistrationToPostedRegMsg, SeminarRegistrationHeader."No.", PstdSeminarRegistrationHeader."No."));

        CopyCommentLines(
          "Seminar Document Type ASD"::"Seminar Registration",
          "Seminar Document Type ASD"::"Posted Seminar Registration",
          SeminarRegistrationHeader."No.", PstdSeminarRegistrationHeader."No.");
        CopyCharges(SeminarRegistrationHeader."No.", PstdSeminarRegistrationHeader."No.");

        // Lines
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

                // Post seminar entry
                PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Participant);

                // Insert posted seminar registration line
                PstdSeminarRegLine.Init();
                PstdSeminarRegLine.TransferFields(SeminarRegistrationLine);
                PstdSeminarRegLine."Document No." := PstdSeminarRegistrationHeader."No.";
                PstdSeminarRegLine.Insert();
            until SeminarRegistrationLine.Next() = 0;

        // Post charges to seminar ledger
        PostCharges();

        // Post instructor to seminar ledger
        PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Instructor);

        // Post seminar room to seminar ledger
        PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Room);

        // Cleanup
        SeminarRegistrationHeader.Delete();
        SeminarRegistrationLine.DeleteAll();

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", SeminarRegistrationHeader."No.");
        SeminarCommentLine.DeleteAll();

        SeminarCharge.Reset();
        SeminarCharge.SetRange("No.", SeminarRegistrationHeader."No.");
        SeminarCharge.DeleteAll();

        Window.Close();

        Rec := SeminarRegistrationHeader;
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

    local procedure PostSeminarJnlLine(ChargeType: Enum "Seminar Journal Charge Type ASD"): Integer
    var
        SeminarJnlLine: Record "Seminar Journal Line ASD";
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarJnlLine.Init();
        SeminarJnlLine."Seminar No." := SeminarRegistrationHeader."Seminar No.";
        SeminarJnlLine."Posting Date" := SeminarRegistrationHeader."Posting Date";
        SeminarJnlLine."Document Date" := SeminarRegistrationHeader."Document Date";
        SeminarJnlLine."Document No." := PstdSeminarRegistrationHeader."No.";
        SeminarJnlLine."Charge Type" := ChargeType;
        SeminarJnlLine."Starting Date" := SeminarRegistrationHeader."Starting Date";
        SeminarJnlLine."Seminar Registration No." := PstdSeminarRegistrationHeader."No.";
        SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
        SeminarJnlLine."Source No." := SeminarRegistrationHeader."Seminar No.";
        SeminarJnlLine."Source Code" := SourceCode;
        SeminarJnlLine."Reason Code" := SeminarRegistrationHeader."Reason Code";
        SeminarJnlLine."Posting No. Series" := SeminarRegistrationHeader."Posting No. Series";
        // ASD8.03>
        SeminarJnlLine."Shortcut Dimension 1 Code" := SeminarRegistrationHeader."Shortcut Dimension 1 Code";
        SeminarJnlLine."Shortcut Dimension 2 Code" := SeminarRegistrationHeader."Shortcut Dimension 2 Code";
        SeminarJnlLine."Dimension Set ID" := SeminarRegistrationHeader."Dimension Set ID";
        // ASD8.03<
        case ChargeType of
            ChargeType::Instructor:
                begin
                    GetInstructor;
                    SeminarJnlLine."Instructor Resource No." := SeminarRegistrationHeader."Instructor Resource No.";
                    SeminarJnlLine.Description := Instructor.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := false;
                    SeminarJnlLine.Quantity := SeminarRegistrationHeader.Duration;
                    SeminarJnlLine."Unit Price" := Instructor."Quantity per Day ASD";
                    SeminarJnlLine."Total Price" := SeminarRegistrationHeader.Duration * SeminarJnlLine."Unit Price";
                    SeminarJnlLine."Resource Ledger Entry No." := PostResJnlLine(Instructor);
                end;
            ChargeType::Room:
                begin
                    Room.Get(SeminarRegistrationHeader."Room Resource No.");
                    SeminarJnlLine."Room Resource No." := SeminarRegistrationHeader."Room Resource No.";
                    SeminarJnlLine.Description := Room.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := false;
                    SeminarJnlLine.Quantity := SeminarRegistrationHeader.Duration;
                    SeminarJnlLine."Unit Price" := Room."Quantity per Day ASD";
                    SeminarJnlLine."Total Price" := SeminarRegistrationHeader.Duration * SeminarJnlLine."Unit Price";
                    SeminarJnlLine."Resource Ledger Entry No." := PostResJnlLine(Room);
                end;
            ChargeType::Participant:
                begin
                    SeminarJnlLine."Bill-to Customer No." := SeminarRegistrationLine."Bill-to Customer No.";
                    SeminarJnlLine."Participant Contact No." := SeminarRegistrationLine."Participant Contact No.";
                    SeminarRegistrationLine.CalcFields("Participant Name");
                    SeminarJnlLine."Participant Name" := SeminarRegistrationLine."Participant Name";
                    SeminarJnlLine.Description := SeminarRegistrationLine."Participant Name";
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := SeminarRegistrationLine."To Invoice";
                    SeminarJnlLine.Quantity := 1;
                    SeminarJnlLine."Unit Price" := SeminarRegistrationLine.Amount;
                    SeminarJnlLine."Total Price" := SeminarRegistrationLine.Amount;
                    // ASD8.03>
                    SeminarJnlLine."Dimension Set ID" := SeminarRegistrationLine."Dimension Set ID";
                    // ASD8.03<
                end;
            ChargeType::Charge:
                begin
                    SeminarJnlLine.Description := SeminarCharge.Description;
                    SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                    SeminarJnlLine.Type := SeminarCharge.Type;
                    SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                    SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                    SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                    SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                end;
        end;

        SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);

        SeminarLedgerEntry.FindLast();
        exit(SeminarLedgerEntry."Entry No.")
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

    local procedure PostCharges()
    begin
        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SeminarCharge.FindSet() then
            repeat
                PostSeminarJnlLine("Seminar Journal Charge Type ASD"::Charge);
            until SeminarCharge.Next() = 0;
    end;

    procedure GetInstructor()
    begin
        if Instructor."No." <> SeminarRegistrationHeader."Instructor Resource No." then
            Instructor.Get(SeminarRegistrationHeader."Instructor Resource No.");
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