page 123456700 "Seminar Card ASD"
{
    // ASD5.01 - 2020-10-03 D.E. Veloper - Chapter 5: Lab 1 - Transactions Integration
    // ASD5.02 - 2020-10-03 D.E. Veloper - Chapter 5: Lab 1 - New Documents Integration
    // ASD7.02 - 2018-08-15 D.E. Veloper - Chapter 5: Lab 1 - Statistics action
    // ASD8.01 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 1 - Dimensions action

    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = "Seminar ASD";

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
                    ToolTip = 'Specifies the number of the seminar. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the seminar''s name. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an alternate name that you can use to search for a seminar.';
                }
                field("Duration"; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the seminar''s duration in days.';
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum number of participants needed for to the seminar.';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of participants allowed for to the seminar.';

                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the most recent change of information in the Seminar Card window.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the seminar''s product type to link transactions made for this seminar with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT specification of the involved seminar to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price of the seminar.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Seminar)
            {
                Caption = '&Seminar';
                // ASD5.01<
                action(LedgerEntries)
                {
                    Caption = 'Ledger E&ntries';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                    ApplicationArea = All;
                    Image = WarrantyLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Seminar Ledger Entries ASD";
                    RunPageLink = "Seminar No." = field("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                // ASD5.01>
                action(Comments)
                {
                    Caption = 'Co&mments';
                    ToolTip = 'View or add comments for the record.';
                    ApplicationArea = All;
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                }
                // ASD7.02<
                action(Statistics)
                {
                    Caption = 'Statistics';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                    ApplicationArea = All;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Seminar Statistics ASD";
                    RunPageLink = "No." = field("No."), "Date Filter" = field("Date Filter"), "Charge Type Filter" = field("Charge Type Filter");
                    ShortCutKey = 'F7';
                }
                // ASD7.02>
                // ASD8.01<
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to seminar documents to distribute costs and analyze transaction history.';
                    ApplicationArea = All;
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(123456700), "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                // ASD8.01>
            }
            // ASD5.01<
            group(Registrations)
            {
                Caption = '&Registrations';
                action(RegistrationsAction)
                {
                    Caption = '&Registrations';
                    ToolTip = 'View a list of ongoing registrations for the seminar.';
                    ApplicationArea = All;
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Seminar Registration List ASD";
                    RunPageLink = "Seminar No." = field("No.");
                }
            }
            // ASD5.01>
        }
        // ASD5.02<
        area(creation)
        {
            action(SeminarRegistration)
            {
                Caption = 'Seminar Registration';
                ToolTip = 'Create a registration for the seminar.';
                ApplicationArea = All;
                Image = NewTimesheet;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = Page "Seminar Registration ASD";
                RunPageLink = "Seminar No." = field("No.");
                RunPageMode = Create;
            }
        }
        // ASD5.02>
    }
}