#if solidComponent
codeunit 123456744 "SpyRegLineValidator" implements IRegistrationLineValidator
{
    var
        _visited: Boolean;

    procedure GetVisited(): Boolean
    begin
        exit(_visited);
    end;

    procedure VerifyRegLineForPosting(var SeminarRegistrationLine: Record "Seminar Registration Line ASD")
    begin
        _visited := true;
    end;
}
#endif