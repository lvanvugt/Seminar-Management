codeunit 123456794 "CreateSeminarDimensionsDDTASD"
{
    trigger OnRun()
    begin
        SetSeminarDimensions();
        UpdateSeminarRegistrationDimensions();
    end;

    local procedure SetSeminarDimensions();
    var
        Seminar: Record "Seminar ASD";
    begin
        if Seminar.FindSet() then
            repeat
                SetSeminarDimension(Seminar, 1);
                SetSeminarDimension(Seminar, 2);
            until Seminar.Next() = 0;
    end;

    local procedure SetSeminarDimension(var Seminar: Record "Seminar ASD"; GlobalDimensionCodeNo: Integer);
    begin
        case GlobalDimensionCodeNo of
            1:
                Seminar.Validate("Global Dimension 1 Code", GetGlobalDimensionCodeValue(1));
            2:
                Seminar.Validate("Global Dimension 2 Code", GetGlobalDimensionCodeValue(2));
        end
    end;

    local procedure GetGlobalDimensionCodeValue(GlobalDimensionCodeNo: Integer): Code[20]
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.SetRange("Dimension Code", GetGlobalDimensionCode(GlobalDimensionCodeNo));
        if DimensionValue.FindFirst() then
            exit(DimensionValue.Code);
    end;

    local procedure GetGlobalDimensionCode(GlobalDimensionCodeNo: Integer): Code[20]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();

        case GlobalDimensionCodeNo of
            1:
                exit(GeneralLedgerSetup."Global Dimension 1 Code");
            2:
                exit(GeneralLedgerSetup."Global Dimension 2 Code");
        end;
    end;

    local procedure UpdateSeminarRegistrationDimensions();
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        if SeminarRegistrationHeader.FindSet() then
            repeat
                SeminarRegistrationHeader.SetHideValidationDialog(true);
                SeminarRegistrationHeader.Validate("Seminar No.");
                UpdateSeminarRegistrationLineDimensions(SeminarRegistrationHeader."No.");
            until SeminarRegistrationHeader.Next() = 0
    end;

    local procedure UpdateSeminarRegistrationLineDimensions(DocumentNo: Code[20]);
    var
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
    begin
        SeminarRegistrationLine.SetRange("Document No.", DocumentNo);
        if SeminarRegistrationLine.FindSet() then
            repeat
                SeminarRegistrationLine.Validate("Bill-to Customer No.");
                SeminarRegistrationLine.Modify();
            until SeminarRegistrationLine.Next() = 0;
    end;
}