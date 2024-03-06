codeunit 123456706 "Default Dimension - Events ASD"
{
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure OnAfterUpdateGlobalDimCode(GlobalDimCodeNo: Integer; TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        case TableID of
            Database::"Seminar ASD":
                DefaultDimension.UpdateSeminarGlobalDimCode(GlobalDimCodeNo, AccNo, NewDimValue);
        end;
    end;
}