tableextension 123456704 "Default Dimension Ext ASD" extends "Default Dimension" //352
{
    procedure UpdateSeminarGlobalDimCode(GlobalDimCodeNo: Integer; SeminarNo: Code[20]; NewDimValue: Code[20])
    var
        Seminar: Record "Seminar ASD";
    begin
        if Seminar.Get(SeminarNo) then begin
            case GlobalDimCodeNo of
                1:
                    Seminar."Global Dimension 1 Code" := NewDimValue;
                2:
                    Seminar."Global Dimension 2 Code" := NewDimValue;
            end;
            Seminar.Modify(true);
        end;
    end;
}