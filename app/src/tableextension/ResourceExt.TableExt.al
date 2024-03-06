tableextension 123456700 "Resource Ext ASD" extends Resource //156
{
    fields
    {
        field(123456701; "Internal/External ASD"; Enum "Internal/External ASD")
        {
            Caption = 'Internal/External';
            DataClassification = CustomerContent;
        }
        field(123456702; "Maximum Participants ASD"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = CustomerContent;
        }
        field(123456703; "Quantity per Day ASD"; Decimal)
        {
            Caption = 'Quantity per Day';
            DataClassification = CustomerContent;
        }
    }
}