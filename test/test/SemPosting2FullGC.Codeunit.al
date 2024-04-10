codeunit 123456761 "Sem. Posting (2) Full GC ASD"
{
    // [FEATURE][Seminar Management][Posting]

    // Full implementation of scenarios as defined in ATDD sheet for Seminar Posting including generic cleanup (GC) of existing data

    Subtype = Test;
    TestPermissions = Disabled;

    #region Test Methods
#if include_sunny_path
    [Test]
    [HandlerFunctions('ConfirmHandlerYes')]
    procedure PostClosedSeminarRegistrationFromSeminarRegistrationList()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        PostingNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0070] Post closed seminar registration from Seminar Registration List page
        Initialize();
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
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        PostingNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0400] Post closed seminar registration
        Initialize();
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
#endif
    [Test]
    procedure PostNonClosedSeminarRegistration()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0401] Post non-closed seminar registration
        Initialize();
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
        // [GIVEN] Non-closed seminar registration with one participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Planning);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Status must be equal to closed error thrown
        VerifyMustBeEqualToErrorThrown('Status', 'Closed');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyPostingDate()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0402] Post closed seminar registration with empty posting date
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty posting date
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptyPostingDateOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Posting date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Posting Date');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyDocumentDate()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0403] Post closed seminar registration with empty document date
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty document date
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptyDocumentDateOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Document date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Document Date');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptySeminarNumber()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0404] Post closed seminar registration with empty seminar number
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty seminar number
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptySeminarNumberOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Seminar number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Seminar No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyDuration()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0405] Post closed seminar registration with empty duration
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty duration
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptyDurationOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Duration must be have value error thrown
        VerifyMustHaveValueErrorThrown('Duration');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyInstructorResourceNumber()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0406] Post closed seminar registration with empty instructor resource number
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty instructor resource number
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptyInstructorResourceNumberOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Instructor Resource No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithEmptyRoomResourceNumber()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        ParticipantNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0407] Post closed seminar registration with empty room resource number
        Initialize();
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
        // [GIVEN] Closed seminar registration with one participant line and empty room resource number
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, ParticipantNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);
        EmptyRoomResourceNumberOnSeminarRegistration(SeminarRegistrationNo);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Room Resource No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithNoParticipantLine()
    var
        InstructorResourceNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0408] Post closed seminar registration with empty room resource number
        Initialize();
        // [GIVEN] Seminar
        SeminarNo := CreateSeminar();
        // [GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        // [GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        // [GIVEN] Closed seminar registration with no participant line
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationHeader(SeminarNo, InstructorResourceNo, RoomResourceNo);
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        // [WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Nothing to post error thrown
        VerifyNothingToPostErrorThrown();
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithParticipantLineWithEmptyBillToCustomerNumber()
    var
        InstructorResourceNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        //[SCENARIO #0409] Post closed seminar registration with participant line with empty bill-to customer number
        Initialize();
        //[GIVEN] Seminar
        SeminarNo := CreateSeminar();
        //[GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        //[GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        //[GIVEN] Closed seminar registration with one participant line with empty bill-to customer number
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, '', '');
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        //[WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Bill-to customer number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Bill-to Customer No.');
    end;

    [Test]
    procedure PostClosedSeminarRegistrationWithParticipantLineWithEmptyParticipantNumber()
    var
        CustomerNo: Code[20];
        InstructorResourceNo: Code[20];
        RoomResourceNo: Code[20];
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        //[SCENARIO #0410] Post closed seminar registration with participant line with empty bill-to customer number
        Initialize();
        //[GIVEN] Seminar
        SeminarNo := CreateSeminar();
        //[GIVEN] Instructor resource
        InstructorResourceNo := CreateInstructorResource();
        //[GIVEN] Room resource
        RoomResourceNo := CreateRoomResource();
        //[GIVEN] Customer with company contact
        CustomerNo := CreateCustomerWithCompanyContact();
        //[GIVEN] Closed seminar registration with one participant line with empty participant contact number
        SeminarRegistrationNo := CreateCompleteSeminarRegistrationWithOneLine(SeminarNo, InstructorResourceNo, RoomResourceNo, CustomerNo, '');
        SetStatusAndPostingNoOnSeminarRegistration(SeminarRegistrationNo, "Seminar Document Status ASD"::Closed);

        //[WHEN] Post seminar registration
        asserterror PostSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Participant number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Participant Contact No.');
    end;
    #endregion Test Methods

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarMgtLibraryOperations: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        isInitialized: Boolean;

    local procedure Initialize()
    var
        Contact: Record Contact;
        Customer: Record Customer;
        Resource: Record Resource;
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Sem. Posting (2) Full GC ASD");

        if isInitialized then
            exit;

        Contact.DeleteAll();
        Customer.DeleteAll();
        Resource.DeleteAll();

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Sem. Posting (2) Full GC ASD");

        SeminarMgtLibraryInitialize.Initialize();

        Commit();
        isInitialized := true;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Sem. Posting (2) Full GC ASD");
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

    local procedure EmptyPostingDateOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader."Posting Date" := 0D;
        SeminarRegistrationHeader.Modify();
    end;

    local procedure EmptyDocumentDateOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader."Document Date" := 0D;
        SeminarRegistrationHeader.Modify();
    end;

    local procedure EmptySeminarNumberOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader."Seminar No." := '';
        SeminarRegistrationHeader.Modify();
    end;

    local procedure EmptyDurationOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Duration := 0;
        SeminarRegistrationHeader.Modify();
    end;

    local procedure EmptyInstructorResourceNumberOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader."Instructor Resource No." := '';
        SeminarRegistrationHeader.Modify();
    end;

    local procedure EmptyRoomResourceNumberOnSeminarRegistration(SeminarRegistrationNo: Code[20])
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader."Room Resource No." := '';
        SeminarRegistrationHeader.Modify();
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