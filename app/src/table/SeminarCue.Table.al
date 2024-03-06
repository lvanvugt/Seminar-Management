table 123456740 "Seminar Cue ASD"
{
    Caption = 'Seminar Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            Editable = false;
        }
        field(2; Planned; Integer)
        {
            Caption = 'Planned';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Sem. Registration Header ASD" where(Status = const(Planning)));
        }
        field(3; Registered; Integer)
        {
            Caption = 'Registered';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Sem. Registration Header ASD" where(Status = const(Registration)));
        }
        field(4; Closed; Integer)
        {
            Caption = 'Closed';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Sem. Registration Header ASD" where(Status = const(Closed)));
        }
        field(5; "Days before Next"; Integer)
        {
            Caption = 'Days before Next';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure InsertRecord();
    begin
        if not Rec.FindFirst() then
            Rec.Insert();
    end;

    procedure CalculateDaysToNext(): Integer
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        SeminarRegistrationHeader.SetCurrentKey("Starting Date", Status);
        SeminarRegistrationHeader.SetRange(Status, SeminarRegistrationHeader.Status::Registration);
        SeminarRegistrationHeader.Ascending(true);
        SeminarRegistrationHeader.SetFilter("Starting Date", '%1..', Today() + 1);
        if SeminarRegistrationHeader.FindFirst() then
            exit(SeminarRegistrationHeader."Starting Date" - Today());
    end;
}