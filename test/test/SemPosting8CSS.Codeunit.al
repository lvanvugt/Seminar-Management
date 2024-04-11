codeunit 123456779 "Sem. Posting (8) CSS ASD"
{
    Subtype = Test;
    TestPermissions = Disabled;

    #region TestMethods

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
    procedure CheckMandatoryHeaderFieldsInvalidStatus();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidStatusASD: Codeunit StubRegHdrInValidStatusASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidStatusASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Status must be equal to ''Closed''');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidPostingDate();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidPostingDate: Codeunit StubRegHdrInValidPostingDate;
    begin
        // [GIVEN] Seminar registration invalid Posting Date

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidPostingDate);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Posting Date cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDocumentDate();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidDocumentDate: Codeunit StubRegHdrInValidDocumentDate;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidDocumentDate);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Document Date cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidSeminarNo();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidSeminarNoASD: Codeunit StubRegHdrInValidSeminarNoASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidSeminarNoASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Seminar No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDuration();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidDurationASD: Codeunit StubRegHdrInValidDurationASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidDurationASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Duration cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidInstructorResourscNo();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidInstResNo: Codeunit StubRegHdrInValidInstResNo;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidInstResNo);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Instructor Resource No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidRoomResouceNo();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegHdrInValidRoomResNo: Codeunit StubRegHdrInValidRoomResNo;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegHdrInValidRoomResNo);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Room Resource No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsValid();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegistrationHeaderValidASD: Codeunit StubRegistrationHeaderValidASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        RegistrationValidatorASD.CheckMandatoryHeaderFields(StubRegistrationHeaderValidASD);
        // [THEN] Related ledger entries exist
    end;
    #endregion CheckMandatoryHeaderFields

    #region VerifySeminarLinesExists

    [Test]
    procedure VerifySeminarLinesExistsInvalid();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
    begin
        // [GIVEN] Seminar registration with no lines
        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationValidatorASD.HandleLinesExists(true);
        // [THEN] Related ledger entries exist
        Assert.ExpectedError('There is nothing to post.');
    end;

    [Test]
    procedure VerifySeminarLinesExistsValid();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
    begin
        // [GIVEN] Seminar registration with lines
        // [WHEN] Testing valid Seminar Registration
        RegistrationValidatorASD.HandleLinesExists(false);
        // [THEN] Related ledger entries exist
    end;

    #endregion VerifySeminarLinesExists

    #region VerifySeminarRegLineForPosting

    [Test]
    procedure VerifySeminarRegLineForPostingBillToCustInv();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegLineInValidBillToCust: Codeunit StubRegLineInValidBillToCust;
    begin
        // [GIVEN] Seminar registration line invalid Bill-to Customer No.

        // [WHEN] Testing VerifySeminarRegLineForPosting
        asserterror RegistrationValidatorASD.VerifyRegLineForPosting(StubRegLineInValidBillToCust);
        // [THEN] Bill-to Customer No. error
        Assert.ExpectedError('Bill-to Customer No. cannot be zero or empty.');
    end;

    [Test]
    procedure VerifySeminarRegLineForPostingParticipantInvalid();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegLineInValidPartCont: Codeunit StubRegLineInValidPartCont;
    begin
        // [GIVEN] Seminar registration line invalid participant

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        asserterror RegistrationValidatorASD.VerifyRegLineForPosting(StubRegLineInValidPartCont);
        // [THEN] Participant Contact No. error
        Assert.ExpectedError('Participant Contact No. cannot be zero or empty.');
    end;

    [Test]
    procedure VerifySeminarRegLineForPostingValid();
    var
        RegistrationValidatorASD: Codeunit RegistrationValidatorASD;
        StubRegLineValid: Codeunit StubRegLineValid;
    begin
        // [GIVEN] Seminar registration line valid

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        RegistrationValidatorASD.VerifyRegLineForPosting(StubRegLineValid);
        // [THEN] Related ledger entries exist
    end;


    #endregion VerifySeminarRegLineForPosting
    #endregion TestMethods

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