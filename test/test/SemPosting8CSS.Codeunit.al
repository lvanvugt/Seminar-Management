codeunit 123456768 "Sem. Posting (8) CSS ASD"
{
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
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidStatusASD: Codeunit StubRegHdrInValidStatusASD;
    begin
        // [GIVEN] Seminar registration with invalid status

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidStatusASD);

        // [THEN] Status must be equal to closed error thrown
        VerifyMustBeEqualToErrorThrown('Status', 'Closed');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidPostingDate()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidPostingDate: Codeunit StubRegHdrInValidPostingDate;
    begin
        // [GIVEN] Seminar registration with invalid posting date

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidPostingDate);

        // [THEN] Posting date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Posting Date');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDocumentDate()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidDocumentDate: Codeunit StubRegHdrInValidDocumentDate;
    begin
        // [GIVEN] Seminar registration with invalid document date

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidDocumentDate);

        // [THEN] Document date must be have value error thrown
        VerifyMustHaveValueErrorThrown('Document Date');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidSeminarNo()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidSeminarNoASD: Codeunit StubRegHdrInValidSeminarNoASD;
    begin
        // [GIVEN] Seminar registration with invalid seminar number

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidSeminarNoASD);

        // [THEN] Seminar number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Seminar No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDuration()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidDurationASD: Codeunit StubRegHdrInValidDurationASD;
    begin
        // [GIVEN] Seminar registration with invalid duration

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidDurationASD);

        // [THEN] Duration must be have value error thrown
        VerifyMustHaveValueErrorThrown('Duration');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidInstructorResourscNo()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidInstResNo: Codeunit StubRegHdrInValidInstResNo;
    begin
        // [GIVEN] Seminar registration with invalid instructor resource number

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidInstResNo);

        // [THEN] Instructor resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Instructor Resource No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidRoomResouceNo()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegHdrInValidRoomResNo: Codeunit StubRegHdrInValidRoomResNo;
    begin
        // [GIVEN] Seminar registration with invalid room resource number

        // [WHEN] Check valid seminar registration
        asserterror RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegHdrInValidRoomResNo);

        // [THEN] Room resource number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Room Resource No.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsValid()
    var
        RegistrationHeaderValidator: Codeunit RegistrationHeaderValidator;
        StubRegistrationHeaderValidASD: Codeunit StubRegistrationHeaderValidASD;
    begin
        // [GIVEN] Valid seminar registration

        // [WHEN] Check valid seminar registration
        RegistrationHeaderValidator.CheckMandatoryHeaderFields(StubRegistrationHeaderValidASD);

        // [THEN] No error  thrown
    end;
    #endregion CheckMandatoryHeaderFields

    #region CheckSeminarLinesExist

    [Test]
    procedure CheckLinesExistInvalid()
    var
        RegistrationLineExistance: Codeunit RegistrationLineExistance;
    begin
        // [GIVEN] Seminar registration with no lines

        // [WHEN] Check registration lines exist
        asserterror RegistrationLineExistance.HandleLinesExist(true);

        // [THEN] Nothing to post error thrown
        VerifyNothingToPostErrorThrown();
    end;

    [Test]
    procedure CheckLinesExistValid()
    var
        RegistrationLineExistance: Codeunit RegistrationLineExistance;
    begin
        // [GIVEN] Seminar registration with lines

        // [WHEN] Check registration lines exist
        RegistrationLineExistance.HandleLinesExist(false);

        // [THEN] No error thrown
    end;
    #endregion CheckSeminarLinesExist

    #region CheckMandatoryLineFields

    [Test]
    procedure CheckMandatoryLineFieldsBillToCustInv()
    var
        RegistrationLineValidator: Codeunit RegistrationLineValidator;
        StubRegLineInValidBillToCust: Codeunit StubRegLineInValidBillToCust;
    begin
        // [GIVEN] Seminar registration line with invalid Bill-to Customer No.

        // [WHEN] Testing VerifySeminarRegLineForPosting
        asserterror RegistrationLineValidator.VerifyRegLineForPosting(StubRegLineInValidBillToCust);

        // [THEN] Bill-to customer number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Bill-to Customer No.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsParticipantInvalid()
    var
        RegistrationLineValidator: Codeunit RegistrationLineValidator;
        StubRegLineInValidPartCont: Codeunit StubRegLineInValidPartCont;
    begin
        // [GIVEN] Seminar registration line with invalid participant

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        asserterror RegistrationLineValidator.VerifyRegLineForPosting(StubRegLineInValidPartCont);

        // [THEN] Participant contact  number must be have value error thrown
        VerifyMustHaveValueErrorThrown('Participant Contact No.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsValid()
    var
        RegistrationLineValidator: Codeunit RegistrationLineValidator;
        StubRegLineValid: Codeunit StubRegLineValid;
    begin
        // [GIVEN] Seminar registration line valid

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        RegistrationLineValidator.VerifyRegLineForPosting(StubRegLineValid);

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

    local procedure VerifyNothingToPostErrorThrown()
    var
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        Assert.ExpectedError(NothingToPostErr);
    end;
    #endregion THEN helper methods
}