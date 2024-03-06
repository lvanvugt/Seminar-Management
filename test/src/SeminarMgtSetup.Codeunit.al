codeunit 123456775 "Seminar Mgt. Setup ASD"
{
    // [FEATURE] [Seminar Management - Configuration]

    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        SeminarMgtLibraryInitialize: Codeunit "Seminar Mgt. Lib. Init. ASD";
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";
        isInitialized: Boolean;
        FieldOnTableErr: Label '%1 field on %2 table.';

    local procedure Initialize();
    begin
        if isInitialized then
            exit;

        SeminarMgtLibraryInitialize.Initialize();

        isInitialized := true;
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure InsertRecordOnOpenPageSeminarSetup();
    var
        SeminarSetup: TestPage "Seminar Setup ASD";
    begin
        // [SCENARIO 0001] OnOpenPage should create a record in Seminar Setup table
        Initialize();
        RemoveSeminarSetupRecord();
        // [GIVEN] No record exists in Seminar Setup table
        CheckNoSeminarSetupRecordExists();

        // [WHEN] Opening Seminar Setup Page
        SeminarSetup.OpenView();
        SeminarSetup.Close();

        // [THEN] A record should exist in Seminar Setup table
        CheckSeminarSetupRecordExists();

        // Teardown
        Clear(isInitialized);
        Clear(SeminarMgtLibraryInitialize);
    end;

    [Test]
    procedure CreateSeminarUsingNoSeries();
    begin
        // [SCENARIO 0002] Create a new seminar record using no. series
        // [GIVEN] No. Series have been setup for seminar
        Initialize();

        // [WHEN] Creating a new seminar
        CreateSeminar(false);

        // [THEN] A record exists in Seminar table with No. equals to last Last No. Used on No. Series
        VerifySeminarExistWithNoBasedOnNoSeries();
    end;

    [Test]
    procedure DeleteSeminarWithCommentLines();
    var
        SeminarNo: Code[20];
    begin
        // [SCENARIO 0008] When deleting a seminar with comments lines these lines should also be deleted
        Initialize();
        // [GIVEN] A seminar with comment lines
        SeminarNo := CreateSeminar(true);
        VerifyCommentLinesExistForSeminar(SeminarNo);

        // [WHEN] Deleting the seminar
        DeleteSeminar(SeminarNo);

        // [THEN] Verify that linked comment lines have been deleted
        VerifyCommentLinesDoNotExistForSeminar(SeminarNo);
    end;

    local procedure CreateSeminar(DoCreateComments: Boolean): Code[20];
    begin
        exit(SeminarMgtLibrarySetup.CreateSeminarNo(DoCreateComments));
    end;

    local procedure DeleteSeminar(SeminarNo: Code[20]);
    var
        Seminar: Record "Seminar ASD";
    begin
        Seminar.Get(SeminarNo);
        Seminar.Delete(true);
    end;

    local procedure RemoveSeminarSetupRecord();
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        SeminarSetup.DeleteAll();
    end;

    local procedure CheckNoSeminarSetupRecordExists();
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        Assert.TableIsEmpty(Database::"Seminar Setup ASD")
    end;

    local procedure CheckSeminarSetupRecordExists();
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        Assert.TableIsNotEmpty(Database::"Seminar Setup ASD")
    end;

    local procedure VerifySeminarExistWithNoBasedOnNoSeries();
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

    local procedure VerifyCommentLinesExistForSeminar(SeminarNo: Code[20]);
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", SeminarNo);
        Assert.RecordIsNotEmpty(CommentLine)
    end;

    local procedure VerifyCommentLinesDoNotExistForSeminar(SeminarNo: Code[20]);
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", SeminarNo);
        Assert.RecordIsEmpty(CommentLine)
    end;
}