page 123456790 "SeminarDemoDataSetupASD"
{
    // ASD3.03 - 2018-08-15 D.E. Veloper - Chapter 3: Lab 3 - Seminar Registrations
    // ASD4.07 - 2018-08-15 D.E. Veloper - Chapter 4: Lab 7 - Seminar Registration Posting
    // ASD6.04 - 2018-08-15 D.E. Veloper - Chapter 6: Lab 4 - Reporting
    // ASD8.05 - 2018-08-15 D.E. Veloper - Chapter 8: Lab 5 - Dimensions
    // ASD9.03 - 2018-08-15 D.E. Veloper - Chapter 9: Lab 3 - Cue Setup

    Caption = 'Seminar Demo Data Setup';
    PageType = Card;
    Editable = false;
    UsageCategory = Tasks;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Report,Seminar';

    actions
    {
        area(Navigation)
        {
            action(SeminarSetup)
            {
                Caption = 'Seminar Setup';
                ToolTip = 'View or setup Seminar Setup.';
                ApplicationArea = All;
                Image = Setup;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Seminar Setup ASD";
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                ToolTip = 'View or setup Seminars.';
                ApplicationArea = All;
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Seminar List ASD";
            }
            // ASD3.03<
            action(SeminarRegistrations)
            {
                Caption = 'Seminar Registrations';
                ToolTip = 'View or setup Seminar Registrations.';
                ApplicationArea = All;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Seminar Registration List ASD";
            }
            // ASD3.03>
            // ASD4.07<
            action(PostedSeminarRegistrations)
            {
                Caption = 'Posted Seminar Registrations';
                ToolTip = 'View Posted Seminar Registrations.';
                ApplicationArea = All;
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Posted Sem. Reg. List ASD";
            }
            action(SeminarRegisters)
            {
                Caption = 'Seminar Registers';
                ToolTip = 'View Seminar Registers.';
                ApplicationArea = All;
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Seminar Registers ASD";
            }
            // ASD4.07>
            // ASD6.04<
            action(SeminarReportSelections)
            {
                Caption = 'Seminar Report Selections';
                ToolTip = 'View Seminar Report Selections.';
                ApplicationArea = All;
                Image = SelectReport;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = Page "Seminar Report Selections ASD";
            }
            action(SalesInvoices)
            {
                Caption = 'Sales Invoices';
                ToolTip = 'View sales invoices.';
                ApplicationArea = All;
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = Page "Sales Invoice List";
            }
            // ASD6.04>
        }
        // ASD6.04<
        area(Reporting)
        {
            action(SeminarRegParticipantList)
            {
                Caption = 'Seminar Registration - Participant List';
                ToolTip = 'View Seminar Registration - Participant List.';
                ApplicationArea = All;
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = Report "Sem. Reg.-Participant List ASD";
            }
        }
        // ASD6.04>
        area(Processing)
        {
            action(CreateSeminars)
            {
                Caption = 'Create Seminars';
                ToolTip = 'Add seminars for demo and test purposes.';
                ApplicationArea = All;
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    CreateSeminarsDDT: Codeunit CreateSeminarsDDTASD;
                begin
                    CreateSeminarsDDT.Run();
                end;
            }
            // ASD3.03<
            action(CreateSeminarRegistrations)
            {
                Caption = 'Create Seminar Registrations';
                ToolTip = 'Add seminar registrations for demo and test purposes.';
                ApplicationArea = All;
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CreateSeminarRegistrationsDDT: Codeunit CreateSemRegistrationsDDTASD;
                begin
                    CreateSeminarRegistrationsDDT.Run();
                end;
            }
            // ASD3.03>
            // ASD4.07<
            action(PostSeminarRegistrations)
            {
                Caption = 'Post Seminar Registrations';
                ToolTip = 'Create and Post All Seminar Registrations for demo and test purposes.';
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    PostSeminarRegistrationsDDT: Codeunit PostSeminarRegistrationsDDTASD;
                begin
                    PostSeminarRegistrationsDDT.Run();
                end;
            }
            // ASD4.07>
            // ASD6.04<
            action(CreateSemReportSelections)
            {
                Caption = 'Create Seminar Report Selections';
                ToolTip = 'Create Seminar Report Selections for demo and test purposes.';
                ApplicationArea = All;
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CreateSemReportSelections: Codeunit CreateSemRepSelectionsDDTASD;
                begin
                    CreateSemReportSelections.Run();
                end;
            }
            action(CreateSeminarInvoices)
            {
                Caption = 'Create Seminar Invoices';
                ToolTip = 'Create Seminar invoices for demo and test purposes.';
                ApplicationArea = All;
                Image = NewInvoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CreateSeminarInvoices: Report "Create Seminar Invoices ASD";
                begin
                    CreateSeminarInvoices.Run();
                end;
            }
            // ASD6.04>
            // ASD8.05<
            action(CreateSeminarDimensions)
            {
                Caption = 'Create Seminar Dimensions';
                ToolTip = 'Create Seminar Dimensions for demo and test purposes.';
                ApplicationArea = All;
                Image = ChangeDimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CreateSeminarDimensions: Codeunit CreateSeminarDimensionsDDTASD;
                begin
                    CreateSeminarDimensions.Run();
                end;
            }
            // ASD8.05>
            // ASD9.03<
            action(CreateSeminarRoleCenter)
            {
                Caption = 'Create Seminar Role Center Data';
                ToolTip = 'Create Seminar Role Center data for demo and test purposes.';
                ApplicationArea = All;
                Image = MarketingSetup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CreateSeminarRoleCenterDDT: Codeunit CreateSeminarRoleCenterDDTASD;
                begin
                    CreateSeminarRoleCenterDDT.Run();
                end;
            }
            // ASD9.03>
            action(CleanupTables)
            {
                Caption = 'Cleanup Tables';
                ToolTip = 'Cleanup extension tables.';
                ApplicationArea = All;
                Image = DeleteQtyToHandle;

                trigger OnAction();
                var
                    CleanupTables: Report CleanupSeminarTablesASD;
                begin
                    CleanupTables.Run();
                end;
            }
        }
    }
}