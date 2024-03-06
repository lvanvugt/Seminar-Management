page 123456740 "Seminar Manager RC ASD"
{
    Caption = 'Seminar Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(SeminarRCHeadlines; "Seminar RC Headlines ASD")
            {
                ApplicationArea = Basic, Suite;
            }
            part(SeminarManagerActivities; "Seminar Manager Activities ASD")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ReportInboxPart; "Report Inbox Part")
            {
                ApplicationArea = Suite;
                AccessByPermission = tabledata "Report Inbox" = R;
            }
            part(MyJobQueue; "My Job Queue")
            {
                ApplicationArea = Advanced;
            }
            part(MySeminars; "My Seminars ASD")
            {
                ApplicationArea = Basic, Suite;
            }
            part(MyCustomers; "My Customers")
            {
                ApplicationArea = Basic, Suite;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Advanced;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(SeminarRegistration)
            {
                ApplicationArea = Basic;
                Caption = 'Seminar Registration';
                Image = NewTimesheet;
                RunObject = Page "Seminar Registration ASD";
                RunPageMode = Create;
            }
            action(SalesInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoice';
                Image = NewInvoice;
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
            }
        }
        area(Embedding)
        {
            action(SeminarRegistrations)
            {
                ApplicationArea = Basic;
                Caption = 'Seminar Registrations';
                RunObject = Page "Seminar Registration List ASD";
            }
            action(Seminars)
            {
                ApplicationArea = Basic;
                Caption = 'Seminars';
                RunObject = Page "Seminar List ASD";
            }
            action(Instructors)
            {
                ApplicationArea = Basic;
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = where(Type = const(Person));
            }
            action(Rooms)
            {
                ApplicationArea = Basic;
                Caption = 'Rooms';
                RunObject = Page "Resource List";
                RunPageView = where(Type = const(Room));
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Contacts)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                RunObject = Page "Contact List";
            }
        }
        area(Sections)
        {
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = RegisteredDocs;
                action(PostedSeminarRegistrations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Seminar Registrations';
                    RunObject = Page "Posted Sem. Reg. List ASD";
                }
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                }
                action(Registers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Registers';
                    RunObject = Page "Seminar Registers ASD";
                }
            }
        }
        area(Processing)
        {
            action(CreateInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Create Invoices';
                Image = CreateJobSalesInvoice;
                RunObject = Report "Create Seminar Invoices ASD";
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
        area(Reporting)
        {
            action(ParticipantList)
            {
                ApplicationArea = Basic;
                Caption = 'Participant List';
                Image = "Report";
                RunObject = Report "Sem. Reg.-Participant List ASD";
            }
        }
    }
}