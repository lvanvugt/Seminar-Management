codeunit 123456766 "Sem. Posting (6b) CSS ASD"
{
    Subtype = Test;
    TestPermissions = Disabled;

#if componentized_structured_spaghetti
    #region CheckMandatoryHeaderFields
    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidStatus();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo(Status));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Status must be equal to ''Closed''');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidPostingDate();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Posting Date"));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Posting Date must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDocumentDate();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Document Date"));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Document Date must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidSeminarNo();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Seminar No."));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Seminar No. must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidDuration();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo(Duration));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Duration must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidInstructorResourscNo();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Instructor Resource No."));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Instructor Resource No. must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsInvalidRoomResouceNo();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(SeminarRegistrationHeader.FieldNo("Room Resource No."));

        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Room Resource No. must have a value in Seminar Registration Header: No.=. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryHeaderFieldsValid();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(0);

        // [WHEN] Testing valid Seminar Registration
        seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);
        // [THEN] Related ledger entries exist
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
    procedure CheckSeminarLinesExistInvalid();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
        SeminarMgtLibOprtnsASD: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        SeminarMgtLibSetupASD: Codeunit "Seminar Mgt. Lib. Setup ASD";
    begin
        // [GIVEN] Seminar registration with no lines
        SeminarMgtLibSetupASD.CreateSeminarSetup();
        SeminarMgtLibOprtnsASD.CreateSeminarRegistration(SeminarRegistrationHeader);
        // [WHEN] Testing valid Seminar Registration
        asserterror seminarPostASD.CheckSeminarLinesExist(SeminarRegistrationHeader);
        // [THEN] Related ledger entries exist
        Assert.ExpectedError('There is nothing to post.');
    end;

    [Test]
    procedure CheckSeminarLinesExistValid();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarMgtLibSetupASD: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
        SeminarMgtLibOprtnsASD: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
    begin
        // [GIVEN] Seminar registration with lines
        SeminarMgtLibSetupASD.CreateSeminarSetup();
        SeminarMgtLibOprtnsASD.CreateSeminarRegistration(SeminarRegistrationHeader);
        SeminarRegistrationLineASD.Init();
        SeminarRegistrationLineASD."Line No." := 10000;
        SeminarRegistrationLineASD."Document No." := SeminarRegistrationHeader."No.";
        SeminarRegistrationLineASD.Insert(false);
        // [WHEN] Testing valid Seminar Registration
        seminarPostASD.CheckSeminarLinesExist(SeminarRegistrationHeader);
        // [THEN] Related ledger entries exist
    end;

    #endregion CheckSeminarLinesExist

    #region CheckMandatoryLineFields

    [Test]
    procedure CheckMandatoryLineFieldsBillToCustInv();
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration line invalid Bill-to Customer No.
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(SeminarRegistrationLineASD.FieldNo("Bill-to Customer No."));

        // [WHEN] Testing CheckMandatoryLineFields
        asserterror seminarPostASD.CheckMandatoryLineFields(SeminarRegistrationLineASD);
        // [THEN] Bill-to Customer No. error
        Assert.ExpectedError('Bill-to Customer No. must have a value in Seminar Registration Line: Document No.=, Line No.=0. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsParticipantInvalid();
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration line invalid participant
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(SeminarRegistrationLineASD.FieldNo("Participant Contact No."));

        // [WHEN] Testing valid CheckMandatoryLineFields
        asserterror seminarPostASD.CheckMandatoryLineFields(SeminarRegistrationLineASD);
        // [THEN] Participant Contact No. error
        Assert.ExpectedError('Participant Contact No. must have a value in Seminar Registration Line: Document No.=, Line No.=0. It cannot be zero or empty.');
    end;

    [Test]
    procedure CheckMandatoryLineFieldsValid();
    var
        SeminarRegistrationLineASD: Record "Seminar Registration Line ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration line valid
        SeminarRegistrationLineASD := CreateSeminarRegistrationLine(0);

        // [WHEN] Testing valid CheckMandatoryLineFields
        seminarPostASD.CheckMandatoryLineFields(SeminarRegistrationLineASD);
        // [THEN] Related ledger entries exist
    end;

    local procedure CreateSeminarRegistrationLine(FieldNo: Integer) SeminarRegistrationLine: Record "Seminar Registration Line ASD"
    begin
        if FieldNo <> SeminarRegistrationLine.FieldNo("Bill-to Customer No.") then
            SeminarRegistrationLine."Bill-to Customer No." := 'TEST';
        if FieldNo <> SeminarRegistrationLine.FieldNo("Participant Contact No.") then
            SeminarRegistrationLine."Participant Contact No." := 'TEST';
    end;

    #endregion CheckMandatoryLineFields
    var
        Assert: Codeunit Assert;
#endif
}