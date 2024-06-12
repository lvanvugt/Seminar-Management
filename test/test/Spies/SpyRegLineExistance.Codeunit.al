codeunit 123456746 "SpyRegLineExistance" implements IRegistrationLineExistance
{
    var
        _visited: Boolean;

    procedure GetVisited(): Boolean
    begin
        exit(_visited);
    end;

    procedure HandleLinesExist(IsEmpty: Boolean)
    begin
        _visited := true;
    end;
}
