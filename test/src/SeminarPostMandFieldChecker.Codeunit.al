codeunit 123456779 "SeminarPostMandFieldCheckerASD"
{
    Subtype = Test;
    TestPermissions = Disabled;

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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
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
        Assert.ExpectedError('Posting Date must not be blank');
    end;

    [Test]
    procedure CheckMandatoryHeaderFields();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarPostASD: Codeunit "Seminar-Post ASD";
    begin
        // [GIVEN] Seminar registration invalid status
        SeminarRegistrationHeader := CreateSeminarRegistrationHeader(0);

        // [WHEN] Testing valid Seminar Registration
        seminarPostASD.CheckMandatoryHeaderFields(SeminarRegistrationHeader);

        // [THEN] Related ledger entries exist
        Assert.ExpectedError('Posting Date must not be blank');
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

    var
        Assert: Codeunit Assert;

}