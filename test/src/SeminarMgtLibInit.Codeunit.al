codeunit 123456770 "Seminar Mgt. Lib. Init. ASD"
{
    var
        SeminarMgtLibrarySetup: Codeunit "Seminar Mgt. Lib. Setup ASD";

    procedure Initialize();
    begin
        SeminarMgtLibrarySetup.CreateSeminarSetup()
    end;
}
