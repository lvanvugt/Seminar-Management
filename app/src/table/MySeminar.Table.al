table 123456741 "My Seminar ASD"
{
    Caption = 'My Seminar';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            NotBlank = true;
            TableRelation = "Seminar ASD";
        }
    }

    keys
    {
        key(PK; "User ID", "Seminar No.")
        {
            Clustered = true;
        }
    }
}