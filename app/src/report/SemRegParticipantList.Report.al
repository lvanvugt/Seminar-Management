report 123456701 "Sem. Reg.-Participant List ASD"
{
    Caption = 'Seminar Registration-Participant List';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SeminarRegParticipantList.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(SeminarRegistrationHeader; "Sem. Registration Header ASD")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Seminar No.";

            column(No_SeminarRegistrationHeader; "No.")
            {
                IncludeCaption = true;
            }
            column(SeminarNo_SeminarRegistrationHeader; "Seminar No.")
            {
                IncludeCaption = true;
            }
            column(SeminarName_SeminarRegistrationHeader; "Seminar Name")
            {
                IncludeCaption = true;
            }
            column(StartingDate_SeminarRegistrationHeader; "Starting Date")
            {
                IncludeCaption = true;
            }
            column(Duration_SeminarRegistrationHeader; Duration)
            {
                IncludeCaption = true;
            }
            column(InstructorName_SeminarRegistrationHeader; "Instructor Name")
            {
                IncludeCaption = true;
            }
            column(RoomName_SeminarRegistrationHeader; "Room Name")
            {
                IncludeCaption = true;
            }
            dataitem(SeminarRegistrationLine; "Seminar Registration Line ASD")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");

                column(BilltoCustomerNo_SeminarRegistrationLine; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(ParticipantContactNo_SeminarRegistrationLine; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column(ParticipantName_SeminarRegistrationLine; "Participant Name")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnPreDataItem();
            begin
                CompanyInformation.Get();
            end;

            trigger OnAfterGetRecord();
            begin
                SeminarRegistrationHeader.CalcFields("Instructor Name");
            end;

            trigger OnPostDataItem();
            begin
                if not CurrReport.Preview() then
                    Codeunit.Run(Codeunit::"Sem. Registration Printed ASD", SeminarRegistrationHeader);
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(CompanyInformation_Name; CompanyInformation.Name) { }
        }
    }

    labels
    {
        SeminarRegParticipantListTitle = 'Seminar Registration - Participant List';
    }

    var
        CompanyInformation: Record "Company Information";
        Print: Boolean;
}