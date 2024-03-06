table 123456711 "Seminar Registration Line ASD"
{
    // ASD8.02 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 2 - Dimensions functionality

    Caption = 'Seminar Registration Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "Sem. Registration Header ASD";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate();
            begin
                if (Rec."Bill-to Customer No." <> xRec."Bill-to Customer No.") then
                    if Rec.Registered then
                        Error(
                            YouCannotChangeErr,
                            Rec.FieldCaption("Bill-to Customer No."),
                            Rec.FieldCaption(Registered),
                            Rec.Registered
                        );

                // ASD8.02<
                CreateDimFromDefaultDim(Rec.FieldNo("Bill-to Customer No."));
                // ASD8.02>
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Contact;

            trigger OnValidate();
            begin
                if (Rec."Bill-to Customer No." <> '') and (Rec."Participant Contact No." <> '') then begin
                    Contact.Get(Rec."Participant Contact No.");
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                    ContactBusinessRelation.SetRange("No.", Rec."Bill-to Customer No.");
                    if ContactBusinessRelation.FindFirst() then
                        if ContactBusinessRelation."Contact No." <> Contact."Company No." then
                            Error(ContactRelatedToDifferentCompanyErr, Contact."No.", Contact.Name, Rec."Bill-to Customer No.");
                end;
            end;

            trigger OnLookup();
            begin
                ContactBusinessRelation.Reset();
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", Rec."Bill-to Customer No.");
                if ContactBusinessRelation.FindFirst() then begin
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                    if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then
                        Rec."Participant Contact No." := Contact."No.";
                end;

                Rec.CalcFields("Participant Name");
            end;
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
            DataClassification = CustomerContent;
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            AutoFormatType = 2;

            trigger OnValidate();
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                if Rec.Price = 0 then
                    Rec."Line Discount Amount" := 0
                else begin
                    GLSetup.Get();
                    Rec."Line Discount Amount" := Round(Rec.Price * Rec."Line Discount %" / 100, GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount();
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if Price = 0 then
                    "Line Discount %" := 0
                else begin
                    GLSetup.Get();
                    "Line Discount %" := Round("Line Discount Amount" / Price * 100, GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount();
            end;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                Rec.TestField("Bill-to Customer No.");
                Rec.TestField(Price);
                GLSetup.Get();
                Rec.Amount := Round(Amount, GLSetup."Amount Rounding Precision");
                Rec."Line Discount Amount" := Round(Rec.Price - Rec.Amount, GLSetup."Amount Rounding Precision");
                if Rec.Price = 0 then
                    Rec."Line Discount %" := 0
                else
                    Rec."Line Discount %" := Round(Rec."Line Discount Amount" / Rec.Price * 100, GLSetup."Amount Rounding Precision");
            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            DataClassification = CustomerContent;
            Editable = false;
        }
        // ASD8.02<
        field(40; "Shortcut Dimension 1 Code"; Code[20])
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
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, Rec."Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions();
            end;
        }
        // ASD8.02>
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        GLSetup: Record "General Ledger Setup";
        // ASD8.02<
        DimensionManagement: Codeunit DimensionManagement;
        // ASD8.02>
        YouCannotChangeErr: Label 'You cannot change the %1, because %2 is %3.';
        ContactRelatedToDifferentCompanyErr: Label 'Contact %1 %2 is related to a different company than customer %3.';

    trigger OnInsert();
    begin
        GetSeminarRegistrationHeader();
        Rec."Registration Date" := WorkDate();
        Rec.Validate(Price, SeminarRegistrationHeader.Price);
        CalculateAmount();
    end;

    trigger OnDelete();
    begin
        Rec.TestField(Registered, false)
    end;

    local procedure GetSeminarRegistrationHeader();
    begin
        if SeminarRegistrationHeader."No." <> Rec."Document No." then
            SeminarRegistrationHeader.Get(Rec."Document No.");
    end;

    local procedure CalculateAmount();
    begin
        Rec.Validate(Amount, Round(Rec.Price * (1 - Rec."Line Discount %" / 100)));
    end;

    local procedure UpdateAmount();
    begin
        GLSetup.Get();
        Rec.Amount := Round(Rec.Price - Rec."Line Discount Amount", GLSetup."Amount Rounding Precision")
    end;

    // ASD8.02<
    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet(Rec."Dimension Set ID", StrSubstNo('%1 %2', Rec."Document No.", Rec."Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
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
        DimensionManagement.AddDimSource(DefaultDimSource, Database::Customer, Rec."Bill-to Customer No.", FieldNo = Rec.FieldNo("Bill-to Customer No."));
    end;

    procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]);
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();

        Rec."Shortcut Dimension 1 Code" := '';
        Rec."Shortcut Dimension 2 Code" := '';
        GetSeminarRegistrationHeader;
        Rec."Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup.Sales,
            Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code",
            SeminarRegistrationHeader."Dimension Set ID", Database::Customer);
        DimensionManagement.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, Rec."Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimensionManagement.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);
    end;
    // ASD8.02>
}
