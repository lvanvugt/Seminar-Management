page 123456713 "Seminar Registration List ASD"
{
    // ASD4.05 - 2018-08-15 D.E. Veloper - Chapter 4: Lab 5 - Post action added 
    // ASD6.01 - 2018-08-15 D.E. Veloper - Chapter 6: Lab 1 - Print action added 
    // ASD8.02 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 2 - Dimensions action

    Caption = 'Seminar Registration List';
    PageType = List;
    SourceTable = "Sem. Registration Header ASD";
    CardPageID = "Seminar Registration ASD";
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
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
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of participants needed for to the registered seminar.';
                }
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the room that is assigned to the registered seminar.';
                }
            }
        }
        area(factboxes)
        {
            part(SeminarDetailsFactBox; "Seminar Details FactBox ASD")
            {
                SubPageLink = "No." = field("Seminar No.");
            }
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }
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