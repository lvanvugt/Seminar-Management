codeunit 123456745 Factory implements IFactory
{
    var
        _IRegistrationHeaderValidator: Interface IRegistrationHeaderValidator;
        _IRegistrationLineValidator: Interface IRegistrationLineValidator;
        _IRegistrationLineExistance: Interface IRegistrationLineExistance;

    procedure GetIRegistrationHeaderValidator(): Interface IRegistrationHeaderValidator
    begin
        exit(_IRegistrationHeaderValidator);
    end;

    procedure SetIRegistrationHeaderValidator(RegistrationHeaderValidator: Interface IRegistrationHeaderValidator)
    begin
        _IRegistrationHeaderValidator := RegistrationHeaderValidator;
    end;

    procedure GetIRegistrationLineValidator(): Interface IRegistrationLineValidator
    begin
        exit(_IRegistrationLineValidator);
    end;

    procedure SetIRegistrationLineValidator(RegistrationLineValidator: Interface IRegistrationLineValidator)
    begin
        _IRegistrationLineValidator := RegistrationLineValidator;
    end;

    procedure GetIRegistrationLineExistance(): Interface IRegistrationLineExistance
    begin
        exit(_IRegistrationLineExistance);
    end;

    procedure SetIRegistrationLineExistance(RegistrationLineExistance: Interface IRegistrationLineExistance)
    begin
        _IRegistrationLineExistance := RegistrationLineExistance;
    end;
}