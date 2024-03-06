page 123456710 "Seminar Registration ASD"
{
    // ASD4.05 - 2018-08-15 D.E. Veloper - Chapter 4: Lab 5 - Post action added 
    // ASD6.01 - 2018-08-15 D.E. Veloper - Chapter 6: Lab 1 - Print action added 
    // ASD8.02 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 2 - Dimensions action

    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = "Sem. Registration Header ASD";
    RefreshOnActivate = true;

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

                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
            part(SeminarRegistrationLines; "Sem. Registration Subpage ASD")
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
            part(SeminarDetailsFactBox; "Seminar Details FactBox ASD")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            part(CustomerDetailsFactBox; "Customer Details FactBox")
            {
                ApplicationArea = All;
                Provider = SeminarRegistrationLines;
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
                    RunObject = Page "Seminar Comment Sheet ASD";
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Document Type" = const("Seminar Registration"));
                }
                action(Charges)
                {
                    Caption = '&Charges';
                    ToolTip = 'View or add charges for the record.';
                    ApplicationArea = All;
                    Image = Costs;
                    RunObject = Page "Seminar Charges ASD";
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
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
                // ASD8.02>
            }
        }

        // ASD4.05<
        area(processing)
        {
            group(Posting)
            {
                Caption = 'Posting';
                action(Post)
                {
                    Caption = 'P&ost';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    ApplicationArea = All;
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        SeminarPosYesNo: Codeunit "Seminar-Post (Yes/No) ASD";
                    begin
                        SeminarPosYesNo.Run(Rec);
                        CurrPage.Close();
                    end;
                }
            }
            // ASD6.01<
            group(Print)
            {
                Caption = '&Print';
                action("Participants &List")
                {
                    Caption = 'Print';
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                    ApplicationArea = All;
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction();
                    var
                        SeminarDocumentPrint: Codeunit "Seminar Document Print ASD";
                    begin
                        SeminarDocumentPrint.PrintSeminarRegistrationHeader(Rec);
                    end;
                }
            }
            // ASD6.01>
        }
        // ASD4.05>
    }
}