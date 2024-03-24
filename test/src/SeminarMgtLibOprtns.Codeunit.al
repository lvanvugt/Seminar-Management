codeunit 123456772 "Seminar Mgt. Lib. Oprtns. ASD"
{
    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryMarketing: Codeunit "Library - Marketing";

    procedure CreateSeminarRegistration(var SeminarRegistrationHeader: Record "Sem. Registration Header ASD")
    begin
        SeminarRegistrationHeader.Insert(true);
    end;

    procedure CreateSeminarRegistrationNo(): Code[20]
    var
        SeminarRegistrationHeader: Record "Sem. Registration Header ASD";
    begin
        CreateSeminarRegistration(SeminarRegistrationHeader);
        exit(SeminarRegistrationHeader."No.");
    end;

    procedure CreateSeminarRegistrationLine(var SeminarRegistrationLine: Record "Seminar Registration Line ASD"; SeminarRegistrationNo: Code[20]; CustomerNo: Code[20]; ParticipantNo: Code[20])
    begin
        SeminarRegistrationLine.SetRange("Document No.", SeminarRegistrationNo);

        if not SeminarRegistrationLine.FindLast() then
            SeminarRegistrationLine."Document No." := SeminarRegistrationNo;

        SeminarRegistrationLine.Init();
        SeminarRegistrationLine."Line No." := SeminarRegistrationLine."Line No." + 10000;

        SeminarRegistrationLine.Validate("Bill-to Customer No.", CustomerNo);
        SeminarRegistrationLine.Validate("Participant Contact No.", ParticipantNo);

        SeminarRegistrationLine.Validate("Line Discount %", LibraryRandom.RandInt(25));
        SeminarRegistrationLine.Insert(true);
    end;

    procedure CreatePersonContactWithCompany(CompanyNo: Code[20]): Code[20]
    var
        Contact: Record Contact;
    begin
        LibraryMarketing.CreatePersonContact(Contact);
        Contact.Validate("Company No.", CompanyNo);
        Contact.Modify(true);
        exit(Contact."No.");
    end;
}