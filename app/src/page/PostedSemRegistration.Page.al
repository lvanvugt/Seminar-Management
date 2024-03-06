page 123456734 "Posted Sem. Registration ASD"
{
    // ASD5.03 - 2020-10-03 D.E. Veloper - Chapter 5: Lab 3 - Find Entries Integration
    // ASD8.02 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 2 - Dimensions action

    Caption = 'Posted Seminar Registration';
    PageType = Document;
    SourceTable = "Posted Sem. Reg. Header ASD";
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the registered seminar will start.';
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the seminar registered on this document.';
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the seminar registered on this document.';
                }
                field("Instructor Resource No."; Rec."Instructor Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the instructor who is assigned to the registered seminar.';
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the instructor who is assigned to the registered seminar.';
                    DrillDown = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the posting of the seminar registration will be recorded.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the document was created.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the document is being planned, open for registration, has been closed, or canceled.';
                }
                field("Duration"; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the registered seminar.';
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum number of participants needed for to the registered seminar.';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of participants needed for to the registered seminar.';
                }
            }
            part(PostedSeminarRegLines; "Posted Sem. Reg. Subpage ASD")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group(SeminarRoom)
            {
                Caption = 'Seminar Room';
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the room that is assigned to the registered seminar.';
                }
                field("Room Name"; Rec."Room Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the room that is assigned to the registered seminar.';
                }
                field("Room Address"; Rec."Room Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address where the room is located.';
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information of the room.';
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code of the room address.';
                }
                field("Room City"; Rec."Room City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the room address.';
                }
                field("Room County"; Rec."Room County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the county of the room address.';
                }
                field("Room Country/Region Code"; Rec."Room Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the room address.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the involved seminar''s product type to link transactions made for this seminar with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT specification of the involved seminar to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Seminar Price"; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price of the registered seminar.';
                }
            }
        }
        area(factboxes)
        {
            part("Seminar Details FactBox ASD"; "Seminar Details FactBox ASD")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            part(CustomerDetailsFactBox; "Customer Details FactBox")
            {
                ApplicationArea = All;
                Provider = PostedSeminarRegLines;
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(SeminarRegistration)
            {
                Caption = '&Seminar Registration';
                action(Comments)
                {
                    Caption = 'Co&mments';
                    ToolTip = 'View or add comments for the record.';
                    ApplicationArea = All;
                    Image = ViewComments;
                    RunObject = Page "Seminar Comment List ASD";
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Document Type" = const("Posted Seminar Registration"));
                }
                action(Charges)
                {
                    Caption = '&Charges';
                    ToolTip = 'View or add charges for the record.';
                    ApplicationArea = All;
                    Image = Costs;
                    RunObject = Page "Posted Seminar Charges ASD";
                    RunPageLink = "Document No." = field("No.");
                }
                // ASD8.02<
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                    ApplicationArea = All;
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                // ASD8.02>
            }
        }
        // ASD5.03<
        area(processing)
        {
            action(Navigate)
            {
                Caption = 'Find entries...';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = All;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                    Navigate.Run();
                end;
            }
        }
        // ASD5.03> 
    }
}