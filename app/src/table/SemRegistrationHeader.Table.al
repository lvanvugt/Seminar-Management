table 123456710 "Sem. Registration Header ASD"
{
    // ASD5.02 - 2020-10-03 D.E. Veloper - Chapter 5: Lab 2 - New Documents Integration 
    // ASD6.01 - 2018-08-15 D.E. Veloper - Chapter 6: Lab 1 - Added No. Printed field 
    // ASD8.02 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 2 - Dimensions functionality

    Caption = 'Seminar Registration Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Rec."No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                    Rec."No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Rec."Starting Date" <> xRec."Starting Date" then
                    Rec.TestField(Status, Rec.Status::Planning)
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            TableRelation = "Seminar ASD";

            trigger OnValidate();
            begin
                if Rec."Seminar No." <> xRec."Seminar No." then begin
                    CheckRegisteredSemRegLines();
                    Seminar.Get(Rec."Seminar No.");
                    Seminar.TestField(Blocked, false);
                    Seminar.TestField("Gen. Prod. Posting Group");
                    Seminar.TestField("VAT Prod. Posting Group");
                    Rec."Seminar Name" := Seminar.Name;
                    Rec.Duration := Seminar.Duration;
                    Rec.Price := Seminar.Price;
                    Rec."Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                    Rec."VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                    Rec."Minimum Participants" := Seminar."Minimum Participants";
                    Rec."Maximum Participants" := Seminar."Maximum Participants";
                end;

                // ASD8.02<
                CreateDimFromDefaultDim(Rec.FieldNo("Seminar No."));
                // ASD8.02>
            end;
        }
        field(4; "Seminar Name"; Text[100])
        {
            Caption = 'Seminar Name';
            DataClassification = CustomerContent;
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate();
            begin
                Rec.CalcFields("Instructor Name");

                // ASD8.02<
                CreateDimFromDefaultDim(Rec.FieldNo("Instructor Resource No."));
                // ASD8.02>
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Instructor Resource No."), Type = const(Person)));
        }
        field(7; Status; Enum "Seminar Document Status ASD")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(8; "Duration"; Decimal)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = CustomerContent;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = CustomerContent;
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Room));

            trigger OnValidate();
            begin
                if Rec."Room Resource No." = '' then
                    InitRoomFields()
                else
                    SetRoomFields();

                // ASD8.02<
                CreateDimFromDefaultDim(Rec.FieldNo("Room Resource No."));
                // ASD8.02>
            end;
        }
        field(12; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
            DataClassification = CustomerContent;
        }
        field(13; "Room Address"; Text[100])
        {
            Caption = 'Room Address';
            DataClassification = CustomerContent;
        }
        field(14; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
            DataClassification = CustomerContent;
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(Rec."Room City", Rec."Room Post Code", Rec."Room County", Rec."Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(16; "Room City"; Text[30])
        {
            Caption = 'Room City';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                PostCode.ValidateCity(Rec."Room City", Rec."Room Post Code", Rec."Room County", Rec."Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(17; "Room County"; Text[30])
        {
            Caption = 'Room County';
            DataClassification = CustomerContent;
        }
        field(18; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Room Country/Region Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(19; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if (Rec.Price <> xRec.Price) and (Rec.Status <> Status::Canceled) then
                    UpdatePriceOnLines();
            end;
        }
        field(20; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
            AccessByPermission = tabledata "Gen. Product Posting Group" = R;
        }
        field(21; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
            AccessByPermission = tabledata "VAT Product Posting Group" = R;
        }
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Seminar Comment Line ASD" where("Document Type" = const("Seminar Registration"), "No." = field("No.")));
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(25; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(26; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                if Rec."Posting No. Series" <> '' then begin
                    SeminarSetup.Get();
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.", Rec."Posting No. Series");
                end;
                Rec.TestField("Posting No.", '');
            end;

            trigger OnLookup();
            begin
                SeminarRegistrationHeader := Rec;
                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", SeminarRegistrationHeader."Posting No. Series") then
                    SeminarRegistrationHeader.Validate("Posting No. Series");
                Rec := SeminarRegistrationHeader;
            end;
        }
        field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }
        // ASD8.02<
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, Rec."Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, Rec."Shortcut Dimension 2 Code");
            end;
        }
        // ASD8.02>
        // ASD6.01<
        field(40; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            DataClassification = CustomerContent;
            Editable = false;

        }
        // ASD6.01>
        // ASD8.02<
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim();
            end;
        }
        // ASD8.02>
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        PostCode: Record "Post Code";
        Seminar: Record "Seminar ASD";
        SeminarCommentLine: Record "Seminar Comment Line ASD";
        SeminarCharge: Record "Seminar Charge ASD";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
        SeminarRoom: Record Resource;
        SeminarSetup: Record "Seminar Setup ASD";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        // ASD8.02<
        DimensionManagement: Codeunit DimensionManagement;
        // ASD8.02>
        YouCannotDeleteOrChangeErr: Label 'You cannot delete or change %1 %2 because there is at least one%3 for which %4=%5.';
        YouCannotDeleteErr: Label 'You cannot delete %1 because there is at least one %2.';
        YouCannotRenameErr: Label 'You cannot rename a %1.';
        IsSmallerDoYouWantToUpDateQst: Label '"%1 of %2 %3 is smaller then %4 of %5 %6.\Do you want update %4 from %7 to %8? "';
        DoYouWantToUpDateUnregisteredQst: Label 'Do you want update the %1 of the unregistered %2?';
        // ASD8.02<
        DoYouWantToUpDateLinesQst: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        HideValidationDialog: Boolean;
    // ASD8.02>

    trigger OnInsert();
    begin
        if Rec."No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, Rec."No.", Rec."No. Series");
        end;
        InitRecord();

        // ASD5.02<
        if Rec.GetFilter("Seminar No.") <> '' then
            if Rec.GetRangeMin("Seminar No.") = Rec.GetRangeMax("Seminar No.") then
                Rec.Validate("Seminar No.", Rec.GetRangeMin("Seminar No."));
        // ASD5.02>
    end;

    trigger OnDelete();
    begin
        Rec.TestField(Status, Rec.Status::Canceled);

        CheckRegisteredSemRegLines();
        SeminarRegistrationLine.DeleteAll(true);

        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", Rec."No.");
        if not SeminarCharge.IsEmpty() then
            Error(YouCannotDeleteErr, Rec.TableCaption(), SeminarCharge.TableCaption());

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", Rec."No.");
        SeminarCommentLine.DeleteAll();
    end;

    trigger OnRename();
    begin
        Error(YouCannotRenameErr, Rec.TableCaption());
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "Sem. Registration Header ASD"): Boolean;
    begin
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", Rec."No. Series") then begin
            NoSeriesMgt.SetSeries(Rec."No.");
            exit(true);
        end;
    end;

    procedure InitRecord();
    begin
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
        Rec."Document Date" := WorkDate();
        SeminarSetup.Get();
        NoSeriesMgt.SetDefaultSeries(Rec."Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure CheckRegisteredSemRegLines();
    begin
        if FindFirstRegisteredSemRegLines() then
            Error(
                    YouCannotDeleteOrChangeErr,
                    Rec.TableCaption(),
                    Rec."No.",
                    SeminarRegistrationLine.TableCaption(),
                    SeminarRegistrationLine.FieldCaption(Registered),
                    true
                );
    end;

    procedure FindFirstRegisteredSemRegLines(): Boolean;
    begin
        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", Rec."No.");
        SeminarRegistrationLine.SetRange(Registered, true);
        exit(SeminarRegistrationLine.FindFirst())
    end;

    local procedure InitRoomFields();
    begin
        Rec."Room Name" := '';
        Rec."Room Address" := '';
        Rec."Room Address 2" := '';
        Rec."Room Post Code" := '';
        Rec."Room City" := '';
        Rec."Room County" := '';
        Rec."Room Country/Region Code" := '';
    end;

    local procedure SetRoomFields();
    begin
        SeminarRoom.Get("Room Resource No.");
        Rec."Room Name" := SeminarRoom.Name;
        Rec."Room Address" := SeminarRoom.Address;
        Rec."Room Address 2" := SeminarRoom."Address 2";
        Rec."Room Post Code" := SeminarRoom."Post Code";
        Rec."Room City" := SeminarRoom.City;
        Rec."Room County" := SeminarRoom.County;
        Rec."Room Country/Region Code" := SeminarRoom."Country/Region Code";

        if (CurrFieldNo <> 0) then
            if (SeminarRoom."Maximum Participants ASD" <> 0) and
              (SeminarRoom."Maximum Participants ASD" < Rec."Maximum Participants")
            then
                if Confirm(
                        IsSmallerDoYouWantToUpDateQst, false,
                        SeminarRoom.FieldCaption("Maximum Participants ASD"),
                        SeminarRoom.TableCaption(),
                        SeminarRoom."No.",
                        Rec.FieldCaption("Maximum Participants"),
                        Rec.TableCaption(),
                        Rec."No.",
                        Rec."Maximum Participants",
                        SeminarRoom."Maximum Participants ASD"
                    )
                then
                    Rec."Maximum Participants" := SeminarRoom."Maximum Participants ASD";
    end;

    local procedure UpdatePriceOnLines();
    var
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
    begin
        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", Rec."No.");
        SeminarRegistrationLine.SetRange(Registered, false);
        if SeminarRegistrationLine.FindSet() then
            if Confirm(
                        DoYouWantToUpDateUnregisteredQst,
                        false,
                        SeminarRegistrationLine.FieldCaption(Price),
                        SeminarRegistrationLine.TableCaption()
                       )
            then
                repeat
                    SeminarRegistrationLine.Validate(Price, Rec.Price);
                    SeminarRegistrationLine.Modify()
                until SeminarRegistrationLine.Next() = 0;
    end;

    // ASD8.02<
    procedure SeminarRegistrationLinesExist(): Boolean;
    begin
        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", Rec."No.");
        exit(SeminarRegistrationLine.FindFirst());
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean);
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure CreateDimFromDefaultDim(FieldNo: Integer)
    var
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        InitDefaultDimensionSources(DefaultDimSource, FieldNo);
        CreateDim(DefaultDimSource);
    end;

    local procedure InitDefaultDimensionSources(var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    begin
        DimensionManagement.AddDimSource(DefaultDimSource, Database::"Seminar ASD", Rec."Seminar No.", FieldNo = Rec.FieldNo("Seminar No."));
        DimensionManagement.AddDimSource(DefaultDimSource, Database::Resource, Rec."Instructor Resource No.", FieldNo = Rec.FieldNo("Instructor Resource No."));
        DimensionManagement.AddDimSource(DefaultDimSource, Database::Resource, Rec."Room Resource No.", FieldNo = Rec.FieldNo("Room Resource No."));
    end;

    procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]);
    var
        SourceCodeSetup: Record "Source Code Setup";
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get();

        Rec."Shortcut Dimension 1 Code" := '';
        Rec."Shortcut Dimension 2 Code" := '';
        OldDimSetID := Rec."Dimension Set ID";
        Rec."Dimension Set ID" :=
          DimensionManagement.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> Rec."Dimension Set ID") and SeminarRegistrationLinesExist then begin
            Rec.Modify();
            UpdateAllLineDim(Rec."Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := Rec."Dimension Set ID";
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, Rec."Dimension Set ID");
        if Rec."No." <> '' then
            Rec.Modify();

        if OldDimSetID <> Rec."Dimension Set ID" then begin
            Rec.Modify();
            if SeminarRegistrationLinesExist() then
                UpdateAllLineDim(Rec."Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := Rec."Dimension Set ID";
        Rec."Dimension Set ID" :=
          DimensionManagement.EditDimensionSet(
            Rec."Dimension Set ID", StrSubstNo('%1', "No."),
            Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
        if OldDimSetID <> Rec."Dimension Set ID" then begin
            Rec.Modify();
            if SeminarRegistrationLinesExist then
                UpdateAllLineDim(Rec."Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not HideValidationDialog and GuiAllowed then
            if not Confirm(DoYouWantToUpDateLinesQst) then
                exit;

        SeminarRegistrationLine.Reset();
        SeminarRegistrationLine.SetRange("Document No.", Rec."No.");
        SeminarRegistrationLine.LockTable();
        if SeminarRegistrationLine.Find('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(SeminarRegistrationLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if SeminarRegistrationLine."Dimension Set ID" <> NewDimSetID then begin
                    SeminarRegistrationLine."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      SeminarRegistrationLine."Dimension Set ID", SeminarRegistrationLine."Shortcut Dimension 1 Code", SeminarRegistrationLine."Shortcut Dimension 2 Code");
                    SeminarRegistrationLine.Modify();
                end;
            until SeminarRegistrationLine.Next() = 0;
    end;
    // ASD8.02>
}