codeunit 123456771 "Seminar Mgt. Lib. Setup ASD"
{
    var
        LibraryUtility: Codeunit "Library - Utility";
        LibraryRandom: Codeunit "Library - Random";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryERM: Codeunit "Library - ERM";

    procedure CreateSeminarSetup()
    var
        SeminarSetup: Record "Seminar Setup ASD";
    begin
        if not SeminarSetup.Get() then begin
            SeminarSetup.Init();
            SeminarSetup."Seminar Nos." := LibraryUtility.GetGlobalNoSeriesCode();
            SeminarSetup."Seminar Registration Nos." := LibraryUtility.GetGlobalNoSeriesCode();
            SeminarSetup."Posted Seminar Reg. Nos." := LibraryUtility.GetGlobalNoSeriesCode();
            SeminarSetup.Insert(true);
        end;
    end;

    procedure CreateSeminar(var Seminar: Record "Seminar ASD"; DoCreateComments: Boolean)
    var
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if not Seminar.Get() then begin
            Seminar.Insert(true);
            Seminar.Validate(Name, Seminar."No.");
            Seminar."Duration" := LibraryRandom.RandInt(5);
            Seminar."Minimum Participants" := LibraryRandom.RandInt(5);
            Seminar."Maximum Participants" := LibraryRandom.RandIntInRange(Seminar."Minimum Participants", 20);
            Seminar.Price := LibraryRandom.RandInt(100);

            CreateGeneralPostingSetup(GeneralPostingSetup);
            Seminar.Validate("Gen. Prod. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");

            CreateVATPostingSetup(VATPostingSetup);
            Seminar.Validate("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");

            Seminar.Modify(true);
        end;
        if DoCreateComments then
            CreateSeminarComments(Seminar."No.");
    end;

    procedure CreateSeminarNo(DoCreateComments: Boolean): Code[20]
    var
        Seminar: Record "Seminar ASD";
    begin
        CreateSeminar(Seminar, DoCreateComments);
        exit(Seminar."No.");
    end;

    procedure CreateSeminarComments(SeminarNo: Code[20])
    begin
        CreateComments(SeminarNo, "Comment Line Table Name"::Seminar);
    end;

    procedure CreateComments(SeminarNo: Code[20]; TableName: Enum "Comment Line Table Name")
    var
        i: Integer;
        N: Integer;
    begin
        N := LibraryRandom.RandInt(5);
        for i := 1 to N do
            CreateComment(SeminarNo, TableName);
    end;

    local procedure CreateComment(DocumentNo: Code[20]; TableName: Enum "Comment Line Table Name")
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", DocumentNo);

        if not CommentLine.FindLast() then begin
            CommentLine."Table Name" := TableName;
            CommentLine."No." := DocumentNo;
        end;

        CommentLine.Init();
        CommentLine."Line No." := CommentLine."Line No." + 10000;
        CommentLine."Date" := WorkDate();
        CommentLine.Comment := CopyStr(StrSubstNo('%1 %2 - %3', 'Comment', CommentLine."Line No.", CurrentDateTime()), 1, MaxStrLen(CommentLine.Comment));
        CommentLine.Insert();
    end;

    procedure CreateRoomResource(var Resource: Record Resource)
    begin
        CreateResource(Resource, Enum::"Resource Type"::Room)
    end;

    procedure CreateInstructorResource(var Resource: Record Resource)
    begin
        CreateResource(Resource, Enum::"Resource Type"::Person)
    end;

    local procedure CreateResource(var Resource: Record Resource; NewType: Enum "Resource Type")
    begin
        if not Resource.Get() then begin
            Resource.Insert(true);
            Resource.Validate(Name, Resource."No.");
            Resource."Type" := NewType;
            Resource."Quantity per Day ASD" := LibraryRandom.RandInt(100);
            Resource."Base Unit of Measure" := CreateResourceUOM(Resource."No.");
            Resource.Modify(true);
        end
    end;

    local procedure CreateResourceUOM(ResourceNo: Code[20]): Code[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        LibraryResource: Codeunit "Library - Resource";
    begin
        LibraryInventory.CreateUnitOfMeasureCode(UnitOfMeasure);
        LibraryResource.CreateResourceUnitOfMeasure(ResourceUnitOfMeasure, ResourceNo, UnitOfMeasure.Code, 1);
        exit(ResourceUnitOfMeasure.Code);
    end;

    procedure GetLastNoUsed(NoSeriesCode: Code[20]): Code[20]
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        FindOpenNoSeriesLine(NoSeriesLine, NoSeriesCode);
        exit(NoSeriesLine."Last No. Used");
    end;

    local procedure FindOpenNoSeriesLine(var NoSeriesLine: Record "No. Series Line"; NoSeriesCode: Code[20]);
    begin
        NoSeriesLine.Reset();
        NoSeriesLine.SetCurrentKey("Series Code", "Starting Date");
        NoSeriesLine.SetRange("Series Code", NoSeriesCode);
        NoSeriesLine.SetRange("Starting Date", 0D, WorkDate());
        if NoSeriesLine.FindLast() then begin
            NoSeriesLine.SetRange("Starting Date", NoSeriesLine."Starting Date");
            NoSeriesLine.SetRange(Open, true);
        end;
        NoSeriesLine.FindFirst();
    end;

    local procedure CreateGeneralPostingSetup(var GeneralPostingSetup: Record "General Posting Setup");
    var
        GenBusinessPostingGroup: Record "Gen. Business Posting Group";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        LibraryERM.CreateGenProdPostingGroup(GenProductPostingGroup);
        LibraryERM.CreateGeneralPostingSetup(GeneralPostingSetup, GenBusinessPostingGroup.Code, GenProductPostingGroup.Code);
        GeneralPostingSetup.Modify(true);
    end;

    local procedure CreateVATPostingSetup(var VATPostingSetup: Record "VAT Posting Setup");
    var
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        LibraryERM.CreateVATProductPostingGroup(VATProductPostingGroup);
        LibraryERM.FindVATBusinessPostingGroup(VATBusinessPostingGroup);

        LibraryERM.CreateVATPostingSetup(VATPostingSetup, VATBusinessPostingGroup.Code, VATProductPostingGroup.Code);
        VATPostingSetup.Validate("VAT Identifier", VATPostingSetup."VAT Prod. Posting Group");
        VATPostingSetup.Validate("VAT %", LibraryRandom.RandDec(10, 2));
        VATPostingSetup.Validate("VAT Calculation Type", VATPostingSetup."VAT Calculation Type"::"Normal VAT");
        VATPostingSetup.Modify(true);
    end;
}