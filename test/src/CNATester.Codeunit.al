codeunit 123456779 "CNATesterASD"
{
    Subtype = Test;
    TestPermissions = Disabled;
    #region CheckMandatoryHeaderFields
    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidStatus();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidStatusASD: Codeunit StubRegHdrInValidStatusASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidStatusASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Status must be equal to ''Closed''');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidPostingDate();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidPostingDate: Codeunit StubRegHdrInValidPostingDate;
    begin
        // [GIVEN] Seminar registration invalid Posting Date

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidPostingDate);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Posting Date cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDocumentDate();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidDocumentDate: Codeunit StubRegHdrInValidDocumentDate;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidDocumentDate);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Document Date cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidSeminarNo();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidSeminarNoASD: Codeunit StubRegHdrInValidSeminarNoASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidSeminarNoASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Seminar No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDuration();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidDurationASD: Codeunit StubRegHdrInValidDurationASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidDurationASD);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Duration cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidInstructorResourscNo();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidInstResNo: Codeunit StubRegHdrInValidInstResNo;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidInstResNo);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Instructor Resource No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidRoomResouceNo();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegHdrInValidRoomResNo: Codeunit StubRegHdrInValidRoomResNo;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegHdrInValidRoomResNo);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Room Resource No. cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsValid();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegistrationHeaderValidASD: Codeunit StubRegistrationHeaderValidASD;
    begin
        // [GIVEN] Seminar registration invalid status

        // [WHEN] Testing valid Seminar Registration
        RegistrationTesterASD.CheckMandatoryHeaderFields(StubRegistrationHeaderValidASD);
        // [THEN] Related ledger entries exist
    end;
    #endregion CheckMandatoryHeaderFields

    #region VerifySeminarLinesExists

    [Test]
    procedure VerifySeminarLinesExistsInvalid();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
    begin
        // [GIVEN] Seminar registration with no lines
        // [WHEN] Testing valid Seminar Registration
        asserterror RegistrationTesterASD.HandleLinesExists(true);
        // [THEN] Related ledger entries exist
        Assert.ExpectedError('There is nothing to post.');
    end;

    [Test]
    procedure VerifySeminarLinesExistsValid();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
    begin
        // [GIVEN] Seminar registration with lines
        // [WHEN] Testing valid Seminar Registration
        RegistrationTesterASD.HandleLinesExists(false);
        // [THEN] Related ledger entries exist
    end;

    #endregion VerifySeminarLinesExists

    #region VerifySeminarRegLineForPosting

    [Test]
    procedure VerifySeminarRegLineForPostingBillToCustInv();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegLineInValidBillToCust: Codeunit StubRegLineInValidBillToCust;
    begin
        // [GIVEN] Seminar registration line invalid Bill-to Customer No.

        // [WHEN] Testing VerifySeminarRegLineForPosting
        asserterror RegistrationTesterASD.VerifyRegLineForPosting(StubRegLineInValidBillToCust);
        // [THEN] Bill-to Customer No. error
        Assert.ExpectedError('Bill-to Customer No. cannot be zero or empty.');
    end;

    [Test]
    procedure VerifySeminarRegLineForPostingParticipantInvalid();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegLineInValidPartCont: Codeunit StubRegLineInValidPartCont;
    begin
        // [GIVEN] Seminar registration line invalid participant

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        asserterror RegistrationTesterASD.VerifyRegLineForPosting(StubRegLineInValidPartCont);
        // [THEN] Participant Contact No. error
        Assert.ExpectedError('Participant Contact No. cannot be zero or empty.');
    end;

    [Test]
    procedure VerifySeminarRegLineForPostingValid();
    var
        RegistrationTesterASD: Codeunit RegistrationTesterASD;
        StubRegLineValid: Codeunit StubRegLineValid;
    begin
        // [GIVEN] Seminar registration line valid

        // [WHEN] Testing valid VerifySeminarRegLineForPosting
        RegistrationTesterASD.VerifyRegLineForPosting(StubRegLineValid);
        // [THEN] Related ledger entries exist
    end;


    #endregion VerifySeminarRegLineForPosting
    var
        Assert: Codeunit Assert;
}