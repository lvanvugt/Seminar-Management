codeunit 123456743 "SpyRegHeaderValidator" implements IRegistrationHeaderValidator
{
    var
        _visited: Boolean;

    procedure CheckMandatoryHeaderFields(IRegistrationHeader_ASD: Interface IRegistrationHeader_ASD)
    begin
        _visited := true;
    end;

    procedure GetVisited(): Boolean
    begin
        exit(_visited);
    end;
}