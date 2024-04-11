Interface IRegistrationValidatorASD
{
    procedure CheckMandatoryHeaderFields(IRegistrationHeader_ASD: Interface IRegistrationHeader_ASD);
    procedure VerifyRegLineForPosting(IRegistrationLine_ASD: Interface IRegistrationLine_ASD);
    procedure HandleLinesExists(IsEmpty: Boolean);
}