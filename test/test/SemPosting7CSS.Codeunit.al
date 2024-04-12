codeunit 123456766 "Sem. Posting (7) CSS ASD"
{
    // [FEATURE][Seminar Management][Posting]

    // Implementation of scenarios as defined in ATDD sheet for componentized Seminar Posting

    Subtype = Test;
    TestPermissions = Disabled;

    #region Test Methods

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

    #region CheckMandatoryHeaderFields
    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidStatus()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo(Status));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Status must be equal to closed error thrown
        VerifyMustBeEqualToErrorThrown('Status', 'Closed');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidPostingDate()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid posting date
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Posting Date"));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Posting date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Posting Date');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDocumentDate()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid document date
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Document Date"));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Document date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Document Date');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidSeminarNo()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid seminar number
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Seminar No."));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Seminar number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Seminar No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDuration()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid duration
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo(Duration));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Duration must be have value error thrown
        VerifyMustHaveValueErrorThrown('Duration');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidInstructorResourscNo()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid instructor resource number
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Instructor Resource No."));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Instructor Resource No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidRoomResouceNo()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration with invalid room resource number
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Room Resource No."));

        // [WHEN] Check valid seminar registration
        asserterror SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Room resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Room Resource No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsValid()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Valid seminar registration
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(0);

        // [WHEN] Check valid seminar registration
        SeminarValidator.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] No error  thrown
    end;

    local procedure CreateSeminarRegistrationHeader(FieldNo: Integer) SeminarRegistrationHeader: Record "Sem. Registration Header ASD"
    begin
        if FieldNo <> SeminarRegistrationHeader.FieldNo(Status) then
            SeminarRegistrationHeader.Status := SeminarRegistrationHeader.Status::Closed;
        if FieldNo <> SeminarRegistrationHeader.FieldNo("Posting Date") then
            SeminarRegistrationHeader."Posting Date" := Today();
        if FieldNo <> SeminarRegistrationHeader.FieldNo("Document Date") then
            SeminarRegistrationHeader."Document Date" := Today();
        if FieldNo <> SeminarRegistrationHeader.FieldNo("Seminar No.") then
            SeminarRegistrationHeader."Seminar No." := 'SomeValue';
        if FieldNo <> SeminarRegistrationHeader.FieldNo(Duration) then
            SeminarRegistrationHeader.Duration := 10;
        if FieldNo <> SeminarRegistrationHeader.FieldNo("Instructor Resource No.") then
            SeminarRegistrationHeader."Instructor Resource No." := 'SomeValue';
        if FieldNo <> SeminarRegistrationHeader.FieldNo("Room Resource No.") then
            SeminarRegistrationHeader."Room Resource No." := 'SomeValue';
    end;
    #endregion CheckMandatoryHeaderFields

    #region CheckSeminarLinesExist

    [Test]
    procedure CheckLinesExistInvalid()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarValidator: Codeunit SeminarValidator;
        SeminarMgtLibOprtnsASD: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        SeminarMgtLibSetupASD: Codeunit "Seminar Mgt. Lib. Setup ASD";
    begin
        // [GIVEN] Seminar registration with no lines
        SeminarMgtLibSetupASD.CreateSeminarSetup();
        SeminarMgtLibOprtnsASD.CreateSeminarRegistration(SeminarRegistrationHeader);

        // [WHEN] Check registration lines exist
        asserterror SeminarValidator.CheckLinesExist(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('There is nothing to post.');
    end;

    [Test]
    procedure CheckLinesExistValid()
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarMgtLibSetupASD: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarValidator: Codeunit SeminarValidator;
        SeminarMgtLibOprtnsASD: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
    begin
        // [GIVEN] Seminar registration with lines
        SeminarMgtLibSetupASD.CreateSeminarSetup();
        SeminarMgtLibOprtnsASD.CreateSeminarRegistration(SeminarRegistrationHeader);
        SeminarRegistrationLineASD.Init();
        SeminarRegistrationLineASD."Line No." := 10000;
        SeminarRegistrationLineASD."Document No." := SeminarRegistrationHeader."No.";
        SeminarRegistrationLineASD.Insert(false);

        // [WHEN] Check registration lines exist
        SeminarValidator.CheckLinesExist(SeminarRegistrationHeader);

        // [THEN] No error thrown
    end;
    #endregion CheckSeminarLinesExist

    #region CheckMandatoryLineFields

    [Test]
    procedure CheckMandatoryLineFieldsBillToCustInv()
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration line with invalid Bill-to Customer No.
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(SeminarRegistrationLineASD.FieldNo("Bill-to Customer No."));

        // [WHEN] Testing CheckMandatoryLineFields
        asserterror SeminarValidator.CheckMandatoryLineFields(SeminarRegistrationLineASD);

        // [THEN] Bill-to customer number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Bill-to Customer No.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsParticipantInvalid()
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration line with invalid participant
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(SeminarRegistrationLineASD.FieldNo("Participant Contact No."));

        // [WHEN] Testing valid CheckMandatoryLineFields
        asserterror SeminarValidator.CheckMandatoryLineFields(SeminarRegistrationLineASD);

        // [THEN] Participant contact  number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Participant Contact No.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsValid()
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarValidator: Codeunit SeminarValidator;
    begin
        // [GIVEN] Seminar registration line valid
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(0);

        // [WHEN] Testing valid CheckMandatoryLineFields
        SeminarValidator.CheckMandatoryLineFields(SeminarRegistrationLineASD);

        // [THEN] No error thrown
    end;
    #endregion CheckMandatoryLineFields
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

    local procedure CreateSeminarRegistrationLine(FieldNo: Integer) SeminarRegistrationLine: Record "Seminar Registration Line ASD"
    begin
        if FieldNo <> SeminarRegistrationLine.FieldNo("Bill-to Customer No.") then
            SeminarRegistrationLine."Bill-to Customer No." := 'TEST';
        if FieldNo <> SeminarRegistrationLine.FieldNo("Participant Contact No.") then
            SeminarRegistrationLine."Participant Contact No." := 'TEST';
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
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarPostASD.Run(SeminarRegistrationHeader);
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
    #endregion THEN helper methods
}