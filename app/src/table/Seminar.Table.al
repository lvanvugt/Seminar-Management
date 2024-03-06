table 123456700 "Seminar ASD"
{
    // ASD7.01 - 2018-08-15 D.E. Veloper - Chapter 7: Lab 1 - Statistics functionality
    // ASD8.01 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 1 - Dimensions functionality

    Caption = 'Seminar';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                    Rec."No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec."Search Name" = UpperCase(xRec.Name)) or (Rec."Search Name" = '') then
                    Rec."Search Name" := Rec.Name;
            end;
        }
        field(3; "Duration"; Decimal)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
        }
        field(4; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = CustomerContent;
        }
        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = CustomerContent;
        }
        field(6; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(7; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Comment Line" where("Table Name" = const(Seminar), "No." = field("No.")));
        }
        field(10; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(11; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate();
            begin
                if xRec."Gen. Prod. Posting Group" <> Rec."Gen. Prod. Posting Group" then
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, Rec."Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
            end;
        }
        field(12; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        // ASD8.01<
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, Rec."Global Dimension 1 Code");
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, Rec."Global Dimension 2 Code");
            end;
        }
        // ASD8.01>
        // ASD7.01<
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(21; "Charge Type Filter"; Enum "Seminar Journal Charge Type ASD")
        {
            Caption = 'Charge Type Filter';
            FieldClass = FlowFilter;
        }
        field(25; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            FieldClass = FlowField;
            CalcFormula = sum("Seminar Ledger Entry ASD"."Total Price" where("Seminar No." = field("No."),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Charge Type" = field("Charge Type Filter")));
            AutoFormatType = 1;
            Editable = false;
        }
        field(26; "Total Price (Not Chargeable)"; Decimal)
        {
            Caption = 'Total Price (Not Chargeable)';
            FieldClass = FlowField;
            CalcFormula = sum("Seminar Ledger Entry ASD"."Total Price" where("Seminar No." = field("No."),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Charge Type" = field("Charge Type Filter"),
                                                                          Chargeable = const(false)));
            AutoFormatType = 1;
            Editable = false;
        }
        field(27; "Total Price (Chargeable)"; Decimal)
        {
            Caption = 'Total Price (Chargeable)';
            FieldClass = FlowField;
            CalcFormula = sum("Seminar Ledger Entry ASD"."Total Price" where("Seminar No." = field("No."),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Charge Type" = field("Charge Type Filter"),
                                                                          Chargeable = const(true)));
            AutoFormatType = 1;
            Editable = false;
        }
        // ASD7.01>
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name") { }
    }

    var
        SeminarSetup: Record "Seminar Setup ASD";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        // ASD8.01<
        DimensionManagement: Codeunit DimensionManagement;
    // ASD8.01>

    trigger OnInsert()
    begin
        if Rec."No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, Rec."No.", Rec."No. Series");
        end;
        // ASD8.01<
        DimensionManagement.UpdateDefaultDim(
            Database::"Seminar ASD",
            Rec."No.",
            Rec."Global Dimension 1 Code",
            Rec."Global Dimension 2 Code"
            );
        // ASD8.01>
    end;

    trigger OnModify()
    begin
        Rec."Last Date Modified" := Today();
    end;

    trigger OnDelete()
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.Reset();
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", Rec."No.");
        CommentLine.DeleteAll();

        // ASD8.01<
        DimensionManagement.DeleteDefaultDim(Database::"Seminar ASD", Rec."No.");
        // ASD8.01>
    end;

    trigger OnRename()
    begin
        Rec."Last Date Modified" := Today();
    end;

    // ASD8.01<
    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimensionManagement.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimensionManagement.SaveDefaultDim(Database::"Seminar ASD", Rec."No.", FieldNumber, ShortcutDimCode);
        Rec.Modify();
    end;
    // ASD8.01>

    procedure AssistEdit(): Boolean;
    begin
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", Rec."No. Series") then begin
            NoSeriesMgt.SetSeries(Rec."No.");
            exit(true);
        end;
    end;
}