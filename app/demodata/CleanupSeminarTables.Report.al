report 123456790 "CleanupSeminarTablesASD"
{
    // ASD3.03 - 2018-08-15 D.E. Veloper - Chapter 3: Lab 3 - Seminar Registration related tables
    // ASD4.07 - 2018-08-15 D.E. Veloper - Chapter 4: Lab 7 - Posting related tables
    // ASD6.04 - 2018-08-15 D.E. Veloper - Chapter 6: Lab 4 - Reporting related tables
    // ASD9.03 - 2018-08-15 D.E. Veloper - Chapter 9: Lab 3 - Cue Setup related tables

    Caption = 'Cleanup Tables';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Seminar; "Seminar ASD")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem();
            begin
                Seminar.DeleteAll(true)
            end;
        }
        dataitem(SeminarSetup; "Seminar Setup ASD")
        {
            DataItemTableView = sorting("Primary Key");

            trigger OnPreDataItem();
            begin
                SeminarSetup.DeleteAll()
            end;
        }
        dataitem(NoSeries; "No. Series")
        {
            DataItemTableView = sorting(Code);

            trigger OnPreDataItem();
            var
                UtilsSeminarDDT: Codeunit UtilsSeminarDDTASD;
            begin
                if RemoveNoSeries then begin
                    NoSeries.SetFilter(
                        Code,
                        '%1|%2|%3',
                        UtilsSeminarDDT.GetSeminarNoSeriesCode(),
                        UtilsSeminarDDT.GetSeminarRegNoSeriesCode(),
                        UtilsSeminarDDT.GetPstdSeminarRegNoSeriesCode());
                    NoSeries.DeleteAll(true);
                end;
            end;
        }
        dataitem(CommentLine; "Comment Line")
        {
            DataItemTableView = sorting("Table Name") where("Table Name" = const(Seminar));

            trigger OnPreDataItem();
            begin
                CommentLine.DeleteAll()
            end;
        }
        // ASD3.03<
        dataitem(SeminarRegistrationHeader; "Sem. Registration Header ASD")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem();
            begin
                SeminarRegistrationHeader.DeleteAll() // No call to table trigger as this can block deletion
            end;
        }
        dataitem(SeminarRegistrationLine; "Seminar Registration Line ASD")
        {
            DataItemTableView = sorting("Document No.");

            trigger OnPreDataItem();
            begin
                SeminarRegistrationLine.DeleteAll()
            end;
        }
        dataitem(SeminarCommentLine; "Seminar Comment Line ASD")
        {
            DataItemTableView = sorting("Document Type");

            trigger OnPreDataItem();
            begin
                SeminarCommentLine.DeleteAll()
            end;
        }
        dataitem(SeminarCharge; "Seminar Charge ASD")
        {
            DataItemTableView = sorting("Document No.");

            trigger OnPreDataItem();
            begin
                SeminarCharge.DeleteAll()
            end;
        }
        // dataitem(Resource; Resource)
        // {
        //      Resources cannot be removed once postings have been done
        // }
        // ASD3.03>
        // ASD4.07<
        dataitem(PostedSeminarRegHeader; "Posted Sem. Reg. Header ASD")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem();
            begin
                PostedSeminarRegHeader.DeleteAll()
            end;
        }
        dataitem(PostedSeminarRegLine; "Posted Sem. Reg. Line ASD")
        {
            DataItemTableView = sorting("Document No.");

            trigger OnPreDataItem();
            begin
                PostedSeminarRegLine.DeleteAll()
            end;
        }
        dataitem(PostedSeminarCharge; "Posted Seminar Charge ASD")
        {
            DataItemTableView = sorting("Document No.");

            trigger OnPreDataItem();
            begin
                PostedSeminarCharge.DeleteAll()
            end;
        }
        dataitem(SeminarJournalLine; "Seminar Journal Line ASD")
        {
            DataItemTableView = sorting("Journal Template Name");

            trigger OnPreDataItem();
            begin
                SeminarJournalLine.DeleteAll()
            end;
        }
        dataitem(SeminarLedgerEntry; "Seminar Ledger Entry ASD")
        {
            DataItemTableView = sorting("Entry No.");

            trigger OnPreDataItem();
            begin
                SeminarLedgerEntry.DeleteAll()
            end;
        }
        dataitem(SeminarRegister; "Seminar Register ASD")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem();
            begin
                SeminarRegister.DeleteAll()
            end;
        }
        dataitem(SourceCodeSetup; "Source Code Setup")
        {
            DataItemTableView = sorting("Primary Key");

            trigger OnAfterGetRecord();
            begin
                SourceCodeSetup."Seminar ASD" := '';
                SourceCodeSetup.Modify();
            end;
        }
        dataitem(SourceCode; "Source Code")
        {
            DataItemTableView = sorting(Code);

            trigger OnPreDataItem();
            var
                UtilsSeminarDDT: Codeunit UtilsSeminarDDTASD;
            begin
                if RemoveSourceCode then begin
                    SourceCode.SetFilter(
                        Code,
                        '%1',
                        UtilsSeminarDDT.GetSeminarSourceCode());
                    SourceCode.DeleteAll(true);
                end;
            end;
        }
        // ASD4.07>
        // ASD6.04<
        dataitem(SeminarReportSelections; "Seminar Report Selections ASD")
        {
            DataItemTableView = sorting(Usage, Sequence);

            trigger OnPreDataItem();
            begin
                SeminarReportSelections.DeleteAll()
            end;
        }
        // ASD6.04>
        // ASD9.03<
        dataitem(MySeminar; "My Seminar ASD")
        {
            DataItemTableView = sorting("User ID", "Seminar No.");

            trigger OnPreDataItem();
            begin
                MySeminar.DeleteAll()
            end;
        }
        // ASD9.03>
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(RemoveNoSeries; RemoveNoSeries)
                    {
                        Caption = 'Remove Seminar No. Series';
                        Tooltip = 'Specifies whether the seminar No. Series wil be removed.';
                    }
                    // ASD4.07<
                    field(RemoveSourceCode; RemoveSourceCode)
                    {
                        Caption = 'Remove Seminar Source Code';
                        Tooltip = 'Specifies whether the seminar Source Code wil be removed.';
                    }
                    // ASD4.07>
                }
            }
        }
    }
    trigger OnInitReport();
    begin
        RemoveNoSeries := true;
        // ASD4.07<
        RemoveSourceCode := true;
        // ASD4.07>
    end;

    var
        RemoveNoSeries: Boolean;
        // ASD4.07<
        RemoveSourceCode: Boolean;
    // ASD4.07>
}