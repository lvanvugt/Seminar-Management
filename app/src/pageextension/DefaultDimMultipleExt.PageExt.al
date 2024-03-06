pageextension 123456704 "Default Dim.-Multiple Ext ASD" extends "Default Dimensions-Multiple" //542
{
    procedure SetMultiSeminar(var Seminar: Record "Seminar ASD");
    begin
        ClearTempDefaultDim();
        if Seminar.Find('-') then
            repeat
                CopyDefaultDimToDefaultDim(Database::"Seminar ASD", Seminar."No.");
            until Seminar.Next() = 0;
    end;
}