codeunit 123456764 "Sem. Posting (5) OC ASD"
{
    // [FEATURE][Seminar Management][Posting]

    // Optimized implementation of scenarios as defined in ATDD sheet for Seminar Posting to minimize data setup

    Subtype = Test;
    TestPermissions = Disabled;

    #region Test Methods
    [Test]
    [HandlerFunctions('ConfirmHandlerYes')]
    procedure PostClosedSeminarRegistrationFromSeminarRegistrationList()
    var
        PostingNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0070] Post closed seminar registration from Seminar Registration List page
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with company contact
        // [GIVEN] Person contact for customer
        Initialize();
        // [GIVEN] Closed seminar registration with one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        PostingNo := SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Press post button on Seminar Registration List
        // ConfirmHandlerYes will handle user input
        PressPostOnSeminarRegistrationList(SeminarRegistrationNo);

        // [THEN] Seminar registration is removed
        VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo);
        // [THEN] Posted seminar registration exists
        VerifyPostedSeminarRegistrationExists(PostingNo);
        // [THEN] Customer related seminar ledger entry exists
        VerifyCustomerRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, CustomerNo, ParticipantNo);
        // [THEN] Instructor related seminar ledger entry exists
        VerifyInstructorRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, InstructorResourceNo);
        // [THEN] Room related seminar ledger entry exists
        VerifyRoomRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, RoomResourceNo);
        // [THEN] Instructor related resource ledger entry exists
        VerifyInstructorRelatedResourceLedgerEntryExists(PostingNo, SeminarNo, InstructorResourceNo);
        // [THEN] Room related resource ledger entry exists
        VerifyRoomRelatedResourceLedgerEntryExist(PostingNo, SeminarNo, RoomResourceNo);
    end;

    [Test]
    procedure PostClosedSeminarRegistration()
    var
        PostingNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0400] Post closed seminar registration
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with company contact
        // [GIVEN] Person contact for customer
        Initialize();
        // [GIVEN] Closed seminar registration with one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        PostingNo := SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Post seminar registration
        PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Seminar registration is removed
        VerifySeminarRegistrationIsRemoved(SeminarRegistrationNo);
        // [THEN] Posted seminar registration exists
        VerifyPostedSeminarRegistrationExists(PostingNo);
        // [THEN] Customer related seminar ledger entry exists
        VerifyCustomerRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, CustomerNo, ParticipantNo);
        // [THEN] Instructor related seminar ledger entry exists
        VerifyInstructorRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, InstructorResourceNo);
        // [THEN] Room related seminar ledger entry exists
        VerifyRoomRelatedSeminarLedgerEntryExists(PostingNo, SeminarNo, RoomResourceNo);
        // [THEN] Instructor related resource ledger entry exists
        VerifyInstructorRelatedResourceLedgerEntryExists(PostingNo, SeminarNo, InstructorResourceNo);
        // [THEN] Room related resource ledger entry exists
        VerifyRoomRelatedResourceLedgerEntryExist(PostingNo, SeminarNo, RoomResourceNo);
    end;

    [Test]
    procedure PostNonClosedSeminarRegistration()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0401] Post non-closed seminar registration
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Non-closed seminar registration with one participant line
        // [WHEN] Post seminar registration
        // [THEN] Status must be equal to closed error thrown

        // [SCENARIO 0401-optimized] Post non-closed seminar registration
        // [GIVEN] Non-closed seminar registration header
        // defined by SeminarRegistrationHeader variable

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Status must be equal to closed error thrown
        VerifyMustBeEqualToErrorThrown('Status', 'Closed');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyPostingDate()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0402] Post closed seminar registration with empty posting date
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty posting date
        // [WHEN] Post seminar registration
        // [THEN] Posting date must be have value error thrown

        // [SCENARIO 0402-optimized] Post closed seminar registration with empty posting date
        // [GIVEN] Closed seminar registration header with empty posting date
        ClosedSeminarRegistrationHeaderWithEmptyPostingDate(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Posting date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Posting Date');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyDocumentDate()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0403] Post closed seminar registration with empty document date
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty document date
        // [WHEN] Post seminar registration
        // [THEN] Document date must be have value error thrown

        // [SCENARIO 0403-optimized] Post closed seminar registration with empty document date
        // [GIVEN] Closed seminar registration header with empty document date
        ClosedSeminarRegistrationHeaderWithEmptyDocumentDate(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Document date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Document Date');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptySeminarNumber()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0404] Post closed seminar registration with empty seminar number
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty seminar number
        // [WHEN] Post seminar registration
        // [THEN] Seminar number must be have value error thrown

        // [SCENARIO 0404-optimized] Post closed seminar registration with empty seminar number
        // [GIVEN] Closed seminar registration header with empty seminar number
        ClosedSeminarRegistrationHeaderWithEmptySeminarNo(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Seminar number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Seminar No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyDuration()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0405] Post closed seminar registration with empty duration
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty duration
        // [WHEN] Post seminar registration
        // [THEN] Duration must be have value error thrown

        // [SCENARIO 0405-optimized] Post closed seminar registration with empty duration
        // [GIVEN] Closed seminar registration header with empty duration
        ClosedSeminarRegistrationHeaderWithEmptyDuration(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Duration must be have value error thrown
        VerifyMustHaveValueErrorThrown('Duration');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyInstructorResourceNumber()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0406] Post closed seminar registration with empty instructor resource number
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty instructor resource number
        // [WHEN] Post seminar registration
        // [THEN] Instructor resource number must be have value error thrown

        // [SCENARIO 0406-optimized] Post closed seminar registration with empty instructor resource number
        // [GIVEN] Closed seminar registration header with empty instructor resource number
        ClosedSeminarRegistrationHeaderWithEmptyInstructorResourceNo(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Instructor Resource No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyRoomResourceNumber()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        // [SCENARIO #0407] Post closed seminar registration with empty room resource number
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Customer with contact
        // [GIVEN] Closed seminar registration with one participant line and empty room resource number
        // [WHEN] Post seminar registration
        // [THEN] Room resource number must be have value error thrown

        // [SCENARIO 0407-optimized] Post closed seminar registration with empty room resource number
        // [GIVEN] Closed seminar registration header with empty room resource number
        ClosedSeminarRegistrationHeaderWithEmptyRoomResourceNo(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Room Resource No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithNoParticipantLine()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    // SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO #0408] Post closed seminar registration with no participant line
        // [GIVEN] Seminar
        // [GIVEN] Instructor resource
        // [GIVEN] Room resource
        // [GIVEN] Closed seminar registration with no participant line
        // [WHEN] Post seminar registration
        // [THEN] Nothing to post error thrown

        // [SCENARIO #0408-optimized] Post closed seminar registration with no participant line
        // [GIVEN] Closed seminar registration header
        ClosedSeminarRegistrationHeader(SeminarRegistrationHeader);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationHeader);

        // [THEN] Nothing to post error thrown
        VerifyNothingToPostErrorThrown();
    end;
    #endregion Test Methods

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarMgtLibraryOperations: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        isInitialized: Boolean;
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];

    local procedure Initialize()
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Sem. Posting (5) OC ASD");

        if isInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Sem. Posting (5) OC ASD");

        SeminarMgtLibraryInitialize.Initialize();
        // [GIVEN] Seminar
        SeminarNo := CreateSeminar();
        // [GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        // [GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        // [GIVEN] Customer with company contact
        CustomerNo := CreateCustomerWithCompanyContact();
        // [GIVEN] Person contact for customer
        ParticipantNo := CreatePersonContactForCustomer(CustomerNo);

        Commit();
        isInitialized := true;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Sem. Posting (5) OC ASD");
    end;

    #region GIVEN helper methods
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

    local procedure CreateCustomerWithCompanyContact(): Code[20]
    var
        Contact: Record Contact;
        Customer: Record Customer;
        LibraryMarketing: Codeunit "Library - Marketing";
    begin
        LibraryMarketing.CreateContactWithCustomer(Contact, Customer);
        exit(Customer."No.");
    end;

    local procedure CreatePersonContactForCustomer(CustomerNo: Code[20]): Code[20]
    var
        Customer: Record Customer;
        ContactNo: Code[20];
    begin
        Customer.Get(CustomerNo);
        ContactNo := GetContactNoFromCustomerNo(CustomerNo);
        exit(SeminarMgtLibraryOperations.CreatePersonContactWithCompany(ContactNo));
    end;

    local procedure GetContactNoFromCustomerNo(CustomerNo: Code[20]): Code[20]
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SetRange("No.", CustomerNo);
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.FindFirst();
        exit(ContactBusinessRelation."Contact No.")
    end;

    local procedure CreateCompleteSeminarRegistrationWithOneLine(SeminarNo: Code[20]; InstructorNo: Code[20]; RoomNo: Code[20]; CustomerNo: Code[20]; ParticipantNo: Code[20]): Code[20]
    var
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
        SeminarRegistrationHeaderNo: Code[20];
    begin
        SeminarRegistrationHeaderNo := CreateCompleteSeminarRegistrationHeader(SeminarNo, InstructorNo, RoomNo);

        SeminarMgtLibraryOperations.CreateSeminarRegistrationLine(SeminarRegistrationLine, SeminarRegistrationHeaderNo, CustomerNo, ParticipantNo);
        exit(SeminarRegistrationHeaderNo);
    end;

    local procedure CreateCompleteSeminarRegistrationHeader(SeminarNo: Code[20]; InstructorNo: Code[20]; RoomNo: Code[20]): Code[20]
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarMgtLibraryOperations.CreateSeminarRegistration(SeminarRegistrationHeader);

        SeminarRegistrationHeader.Validate("Seminar No.", SeminarNo);
        SeminarRegistrationHeader."Instructor Resource No." := InstructorNo;
        SeminarRegistrationHeader."Room Resource No." := RoomNo;
        SeminarRegistrationHeader.Modify();

        exit(SeminarRegistrationHeader."No.");
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptyPostingDate(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, 0D, 0D, '', 0, '', '');
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptyDocumentDate(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), 0D, '', 0, '', '');
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptySeminarNo(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), WorkDate(), '', 0, '', '');
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptyDuration(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), WorkDate(), 'LUC', 0, '', '');
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptyInstructorResourceNo(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), WorkDate(), 'LUC', 1, '', '');
    end;

    local procedure ClosedSeminarRegistrationHeaderWithEmptyRoomResourceNo(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), WorkDate(), 'LUC', 1, 'LUC', '');
    end;

    local procedure ClosedSeminarRegistrationHeader(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SetMandatoryFieldsOnSeminarRegistrationHeader(SeminarRegistrationHeader, "Seminar Document Status ASD"::Closed, WorkDate(), WorkDate(), 'LUC', 1, 'LUC', 'LUC');
    end;

    local procedure SetMandatoryFieldsOnSeminarRegistrationHeader(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD"; NewStatus: Enum "Seminar Document Status ASD"; NewPostingDate: Date; NewDocumentDate: Date; NewSeminarNo: Code[20]; NewDuration: Duration; NewInstructorResourceNo: Code[20]; NewRoomResourceNo: Code[20])
    begin
        SeminarRegistrationHeader.Status := NewStatus;
        SeminarRegistrationHeader."Posting Date" := NewPostingDate;
        SeminarRegistrationHeader."Document Date" := NewDocumentDate;
        SeminarRegistrationHeader."Seminar No." := NewSeminarNo;
        SeminarRegistrationHeader.Duration := NewDuration;
        SeminarRegistrationHeader."Instructor Resource No." := NewInstructorResourceNo;
        SeminarRegistrationHeader."Room Resource No." := NewRoomResourceNo;
    end;
    #endregion GIVEN helper methods

    #region WHEN helper methods
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

    local procedure PostSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPost: Codeunit "Seminar-Post ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarPost.Run(SeminarRegistrationHeader);
    end;

    local procedure PostSeminarRegistration(SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    var
        SeminarPost: Codeunit "Seminar-Post ASD";
    begin
        SeminarPost.Run(SeminarRegistrationHeader);
    end;

    local procedure SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo: Code[20]; NewStatus: Enum "Seminar Document Status ASD"): Code[20]
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Status := NewStatus;
        SeminarRegistrationHeader."Posting No." := LibraryUtility.GetNextNoFromNoSeries(SeminarRegistrationHeader."Posting No. Series", 0D);
        SeminarRegistrationHeader.Modify();
        exit(SeminarRegistrationHeader."Posting No.");
    end;
    #endregion WHEN helper methods

    #region THEN helper methods
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

    local procedure VerifyCustomerRelatedSeminarLedgerEntryExists(PostingNo: Code[20]; SeminarNo: Code[20]; CustomerNo: Code[20]; ParticipantNo: Code[20])
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Document No.", PostingNo);
        SeminarLedgerEntry.SetRange("Seminar No.", SeminarNo);
        SeminarLedgerEntry.SetRange("Bill-to Customer No.", CustomerNo);
        SeminarLedgerEntry.SetRange("Participant Contact No.", ParticipantNo);
        Assert.RecordCount(SeminarLedgerEntry, 1);
    end;

    local procedure VerifyInstructorRelatedSeminarLedgerEntryExists(PostingNo: Code[20]; SeminarNo: Code[20]; InstructorResourceNo: Code[20])
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Document No.", PostingNo);
        SeminarLedgerEntry.SetRange("Seminar No.", SeminarNo);
        SeminarLedgerEntry.SetRange("Instructor Resource No.", InstructorResourceNo);
        Assert.RecordCount(SeminarLedgerEntry, 1);
    end;

    local procedure VerifyRoomRelatedSeminarLedgerEntryExists(PostingNo: Code[20]; SeminarNo: Code[20]; RoomResourceNo: Code[20])
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry ASD";
    begin
        SeminarLedgerEntry.SetRange("Document No.", PostingNo);
        SeminarLedgerEntry.SetRange("Seminar No.", SeminarNo);
        SeminarLedgerEntry.SetRange("Room Resource No.", RoomResourceNo);
        Assert.RecordCount(SeminarLedgerEntry, 1);
    end;

    local procedure VerifyInstructorRelatedResourceLedgerEntryExists(PostingNo: Code[20]; SeminarNo: Code[20]; InstructorResourceNo: Code[20])
    begin
        VerifyResourceRelatedResourceLedgerEntryExists(PostingNo, SeminarNo, InstructorResourceNo);
    end;

    local procedure VerifyRoomRelatedResourceLedgerEntryExist(PostingNo: Code[20]; SeminarNo: Code[20]; RoomResourceNo: Code[20])
    begin
        VerifyResourceRelatedResourceLedgerEntryExists(PostingNo, SeminarNo, RoomResourceNo);
    end;

    local procedure VerifyResourceRelatedResourceLedgerEntryExists(PostingNo: Code[20]; SeminarNo: Code[20]; ResourceNo: Code[20])
    var
        ResourceLedgerEntry: Record "Res. Ledger Entry";
    begin
        ResourceLedgerEntry.SetRange("Document No.", PostingNo);
        ResourceLedgerEntry.SetRange("Seminar No. ASD", SeminarNo);
        ResourceLedgerEntry.SetRange("Resource No.", ResourceNo);
        Assert.RecordCount(ResourceLedgerEntry, 1);
    end;

    local procedure VerifyMustBeEqualToErrorThrown(FieldCaption: Text; FieldValue: Text)
    var
        MustBeEqualToErr: Label 'must be equal to';
    begin
        Assert.ExpectedError(FieldCaption);
        Assert.ExpectedError(MustBeEqualToErr);
        Assert.ExpectedError(FieldValue);
    end;

    local procedure VerifyMustHaveValueErrorThrown(FieldCaption: Text)
    var
        MustHaveValueErr: Label 'must have a value';
    begin
        Assert.ExpectedError(FieldCaption);
        Assert.ExpectedError(MustHaveValueErr);
    end;

    local procedure VerifyNothingToPostErrorThrown()
    var
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        Assert.ExpectedError(NothingToPostErr);
    end;
    #endregion THEN helper methods

    #region UI Handlers
    [ConfirmHandler]
    procedure ConfirmHandlerYes(Qst: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
        // Qst check needs to added
    end;
    #endregion UI Handlers
}