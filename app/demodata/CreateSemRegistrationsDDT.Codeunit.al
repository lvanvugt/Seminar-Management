codeunit 123456791 "CreateSemRegistrationsDDTASD"
{
    trigger OnRun();
    var
        Seminar: Record "Seminar ASD";
    begin
        if Seminar.FindSet() then
            repeat
                CreateSeminarRegistration(Seminar."No.");
            until Seminar.Next() = 0
    end;

    local procedure CreateSeminarRegistration(NewSeminarNo: Code[20]);
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
        UtilsSeminarDDT: Codeunit UtilsSeminarDDTASD;
        i: Integer;
        N: Integer;
    begin
        SeminarRegistrationHeader.Init();
        SeminarRegistrationHeader.InitRecord;
        SeminarRegistrationHeader."Starting Date" := WorkDate() + Random(365) - 270;
        SeminarRegistrationHeader.Status := Random(4) - 1;
        SeminarRegistrationHeader.Validate("Seminar No.", NewSeminarNo);
        SeminarRegistrationHeader."Instructor Resource No." :=
                CreateInstructor(
                    UtilsSeminarDDT.GetInstructorResourceNo(),
                    UtilsSeminarDDT.GetInstructorResourceName(),
                    UtilsSeminarDDT.GetGenProdPostingGroup(),
                    UtilsSeminarDDT.GetVATProdPostingGroup());
        SeminarRegistrationHeader.Validate(
                    "Room Resource No.",
                    CreateRoom(
                        UtilsSeminarDDT.GetRoomResourceNo(),
                        UtilsSeminarDDT.GetRoomResourceName(),
                        'Chappel Road',
                        'Endless Room',
                        'LR62 4DM',
                        'Somewhereshire',
                        'GB',
                        UtilsSeminarDDT.GetGenProdPostingGroup()));
        SeminarRegistrationHeader.Insert(true);
        SeminarRegistrationHeader."Posting Date" := SeminarRegistrationHeader."Starting Date" + Random(10) + 5;
        SeminarRegistrationHeader."Document Date" := SeminarRegistrationHeader."Posting Date";
        SeminarRegistrationHeader.Modify();

        N := Random(5);
        if N <= 5 then begin
            CreateSeminarRegLine(SeminarRegistrationHeader."No.", '01445544');
            CreateSeminarCharges(SeminarRegistrationHeader."No.", '01445544');
        end;
        if N <= 4 then begin
            CreateSeminarRegLine(SeminarRegistrationHeader."No.", '10000');
            CreateSeminarCharges(SeminarRegistrationHeader."No.", '10000');
        end;
        if N <= 3 then begin
            CreateSeminarRegLine(SeminarRegistrationHeader."No.", '01121212');
            CreateSeminarCharges(SeminarRegistrationHeader."No.", '01121212');
        end;
        if N <= 2 then begin
            CreateSeminarRegLine(SeminarRegistrationHeader."No.", '30000');
            CreateSeminarCharges(SeminarRegistrationHeader."No.", '30000');
        end;
        if N <= 1 then begin
            CreateSeminarRegLine(SeminarRegistrationHeader."No.", '01454545');
            CreateSeminarCharges(SeminarRegistrationHeader."No.", '01454545');
        end;

        N := Random(3);
        for i := 1 to N do
            CreateSeminarRegComment(SeminarRegistrationHeader."No.");
    end;

    local procedure CreateSeminarRegLine(NewSeminarRegNo: Code[20]; NewCustomerNo: Code[20]);
    var
        SeminarRegistrationLine: Record "Seminar Registration Line ASD";
    begin
        SeminarRegistrationLine.SetRange("Document No.", NewSeminarRegNo);

        if not SeminarRegistrationLine.FindLast() then
            SeminarRegistrationLine."Document No." := NewSeminarRegNo;

        SeminarRegistrationLine.Init();
        SeminarRegistrationLine."Line No." := SeminarRegistrationLine."Line No." + 10000;
        SeminarRegistrationLine.Validate("Bill-to Customer No.", NewCustomerNo);
        SeminarRegistrationLine.Validate("Line Discount %", Random(25));
        SeminarRegistrationLine.Validate("Participant Contact No.", GetCustomerLastContact(NewCustomerNo));
        SeminarRegistrationLine.Insert(true)
    end;

    local procedure CreateSeminarRegComment(NewSeminarRegNo: Code[20]);
    var
        SeminarCommentLine: Record "Seminar Comment Line ASD";
    begin
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", NewSeminarRegNo);

        if not SeminarCommentLine.FindLast() then
            SeminarCommentLine."Document Type" := SeminarCommentLine."Document Type"::"Seminar Registration";

        SeminarCommentLine.Init();
        SeminarCommentLine."No." := NewSeminarRegNo;
        SeminarCommentLine."Line No." := SeminarCommentLine."Line No." + 10000;
        SeminarCommentLine."Date" := WorkDate();
        SeminarCommentLine.Comment := CopyStr(StrSubstNo('%1 %2 - %3', 'Comment', SeminarCommentLine."Line No.", CurrentDateTime()), 1, MaxStrLen(SeminarCommentLine.Comment));
        SeminarCommentLine.Insert();
    end;

    local procedure CreateSeminarCharges(NewSeminarRegNo: Code[20]; NewCustomerNo: Code[20]);
    var
        SeminarCharge: Record "Seminar Charge ASD";
    begin
        SeminarCharge.SetRange("Document No.", NewSeminarRegNo);

        if not SeminarCharge.FindLast() then
            SeminarCharge."Document No." := NewSeminarRegNo;

        SeminarCharge.Init();
        SeminarCharge."Bill-to Customer No." := NewCustomerNo;

        SeminarCharge."Line No." := SeminarCharge."Line No." + 10000;
        SeminarCharge.Type := SeminarCharge.Type::"G/L Account";
        SeminarCharge.Validate("No.", '8130');
        SeminarCharge."Unit Price" := Random(150);
        SeminarCharge.Validate(Quantity, Random(3));
        SeminarCharge.Insert();

        SeminarCharge."Line No." := SeminarCharge."Line No." + 10000;
        SeminarCharge.Type := SeminarCharge.Type::Resource;
        SeminarCharge.Validate("No.", 'LIFT');
        SeminarCharge.Validate(Quantity, Random(3));
        SeminarCharge.Insert();
    end;

    local procedure CreateInstructor(NewNo: Code[20]; NewName: Text[100]; NewGenProdPostingGroup: Code[10]; NewVATProdPostingGroup: Code[10]): Code[20];
    var
        Resource: Record Resource;
    begin
        if not Resource.Get(NewNo) then begin
            Resource.Init();
            Resource."No." := NewNo;
            Resource.Validate(Name, NewName);
            Resource.Type := Resource.Type::Person;
            Resource."Quantity per Day ASD" := Random(100) + 1;
            Resource."Base Unit of Measure" := CreateResourceUOM(Resource."No.", CreateUOM('HOUR', 'Hour'));
            Resource.Validate("Gen. Prod. Posting Group", NewGenProdPostingGroup);
            Resource.Validate("VAT Prod. Posting Group", NewVATProdPostingGroup);
            Resource."Unit Price" := Random(100) + 1;
            Resource.Insert();
        end;
        exit(Resource."No.");
    end;

    local procedure CreateRoom(NewNo: Code[20]; NewName: Text[100]; NewAddress: Text[100]; NewCity: Text[100]; NewPostCode: Code[20]; NewCounty: Text[30]; NewCountryRegionCode: Code[10]; NewGenProdPostingGroup: Code[10]): Code[20];
    var
        Resource: Record Resource;
    begin
        if not Resource.Get(NewNo) then begin
            Resource.Init();
            Resource."No." := NewNo;
            Resource.Validate(Name, NewName);
            Resource.Type := Resource.Type::Room;
            Resource."Quantity per Day ASD" := Random(100);
            Resource."Base Unit of Measure" := CreateResourceUOM(Resource."No.", CreateUOM('DAY', 'Day'));
            Resource.Validate("Gen. Prod. Posting Group", NewGenProdPostingGroup);

            Resource.Address := NewAddress;
            Resource.City := NewCity;
            Resource."Post Code" := NewPostCode;
            Resource.County := NewCounty;
            Resource."Country/Region Code" := NewCountryRegionCode;

            Resource.Insert();
        end;
        exit(Resource."No.");
    end;

    local procedure CreateUOM(NewCode: Code[10]; NewDescription: Text[10]): Code[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(NewCode) then begin
            UnitOfMeasure.Code := NewCode;
            UnitOfMeasure.Description := NewDescription;
            UnitOfMeasure.Insert();
        end;
        exit(UnitOfMeasure.Code);
    end;

    local procedure CreateResourceUOM(NewResourceNo: Code[20]; NewUOMCode: Code[10]): Code[10];
    var
        ResourceUOM: Record "Resource Unit of Measure";
    begin
        if not ResourceUOM.Get(NewResourceNo, NewUOMCode) then begin
            ResourceUOM.Init();
            ResourceUOM."Resource No." := NewResourceNo;
            ResourceUOM.Code := NewUOMCode;
            ResourceUOM."Qty. per Unit of Measure" := 1;
            ResourceUOM."Related to Base Unit of Meas." := true;
            ResourceUOM.Insert();
        end;
        exit(ResourceUOM.Code);
    end;

    local procedure GetCustomerLastContact(NewCustomerNo: Code[20]): Code[20];
    var
        ContactBusRel: Record "Contact Business Relation";
        Contact: Record Contact;
    begin
        ContactBusRel.SetRange("Link to Table", ContactBusRel."Link to Table"::Customer);
        ContactBusRel.SetRange("No.", NewCustomerNo);
        if ContactBusRel.FindFirst() then begin
            Contact.SetRange("Company No.", ContactBusRel."Contact No.");
            if Contact.FindLast() then
                exit(Contact."No.");
        end;
        exit(ContactBusRel."Contact No.");
    end;
}