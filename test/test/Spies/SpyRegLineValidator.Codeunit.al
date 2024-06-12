codeunit 123456744 "SpyRegLineValidator" implements IRegistrationLineValidator
{
    var
        _visited: Boolean;

    procedure GetVisited(): Boolean
    begin
        exit(_visited);
    end;

    procedure VerifyRegLineForPosting(IRegistrationLine_ASD: Interface IRegistrationLine_ASD)
    begin
        _visited := true;
    end;
}
