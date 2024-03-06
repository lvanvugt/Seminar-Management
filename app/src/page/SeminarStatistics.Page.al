page 123456714 "Seminar Statistics ASD"
{
    Caption = 'Seminar Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Seminar ASD";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;

                fixed(FixedLayout)
                {
                    group(ThisPeriod)
                    {
                        Caption = 'This Period';
                        field(SeminarDateName1; SeminarDateName[1])
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                        field("TotalPrice[1]"; TotalPrice[1])
                        {
                            Caption = 'Total Price';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total seminar turnover in the current fiscal period.';
                        }
                        field("TotalPriceNotChargeable[1]"; TotalPriceNotChargeable[1])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total non-chargeable seminar turnover in the current fiscal period.';
                        }
                        field("TotalPriceChargeable[1]"; TotalPriceChargeable[1])
                        {
                            Caption = 'Total Price (Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total chargeable seminar turnover in the current fiscal period.';
                        }
                    }
                    group(ThisYear)
                    {
                        Caption = 'This Year';
                        field("SeminarDateName[2]"; SeminarDateName[2])
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("TotalPrice[2]"; TotalPrice[2])
                        {
                            Caption = 'Total Price';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total seminar turnover in the current fiscal year.';
                        }
                        field("TotalPriceNotChargeable[2]"; TotalPriceNotChargeable[2])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total non-chargeable seminar turnover in the current fiscal year.';
                        }
                        field("TotalPriceChargeable[2]"; TotalPriceChargeable[2])
                        {
                            Caption = 'Total Price (Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total chargeable seminar turnover in the current fiscal year.';
                        }
                    }
                    group(LastYear)
                    {
                        Caption = 'Last Year';
                        field("SeminarDateName[3]"; SeminarDateName[3])
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("TotalPrice[3]"; TotalPrice[3])
                        {
                            Caption = 'Total Price';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total seminar turnover in the previous fiscal year.';
                        }
                        field("TotalPriceNotChargeable[3]"; TotalPriceNotChargeable[3])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total non-chargeable seminar turnover in the previous fiscal year.';
                        }
                        field("TotalPriceChargeable[3]"; TotalPriceChargeable[3])
                        {
                            Caption = 'Total Price (Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total chargeable seminar turnover in the previous fiscal year.';
                        }
                    }
                    group(ToDate)
                    {
                        Caption = 'To Date';
                        field("SeminarDateName[4]"; SeminarDateName[4])
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("TotalPrice[4]"; TotalPrice[4])
                        {
                            Caption = 'Total Price';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total seminar turnover.';
                        }
                        field("TotalPriceNotChargeable[4]"; TotalPriceNotChargeable[4])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total non-chargeable seminar turnover.';
                        }
                        field("TotalPriceChargeable[4]"; TotalPriceChargeable[4])
                        {
                            Caption = 'Total Price (Chargeable)';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total chargeable seminar turnover.';
                        }
                    }
                }
            }
        }
    }

    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SeminarDateFilter: array[4] of Text[30];
        SeminarDateName: array[4] of Text[30];
        CurrentDate: Date;
        TotalPrice: array[4] of Decimal;
        TotalPriceNotChargeable: array[4] of Decimal;
        TotalPriceChargeable: array[4] of Decimal;
        i: Integer;

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("No.", Rec."No.");
        if CurrentDate <> WorkDate() then begin
            CurrentDate := WorkDate();
            DateFilterCalc.CreateAccountingPeriodFilter(SeminarDateFilter[1], SeminarDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[2], SeminarDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[3], SeminarDateName[3], CurrentDate, -1);
        end;

        for i := 1 to 4 do begin
            Rec.SetFilter("Date Filter", SeminarDateFilter[i]);
            Rec.CalcFields("Total Price", "Total Price (Not Chargeable)", "Total Price (Chargeable)");
            TotalPrice[i] := Rec."Total Price";
            TotalPriceNotChargeable[i] := Rec."Total Price (Not Chargeable)";
            TotalPriceChargeable[i] := Rec."Total Price (Chargeable)";
        end;
        Rec.SetRange("Date Filter", 0D, CurrentDate);
    end;
}