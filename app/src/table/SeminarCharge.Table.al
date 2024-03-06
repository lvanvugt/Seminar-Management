table 123456712 "Seminar Charge ASD"
{
    Caption = 'Seminar Charge';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "Sem. Registration Header ASD";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; Type; Enum "Seminar Charge Type ASD")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Rec.Type <> xRec.Type then
                    Rec.Description := '';
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(Resource)) Resource else
            if (Type = const("G/L Account")) "G/L Account";

            trigger OnValidate();
            begin
                case Rec.Type of
                    Rec.Type::Resource:
                        GetResourceDefaults();
                    Rec.Type::"G/L Account":
                        GetGLAccountDefaults();
                end
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                CalculateTotalPrice(Rec."Unit Price", Rec.Quantity);
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;

            trigger OnValidate();
            begin
                CalculateTotalPrice(Rec."Unit Price", Rec.Quantity);
            end;
        }
        field(8; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                CalculateUnitPrice(Rec."Total Price", Rec.Quantity);
            end;
        }
        field(9; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No.")) else
            "Unit of Measure";

            trigger OnValidate();
            begin
                case Rec.Type of
                    Rec.Type::Resource:
                        GetResourceUOM();
                    Rec.Type::"G/L Account":
                        Rec."Qty. per Unit of Measure" := 1;
                end;
                if CurrFieldNo = Rec.FieldNo("Unit of Measure Code") then
                    Rec.Validate(Quantity);
            end;
        }
        field(12; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
        }
        field(13; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
        }
        field(14; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(15; Registered; Boolean)
        {
            Caption = 'Registered';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        GLAccount: Record "G/L Account";
        Resource: Record Resource;
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";

    trigger OnInsert();
    begin
        SeminarRegistrationHeader.Get(Rec."Document No.");
    end;

    trigger OnDelete();
    begin
        Rec.TestField(Registered, false)
    end;

    local procedure GetResource();
    begin
        Rec.TestField("No.");
        if Rec."No." <> Resource."No." then
            Resource.Get(Rec."No.");
    end;

    local procedure GetGLAccount();
    begin
        Rec.TestField("No.");
        if Rec."No." <> GLAccount."No." then
            GLAccount.Get(Rec."No.");
    end;

    local procedure CalculateTotalPrice(UnitPrice: Decimal; Qntity: Decimal);
    begin
        Rec."Total Price" := Round(UnitPrice * Qntity, 0.01);
    end;

    local procedure CalculateUnitPrice(TotalPrice: Decimal; Qntity: Decimal);
    begin
        if Qntity <> 0 then
            Rec."Unit Price" := Round(TotalPrice / Qntity, 0.01);
    end;

    local procedure GetResourceDefaults();
    begin
        GetResource();
        Resource.TestField(Blocked, false);
        Resource.TestField("Gen. Prod. Posting Group");
        Rec.Description := Resource.Name;
        Rec."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        Rec."VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
        Rec."Unit of Measure Code" := Resource."Base Unit of Measure";
        Rec."Unit Price" := Resource."Unit Price";
    end;

    local procedure GetResourceUOM();
    begin
        GetResource();
        if Rec."Unit of Measure Code" = '' then
            Rec."Unit of Measure Code" := Resource."Base Unit of Measure";
        ResourceUnitOfMeasure.Get(Rec."No.", Rec."Unit of Measure Code");
        Rec."Qty. per Unit of Measure" := ResourceUnitOfMeasure."Qty. per Unit of Measure";
        CalculateTotalPrice(Resource."Unit Price", Rec."Qty. per Unit of Measure");
    end;

    local procedure GetGLAccountDefaults();
    begin
        GetGLAccount();
        GLAccount.CheckGLAcc();
        GLAccount.TestField("Direct Posting", true);
        Rec.Description := GLAccount.Name;
        Rec."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
        Rec."VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
    end;
}

