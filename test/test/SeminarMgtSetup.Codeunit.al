codeunit 123456775 "Seminar Mgt. Setup ASD"
{
    // [FEATURE] [Seminar Management][Configuration]

    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure InsertRecordOnOpenPageSeminarSetup()
    var
        SeminarSetup: TestPage "Seminar Setup ASD";
    begin
        // [SCENARIO 0001] Open Seminar Setup page to rigger OnOpenPage
        Initialize();
        RemoveSeminarSetupRecord();
        // [GIVEN] No record exists in Seminar Setup table
        CheckNoSeminarSetupRecordExists();

        // [WHEN] Openi Seminar Setup Page
        SeminarSetup.OpenView();
        SeminarSetup.Close();

        // [THEN] Record exists in Seminar Setup table
        CheckSeminarSetupRecordExists();

        // Teardown
        Clear(isInitialized);
        Clear(SeminarMgtLibraryInitialize);
    end;

    [Test]
    procedure CreateSeminarUsingNoSeries()
    begin
        // [SCENARIO 0002] Create seminar record using no. series
        // [GIVEN] No. Series for seminar
        Initialize();

        // [WHEN] Creating seminar
        CreateSeminar(false);

        // [THEN] Record exists in Seminar table with No. equals to last Last No. Used on No. Series
        VerifySeminarExistWithNoBasedOnNoSeries();
    end;

    [Test]
    procedure DeleteSeminarWithCommentLines()
    var
        SeminarNo: Code[20];
    begin
        // [SCENARIO 0008] Delete seminar with comments lines
        Initialize();
        // [GIVEN] Seminar with comment lines
        SeminarNo := CreateSeminar(true);
        VerifyCommentLinesExistForSeminar(SeminarNo);

        // [WHEN] Delete the seminar
        DeleteSeminar(SeminarNo);

        // [THEN] Verify linked comment lines have been deleted
        VerifyCommentLinesDoNotExistForSeminar(SeminarNo);
    end;

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        isInitialized: Boolean;
        FieldOnTableErr: Label '%1 field on %2 table.';

    local procedure Initialize()
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Seminar Mgt. Setup ASD");

        if isInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Seminar Mgt. Setup ASD");

        SeminarMgtLibraryInitialize.Initialize();

        isInitialized := true;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Seminar Mgt. Setup ASD");
    end;

    local procedure CreateSeminar(DoCreateComments: Boolean): Code[20]
    begin
        exit(SeminarMgtLibrarySetup.CreateSeminarNo(DoCreateComments));
    end;

    local procedure DeleteSeminar(SeminarNo: Code[20])
    var
        Seminar: Record "Seminar ASD";
    begin
        Seminar.Get(SeminarNo);
        Seminar.Delete(true);
    end;

    local procedure RemoveSeminarSetupRecord()
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        SeminarSetup.DeleteAll();
    end;

    local procedure CheckNoSeminarSetupRecordExists()
    begin
        Assert.TableIsEmpty(Database::"Seminar Setup ASD")
    end;

    local procedure CheckSeminarSetupRecordExists()
    begin
        Assert.TableIsNotEmpty(Database::"Seminar Setup ASD")
    end;

    local procedure VerifySeminarExistWithNoBasedOnNoSeries()
    var
        Seminar: Record "Seminar ASD";
        SeminarSetup: Record "Seminar Setup ASD";
        LastNoUsed: Code[20];
    begin
        SeminarSetup.Get();
        LastNoUsed := SeminarMgtLibrarySetup.GetLastNoUsed(SeminarSetup."Seminar Nos.");

        Seminar.Get(LastNoUsed);
        Assert.AreEqual(SeminarSetup."Seminar Nos.", Seminar."No. Series",
            StrSubstNo(FieldOnTableErr, Seminar.FieldCaption("No. Series"), Seminar.TableCaption()));
    end;

    local procedure VerifyCommentLinesExistForSeminar(SeminarNo: Code[20])
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", SeminarNo);
        Assert.RecordIsNotEmpty(CommentLine)
    end;

    local procedure VerifyCommentLinesDoNotExistForSeminar(SeminarNo: Code[20])
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", SeminarNo);
        Assert.RecordIsEmpty(CommentLine)
    end;
}