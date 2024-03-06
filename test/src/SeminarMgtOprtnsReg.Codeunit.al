codeunit 123456776 "Seminar Mgt. Oprtns. Reg. ASD"
{
    // [FEATURE] [Seminar Management - Operation]

    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure DeleteSeminarRegistrationNotCancelled();
    var
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0030] Delete seminar registration with status <> Canceled
        Initialize();
        // [GIVEN] Seminar registration status <> Canceled
        SeminarRegistrationNo := CreateSeminarRegistration();

        // [WHEN] Delete seminar
        asserterror DeleteSeminarRegistration(SeminarRegistrationNo);

        // [THEN] Verify right error has been shown
        VerifyStatusError(SeminarRegistrationNo, "Seminar Document Status ASD"::Canceled);
    end;

    [Test]
    procedure InheritFromSeminarToSeminarRegistrationWithoutLines();
    var
        SeminarNo: Code[20];
        SeminarRegistrationNo: Code[20];
    begin
        // [SCENARIO 0020] Select seminar on seminar registration header without lines
        Initialize();
        // [GIVEN] Seminar registration without lines
        SeminarRegistrationNo := CreateSeminarRegistration();
        // [GIVEN] Seminar
        SeminarNo := CreateSeminar();

        // [WHEN] Select seminar on seminar registration header
        SetSeminarNoOnSeminarRegistration(SeminarNo, SeminarRegistrationNo);

        // [THEN] "Seminar Name" on seminar registration copied from seminar
        // [THEN] Duration on seminar registration copied from seminar
        // [THEN] Price on seminar registration copied from seminar 
        // [THEN] "Gen. Prod. Posting Group" on seminar registration copied from seminar
        // [THEN] "VAT Prod. Posting Group" on seminar registration copied from seminar
        // [THEN] "Minimum Participants" on seminar registration copied from seminar
        // [THEN] "Maximum Participants" on seminar registration copied from seminar
        VerifyInheritanceFromSeminarToSeminarRegistration(SeminarNo, SeminarRegistrationNo);
    end;

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        SeminarMgtLibraryOperations: Codeunit "Seminar Mgt. Lib. Oprtns. ASD";
        isInitialized: Boolean;
        StatusMustBeEqualToErr: Label '%1 must be equal to ''%2''  in %3: %4=%5. Current value is ''%6''.';
        FieldOnTableEqualToFieldOnTableErr: Label '%1 on %2 must be equal to %3 on %4.';

    local procedure Initialize();
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Seminar Mgt. Oprtns. Reg. ASD");

        if isInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Seminar Mgt. Oprtns. Reg. ASD");

        SeminarMgtLibraryInitialize.Initialize();

        Commit();
        isInitialized := true;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Seminar Mgt. Oprtns. Reg. ASD");
    end;

    local procedure CreateSeminar(): Code[20];
    begin
        exit(SeminarMgtLibrarySetup.CreateSeminarNo(false));
    end;

    local procedure CreateSeminarRegistration(): Code[20];
    begin
        exit(SeminarMgtLibraryOperations.CreateSeminarRegistrationNo());
    end;

    local procedure DeleteSeminarRegistration(SeminarRegistrationNo: Code[20]);
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.Get(SeminarRegistrationNo);
        SeminarRegistrationHeader.Delete(true);
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
}