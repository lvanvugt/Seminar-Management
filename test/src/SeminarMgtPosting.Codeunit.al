codeunit 123456777 "Seminar Mgt. Posting ASD"
{
    // [FEATURE] [Seminar Management - Posting]

    Subtype = Test;
    TestPermissions = Disabled;

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
        // [SCENARIO 0070] Post seminar registration from Seminar Registration List page
        Initialize();
        // [GIVEN] Seminar
        SeminarNo := CreateSeminar();
        // [GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        // [GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        // [GIVEN] Closed seminar registration with one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo);
        PostingNo := SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Press post button on Seminar Registration List
        // ConfirmHandlerYes will handle user input
        PressPostOnSeminarRegistrationList(SeminarRegistrationNo);

        // [THEN] Seminar registration is removed
        VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo);
        // [THEN] Posted seminar registration exists
        VerifyPostedSeminarRegistrationExists(PostingNo);
        // [THEN] Related ledger entries exist
        VerifySeminarLedgerEntriesExist(PostingNo);
    end;

    [Test]
    procedure PostSeminarRegistration();
    var
        InstructorResourceNo: Code[20];
        PostingNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0400] Post seminar registration
        Initialize();
        // [GIVEN] Seminar
        SeminarNo := CreateSeminar();
        // [GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        // [GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        // [GIVEN] Closed seminar registration with one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo);
        PostingNo := SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Post seminar registration
        PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Seminar registration is removed
        VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo);
        // [THEN] Posted seminar registration exists
        VerifyPostedSeminarRegistrationExists(PostingNo);
        // [THEN] Related ledger entries exist
        VerifySeminarLedgerEntriesExist(PostingNo);
    end;

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarMgtLibraryOperations: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        isInitialized: Boolean;

    local procedure Initialize()
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Seminar Mgt. Posting ASD");

        if isInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Seminar Mgt. Posting ASD");

        SeminarMgtLibraryInitialize.Initialize();

        Commit();
        isInitialized := true;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Seminar Mgt. Posting ASD");
    end;

    local procedure CreateSeminar(): Code[20]
    begin
        exit(SeminarMgtLibrarySetup.CreateSeminarNo(false));
    end;

    local procedure CreateInstructorResource(): Code[20]
    var
        InstructorResource: Record Resource;
    begin
        SeminarMgtLibrarySetup.CreateInstructorResource(InstructorResource);
        exit(InstructorResource."No.");
    end;

    local procedure CreateRoomResource(): Code[20]
    var
        RoomResource: Record Resource;
    begin
        SeminarMgtLibrarySetup.CreateRoomResource(RoomResource);
        exit(RoomResource."No.");
    end;

    local procedure CreateCompleteSeminarRegistrationWithOneLine(SeminarNo: Code[20]; InstructorNo: Code[20]; RoomNo: Code[20]): Code[20]
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

    local procedure PostSeminarRegistration(SeminarRegistrationNo: Code[20]) PostingNo: Code[20]
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPost: Codeunit "Seminar-Post ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarPost.Run(SeminarRegistrationHeader);
    end;

    local procedure SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo: Code[20]; NewStatus: Enum "Seminar Document Status ASD") PostingNo: Code[20]
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Validate(Status, NewStatus);
        SeminarRegistrationHeader.Validate("Posting No.", LibraryUtility.GetNextNoFromNoSeries(SeminarRegistrationHeader."Posting No. Series", 0D));
        SeminarRegistrationHeader.Modify();
        exit(SeminarRegistrationHeader."Posting No.");
    end;

    local procedure VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.SetRange("No.", SeminarRegistrationNo);
        Assert.RecordIsEmpty(SeminarRegistrationHeader);
    end;

    local procedure VerifyPostedSeminarRegistrationExists(PostingNo: Code[20])
    var
        PostedSeminarRegHeader: Record "Posted Sem. Reg. Header ASD";
    begin
        PostedSeminarRegHeader.SetRange("No.", PostingNo);
        Assert.RecordIsNotEmpty(PostedSeminarRegHeader);
    end;

    local procedure VerifySeminarLedgerEntriesExist(PostingNo: Code[20])
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Document No.", PostingNo);
        Assert.RecordIsNotEmpty(SeminarLedgerEntry);
    end;

    [ConfirmHandler]
    procedure ConfirmHandlerYes(Qst: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
        // Qst check needs to added
    end;
}