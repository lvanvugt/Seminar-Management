report 123456700 "Create Seminar Invoices ASD"
{
    Caption = 'Create Seminar Invoices';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(SeminarLedgerEntry; "Seminar Ledger Entry ASD")
        {
            DataItemTableView = sorting("Bill-to Customer No.", "Document No.", "Charge Type", "Participant Contact No.") where(Chargeable = const(true));
            RequestFilterFields = "Bill-to Customer No.", "Document No.", "Charge Type", "Participant Contact No.";

            trigger OnPreDataItem();
            begin
                if PostingDateReq = 0D then
                    Error(PleaseEnterPostingDateErr);
                if DocDateReq = 0D then
                    Error(PleaseEnterDocumentDateErr);

                Window.Open(
                    CreatingSeminarInvoiceDlg +
                    CustomerNoDlg +
                    RegistrationNoDlg);

                SalesHeader.SetHideValidationDialog(true);
            end;

            trigger OnAfterGetRecord();
            begin
                if SeminarLedgerEntry."Bill-to Customer No." <> Customer."No." then
                    Customer.Get(SeminarLedgerEntry."Bill-to Customer No.");

                if SeminarLedgerEntry."Document No." <> CurrentDocumentNo then begin
                    PostedSemRegHeader.Get(SeminarLedgerEntry."Document No.");
                    CurrentInstructorNo := PostedSemRegHeader."Instructor Resource No.";
                end;

                if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then
                    NoOfSalesInvoiceErrors := NoOfSalesInvoiceErrors + 1
                else begin
                    if SeminarLedgerEntry."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then begin
                        Window.Update(1, SeminarLedgerEntry."Bill-to Customer No.");
                        if SalesHeader."No." <> '' then
                            FinalizeSalesInvoiceHeader();
                        InsertSalesInvoiceHeader();
                    end;
                    Window.Update(2, SeminarLedgerEntry."Seminar Registration No.");

                    SetFieldsOnSalesLine(SeminarLedgerEntry);
                    SalesLine.Insert();
                    NextLineNo := NextLineNo + 10000;
                end;
            end;

            trigger OnPostDataItem();
            begin
                Window.Close();
                if SalesHeader."No." = '' then
                    Message(NothingToInvoiceMsg)
                else begin
                    FinalizeSalesInvoiceHeader();
                    if NoOfSalesInvoiceErrors = 0 then
                        Message(NumberInvoicesCreatedMsg, NoOfSalesInvoices)
                    else
                        Message(NotAllInvoicePosted, NoOfSalesInvoiceErrors)
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDateReq; PostingDateReq)
                    {
                        Caption = 'Posting Date';
                        Tooltip = 'Specifies the date that the program will use as the posting date when you post if you place a checkmark in one or both of the following boxes.';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        Caption = 'Document Date';
                        Tooltip = 'Specifies the date that the program will use as the document date when you post if you place a checkmark in one or both of the following boxes.';
                    }
                    field(CalcInvoiceDiscount; CalcInvoiceDiscount)
                    {
                        Caption = 'Calc. Inv. Discount';
                        Tooltip = 'Specifies if you want the invoice discount amount to be automatically calculated on the orders before posting.';
                    }
                    field(PostInvoices; PostInvoices)
                    {
                        Caption = 'Post Invoices';
                        Tooltip = 'Specifies whether the invoices will be posted automatically. If you place a check in the box, it will apply to all the invoices created.';
                    }
                }
            }
        }

        trigger OnOpenPage();
        var
            SalesSetup: Record "Sales & Receivables Setup";
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get();
            CalcInvoiceDiscount := SalesSetup."Calc. Inv. Discount";
        end;
    }

    var
        Customer: Record Customer;
        PostedSemRegHeader: Record "Posted Sem. Reg. Header ASD";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Window: Dialog;
        CurrentDocumentNo: Code[20];
        CurrentInstructorNo: Code[20];
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvoiceDiscount: Boolean;
        PostInvoices: Boolean;
        NextLineNo: Integer;
        NoOfSalesInvoiceErrors: Integer;
        NoOfSalesInvoices: Integer;
        PleaseEnterPostingDateErr: Label 'Please enter the posting date.';
        PleaseEnterDocumentDateErr: Label 'Please enter the document date.';
        CreatingSeminarInvoiceDlg: Label 'Creating Seminar Invoices...\\';
        CustomerNoDlg: Label 'Customer No.      #1##########\';
        RegistrationNoDlg: Label 'Registration No.   #2##########\';
        NumberInvoicesCreatedMsg: Label 'The number of invoice(s) created is %1.';
        NotAllInvoicePosted: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        NothingToInvoiceMsg: Label 'There is nothing to invoice.';

    local procedure FinalizeSalesInvoiceHeader();
    var
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
    begin
        if CalcInvoiceDiscount then
            SalesCalcDiscount.Run(SalesLine);
        SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
        NoOfSalesInvoices := NoOfSalesInvoices + 1;
        if PostInvoices then
            if not SalesPost.Run(SalesHeader) then
                NoOfSalesInvoiceErrors := NoOfSalesInvoiceErrors + 1;
    end;

    local procedure InsertSalesInvoiceHeader();
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        if SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then
            SalesHeader.Validate("Bill-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        SalesHeader.Validate("Posting Date", PostingDateReq);
        SalesHeader.Validate("Document Date", DocDateReq);
        SalesHeader.Validate("Currency Code", '');
        SalesHeader.Modify();
        NextLineNo := 10000;
    end;

    local procedure SetFieldsOnSalesLine(SeminarLedgerEntry: Record "Seminar Ledger Entry ASD");
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Seminar: Record "Seminar ASD";
    begin
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NextLineNo;

        SetNoOnSalesLine(SeminarLedgerEntry);
        Seminar.Get(SeminarLedgerEntry."Seminar No.");
        SalesLine.Validate("VAT Prod. Posting Group", Seminar."VAT Prod. Posting Group");
        if SeminarLedgerEntry.Description <> '' then
            SalesLine.Description := SeminarLedgerEntry.Description
        else
            SalesLine.Description := Seminar.Name;

        SalesLine.Validate(Quantity, SeminarLedgerEntry.Quantity);
        SalesLine.Validate("Unit Price", SeminarLedgerEntry."Unit Price");
        if SalesHeader."Currency Code" <> '' then begin
            SalesHeader.TestField("Currency Factor");
            SalesLine."Unit Price" :=
                Round(
                    CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                    WorkDate(), SalesHeader."Currency Code",
                    SalesLine."Unit Price", SalesHeader."Currency Factor"));
        end;
    end;

    local procedure SetNoOnSalesLine(SeminarLedgerEntry: Record "Seminar Ledger Entry ASD");
    begin
        case SeminarLedgerEntry.Type of
            SeminarLedgerEntry.Type::Resource:
                begin
                    SalesLine.Type := SalesLine.Type::Resource;
                    case SeminarLedgerEntry."Charge Type" of
                        SeminarLedgerEntry."Charge Type"::Room:
                            SalesLine.Validate("No.", SeminarLedgerEntry."Room Resource No.");
                        SeminarLedgerEntry."Charge Type"::Instructor,
                        SeminarLedgerEntry."Charge Type"::Participant:
                            SalesLine.Validate("No.", CurrentInstructorNo);
                    end;
                end;
        end;
    end;
}