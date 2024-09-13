#if solid_component
codeunit 123456743 "SpyRegHeaderValidator" implements IRegistrationHeaderValidator
{
    var
        _visited: Boolean;

    procedure GetVisited(): Boolean
    begin
        exit(_visited);
    end;

    procedure CheckMandatoryHeaderFields(var SeminarRegistrationHeader2: Record "Sem. Registration Header ASD")
    begin
        _visited := true;
    end;
}
#endif