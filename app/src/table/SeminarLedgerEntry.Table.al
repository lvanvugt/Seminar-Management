table 123456732 "Seminar Ledger Entry ASD"
{
    // ASD5.03 - 2020-10-03 D.E. Veloper - Chapter 5: Lab 3 - Find Entries Integration
    // ASD7.01 - 2018-08-15 D.E. Veloper - Chapter 7: Lab 1 - Added SK for statistics functionality
    // ASD8.03 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 3 - Dimensions functionality

    Caption = 'Seminar Ledger Entry';
    DataClassification = CustomerContent;
    // ASD5.03<
    LookupPageId = "Seminar Ledger Entries ASD";
    DrillDownPageId = "Seminar Ledger Entries ASD";
    // ASD5.03>

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            TableRelation = "Seminar ASD";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(5; "Entry Type"; Enum "Seminar Journal Entry Type ASD")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(9; "Charge Type"; Enum "Seminar Journal Charge Type ASD")
        {
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
        }
        field(10; Type; Enum "Seminar Charge Type ASD")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(13; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Contact;
        }
        field(15; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            DataClassification = CustomerContent;
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(17; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Room));
        }
        field(18; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Person));
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = CustomerContent;
        }
        field(21; "Resource Ledger Entry No."; Integer)
        {
            Caption = 'Resource Ledger Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Res. Ledger Entry";
        }
        field(22; "Source Type"; Enum "Seminar Journal Source Type ASD")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Seminar)) "Seminar ASD";
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(25; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Source Code";
        }
        field(26; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(27; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(28; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
        }
        // ASD8.03<
        field(51; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(52; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
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
        // ASD8.03>
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        // ASD5.03<
        key(Key2; "Document No.", "Posting Date") { }
        // ASD5.03>
        // ASD7.01<
        key(Key3; "Seminar No.", "Posting Date", "Charge Type", Chargeable)
        {
            SumIndexFields = "Total Price";
        }
        // ASD7.01>
    }

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure CopyFromSeminarJnlLine(SeminarJnlLine: Record "Seminar Journal Line ASD");
    begin
        Rec."Entry Type" := SeminarJnlLine."Entry Type";
        Rec."Document No." := SeminarJnlLine."Document No.";
        Rec."Posting Date" := SeminarJnlLine."Posting Date";
        Rec."Document Date" := SeminarJnlLine."Document Date";
        Rec."Seminar No." := SeminarJnlLine."Seminar No.";
        Rec.Description := SeminarJnlLine.Description;
        Rec."Charge Type" := SeminarJnlLine."Charge Type";
        Rec.Type := SeminarJnlLine.Type;
        Rec.Quantity := SeminarJnlLine.Quantity;
        Rec."Unit Price" := SeminarJnlLine."Unit Price";
        Rec."Total Price" := SeminarJnlLine."Total Price";
        Rec."Bill-to Customer No." := SeminarJnlLine."Bill-to Customer No.";
        Rec."Participant Contact No." := SeminarJnlLine."Participant Contact No.";
        Rec."Participant Name" := SeminarJnlLine."Participant Name";
        Rec."Room Resource No." := SeminarJnlLine."Room Resource No.";
        Rec."Instructor Resource No." := SeminarJnlLine."Instructor Resource No.";
        Rec."Starting Date" := SeminarJnlLine."Starting Date";
        Rec."Seminar Registration No." := SeminarJnlLine."Seminar Registration No.";
        Rec."Resource Ledger Entry No." := SeminarJnlLine."Resource Ledger Entry No.";
        Rec."Source Code" := SeminarJnlLine."Source Code";
        Rec.Chargeable := SeminarJnlLine.Chargeable;
        Rec."Journal Batch Name" := SeminarJnlLine."Journal Batch Name";
        Rec."Reason Code" := SeminarJnlLine."Reason Code";
        Rec."Source Type" := SeminarJnlLine."Source Type";
        Rec."Source No." := SeminarJnlLine."Source No.";
        // ASD8.03<
        Rec."Global Dimension 1 Code" := SeminarJnlLine."Shortcut Dimension 1 Code";
        Rec."Global Dimension 2 Code" := SeminarJnlLine."Shortcut Dimension 2 Code";
        Rec."Dimension Set ID" := SeminarJnlLine."Dimension Set ID";
        // ASD8.03>
    end;

    // ASD8.03<
    procedure ShowDimensions();
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.ShowDimensionSet(Rec."Dimension Set ID", StrSubstNo('%1 %2', Rec.TableCaption(), Rec."Entry No."));
    end;
    // ASD8.03>
}