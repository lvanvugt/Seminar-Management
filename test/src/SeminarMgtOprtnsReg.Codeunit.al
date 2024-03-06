codeunit 123456776 "Seminar Mgt. Oprtns. Reg. ASD"
{
    // [FEATURE] [Seminar Management - Operation]

    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarMgtLibraryOperations: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        isInitialized: Boolean;
        StatusMustBeEqualToErr: Label '%1 must be equal to ''%2''  in %3: %4=%5. Current value is ''%6''.';
        FieldOnTableEqualToFieldOnTableErr: Label '%1 on %2 must be equal to %3 on %4.';

    local procedure Initialize();
    begin
        if isInitialized then
            exit;

        SeminarMgtLibraryInitialize.Initialize();

        Commit();
        isInitialized := true;
    end;

    [Test]
    procedure DeleteSeminarRegistrationNotCancelled();
    var
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0030] When deleting a seminar registration with status <> Canceled an error should be thrown
        // [GIVEN] A seminar registration status <> Canceled
        Initialize();
        SeminarRegistrationNo := CreateSeminarRegistration();

        // [WHEN] Deleting the seminar
        asserterror DeleteSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Verify that right error has been shown
        VerifyStatusError(SeminarRegistrationNo, "Seminar Document Status ASD"::Canceled);
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes')]
    procedure PostFromSeminarRegistrationList();
    var
        InstructorResourceNo: Code[20];
        PostingNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0070] When pressing post button on SeminarRegistrationList posting of closed seminar registration is being triggered
        Initialize();
        // [GIVEN] A seminar
        SeminarNo := CreateSeminar();
        // [GIVEN] An instructor resource
        InstructorResourceNo := CreateInstructorResource();
        // [GIVEN] A room resource
        RoomResourceNo := CreateRoomResource();
        // [GIVEN] A closed seminar registration with a seminar, instructor and room selected and one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo);
        PostingNo := SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Press post button on SeminarRegistrationList - ConfirmHandlerYes will handle user input
        PressPostOnSeminarRegistrationList(SeminarRegistrationNo);

        // [THEN] Verify that the seminar registration was posted, i.e. is removed
        VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo);
        // [THEN] A posted seminar registration exists
        VerifyPostedSeminarRegistrationExists(PostingNo);
        // [THEN] Related ledger entries exist
        VerifySeminarLedgerEntriesExist(PostingNo);
    end;

    [Test]
    procedure InheritFromSeminarToSeminarRegistrationWithoutLines();
    var
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0020] When selecting a seminar on a seminar registration header without lines related fields should get populate
        Initialize();
        // [GIVEN] A seminar registration without lines
        SeminarRegistrationNo := CreateSeminarRegistration();
        // [GIVEN] A seminar
        SeminarNo := CreateSeminar();

        // [WHEN] Selecting seminar on seminar registration header
        SetSeminarNoOnSeminarRegistration(SeminarNo, SeminarRegistrationNo);

        // [THEN] "Seminar Name" on seminar registration is copied from seminar
        // [THEN] Duration on seminar registration is copied from seminar
        // [THEN] Price on seminar registration is copied from seminar 
        // [THEN] "Gen. Prod. Posting Group" on seminar registration is copied from seminar
        // [THEN] "VAT Prod. Posting Group" on seminar registration is copied from seminar
        // [THEN] "Minimum Participants" on seminar registration is copied from seminar
        // [THEN] "Maximum Participants" on seminar registration is copied from seminar
        VerifyInheritanceFromSeminarToSeminarRegistration(SeminarNo, SeminarRegistrationNo);
    end;

    local procedure CreateSeminar(): Code[20];
    begin
        exit(SeminarMgtLibrarySetup.CreateSeminarNo(false));
    end;

    local procedure CreateInstructorResource(): Code[20];
    var
        InstructorResource: Record Resource;
    begin
        SeminarMgtLibrarySetup.CreateInstructorResource(InstructorResource);
        exit(InstructorResource."No.");
    end;

    local procedure CreateRoomResource(): Code[20];
    var
        RoomResource: Record Resource;
    begin
        SeminarMgtLibrarySetup.CreateRoomResource(RoomResource);
        exit(RoomResource."No.");
    end;

    local procedure CreateSeminarRegistration(): Code[20];
    begin
        exit(SeminarMgtLibraryOperations.CreateSeminarRegistrationNo());
    end;

    local procedure CreateCompleteSeminarRegistrationWithOneLine(SeminarNo: Code[20]; InstructorNo: Code[20]; RoomNo: Code[20]): Code[20];
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
    begin
        SeminarMgtLibraryOperations.CreateSeminarRegistration(SeminarRegistrationHeader);

        SeminarRegistrationHeader.Validate("Seminar No.", SeminarNo);
        SeminarRegistrationHeader.Validate("Instructor Resource No.", InstructorNo);
        SeminarRegistrationHeader.Validate("Room Resource No.", RoomNo);
        SeminarRegistrationHeader.Modify();

        SeminarMgtLibraryOperations.CreateSeminarRegistrationLine(SeminarRegistrationLine, SeminarRegistrationHeader."No.");
        exit(SeminarRegistrationHeader."No.");
    end;

    local procedure DeleteSeminarRegistration(SeminarRegistrationNo: Code[20]);
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Delete(true);
    end;

    local procedure PressPostOnSeminarRegistrationList(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationList: TestPage "Seminar Registration List ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationList.OpenView();
        SeminarRegistrationList.GoToRecord(SeminarRegistrationHeader);
        SeminarRegistrationList.Post.Invoke();
    end;

    local procedure SetSeminarNoOnSeminarRegistration(SeminarNo: Code[20]; SeminarRegistrationNo: Code[20]);
    var
        Seminar: Record "Seminar ASD";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Validate("Seminar No.", SeminarNo);
        SeminarRegistrationHeader.Modify();
    end;

    local procedure SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo: Code[20]; NewStatus: Enum "Seminar Document Status ASD") PostingNo: Code[20];
    var
        Seminar: Record "Seminar ASD";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Validate(Status, NewStatus);
        SeminarRegistrationHeader.Validate("Posting No.", LibraryUtility.GetGlobalNoSeriesCode());
        SeminarRegistrationHeader.Modify();
        exit(SeminarRegistrationHeader."Posting No.");
    end;

    local procedure VerifyStatusError(SeminarRegistrationNo: Code[20]; ExpectedStatus: Enum "Seminar Document Status ASD");
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        Assert.ExpectedError(
            StrSubstNo(
                StatusMustBeEqualToErr,
                SeminarRegistrationHeader.FieldCaption(Status),
                ExpectedStatus,
                SeminarRegistrationHeader.TableCaption(),
                SeminarRegistrationHeader.FieldCaption("No."),
                SeminarRegistrationNo,
                SeminarRegistrationHeader.Status));
    end;

    local procedure VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo: Code[20]);
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.SetRange("No.", SeminarRegistrationNo);
        Assert.RecordIsEmpty(SeminarRegistrationHeader);
    end;

    local procedure VerifyPostedSeminarRegistrationExists(PostingNo: Code[20]);
    var
        PostedSeminarRegHeader: Record "Posted Sem. Reg. Header ASD";
    begin
        PostedSeminarRegHeader.SetRange("No.", PostingNo);
        Assert.RecordIsNotEmpty(PostedSeminarRegHeader);
    end;

    local procedure VerifySeminarLedgerEntriesExist(PostingNo: Code[20]);
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Document No.", PostingNo);
        Assert.RecordIsNotEmpty(SeminarLedgerEntry);
    end;

    local procedure VerifyInheritanceFromSeminarToSeminarRegistration(SeminarNo: Code[20]; SeminarRegistrationNo: Code[20]);
    var
        Seminar: Record "Seminar ASD";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        Seminar.Get(SeminarNo);
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar.Name,
            SeminarRegistrationHeader."Seminar Name",
            Seminar.FieldCaption(Name),
            SeminarRegistrationHeader.FieldCaption(SeminarRegistrationHeader."Seminar Name"));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar.Duration,
            SeminarRegistrationHeader."Duration",
            Seminar.FieldCaption("Duration"),
            SeminarRegistrationHeader.FieldCaption(Duration));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar.Price,
            SeminarRegistrationHeader.Price,
            Seminar.FieldCaption(Price),
            SeminarRegistrationHeader.FieldCaption(Price));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar."Gen. Prod. Posting Group",
            SeminarRegistrationHeader."Gen. Prod. Posting Group",
            Seminar.FieldCaption("Gen. Prod. Posting Group"),
            SeminarRegistrationHeader.FieldCaption("Gen. Prod. Posting Group"));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar."VAT Prod. Posting Group",
            SeminarRegistrationHeader."VAT Prod. Posting Group",
            Seminar.FieldCaption("VAT Prod. Posting Group"),
            SeminarRegistrationHeader.FieldCaption("VAT Prod. Posting Group"));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar."Minimum Participants",
            SeminarRegistrationHeader."Minimum Participants",
            Seminar.FieldCaption("Minimum Participants"),
            SeminarRegistrationHeader.FieldCaption("Minimum Participants"));
        FieldsAreEqualInSeminarRegistrationAndSeminar(
            Seminar."Maximum Participants",
            SeminarRegistrationHeader."Maximum Participants",
            Seminar.FieldCaption("Maximum Participants"),
            SeminarRegistrationHeader.FieldCaption("Maximum Participants"));
    end;

    local procedure FieldsAreEqualInSeminarRegistrationAndSeminar(Expected: Variant; Actual: Variant; FieldCaption1: Text; FieldCaption2: Text);
    var
        Seminar: Record "Seminar ASD";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        FieldsAreEqual(Expected, Actual, FieldCaption2, SeminarRegistrationHeader.TableCaption, FieldCaption1, Seminar.TableCaption);
    end;

    local procedure FieldsAreEqual(Expected: Variant; Actual: Variant; FieldCaption1: Text; TableCaption1: Text; FieldCaption2: Text; TableCaption2: Text);
    begin
        Assert.AreEqual(Expected, Actual,
            StrSubstNo(FieldOnTableEqualToFieldOnTableErr, FieldCaption2, TableCaption1, FieldCaption1, TableCaption2));
    end;

    [ConfirmHandler]
    procedure ConfirmHandlerYes(Qst: Text[1024]; var Reply: Boolean);
    begin
        Reply := true;
    end;
}