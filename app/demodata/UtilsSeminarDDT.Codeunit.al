codeunit 123456799 "UtilsSeminarDDTASD"
{
    // ASD3.03 - 2018-08-15 D.E. Veloper - Chapter 3: Lab 3 - Seminar Registration
    // ASD4.07 - 2018-08-15 D.E. Veloper - Chapter 4: Lab 7 - Posting related

    var
        SeminarTxt: Label 'Seminar';
        SeminarRegistrationTxt: Label 'Seminar Registration';
        PstdSeminarRegistrationTxt: Label 'Posted Seminar Registration';
        // ASD3.03<
        InstructorTxt: Label 'Luc van Vugt';
        RoomTxt: Label 'Room End';
    // ASD3.03>

    procedure GetSeminarNoSeriesCode(): Code[20];
    begin
        exit('SEM')
    end;

    procedure GetSeminarNoSeriesName(): Text[100];
    begin
        exit(SeminarTxt)
    end;

    procedure GetSeminarRegNoSeriesCode(): Code[20];
    begin
        exit('SEMREG')
    end;

    procedure GetSeminarRegNoSeriesName(): Text[100];
    begin
        exit(SeminarRegistrationTxt)
    end;

    procedure GetPstdSeminarRegNoSeriesCode(): Code[20];
    begin
        exit('PSEMREG')
    end;

    procedure GetPstdSeminarRegNoSeriesName(): Text[100];
    begin
        exit(PstdSeminarRegistrationTxt)
    end;

    procedure GetGenProdPostingGroup(): Code[20];
    var
        GenProdPostingGroup: Record "Gen. Product Posting Group";
    begin
        if GenProdPostingGroup.FindFirst() then;
        exit(GenProdPostingGroup.Code);
    end;

    procedure GetVATProdPostingGroup(): Code[20];
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        if VATProductPostingGroup.FindFirst() then;
        exit(VATProductPostingGroup.Code);
    end;

    // ASD3.03<
    procedure GetInstructorResourceNo(): Code[20];
    begin
        exit('LUC')
    end;

    procedure GetInstructorResourceName(): Text[100];
    begin
        exit(InstructorTxt)
    end;

    procedure GetRoomResourceNo(): Code[20];
    begin
        exit('ROOM END')
    end;

    procedure GetRoomResourceName(): Text[100];
    begin
        exit(RoomTxt)
    end;
    // ASD3.03>

    // ASD4.07<
    procedure GetSeminarSourceCode(): Code[20];
    begin
        exit(SeminarTxt)
    end;
    // ASD4.07>
}