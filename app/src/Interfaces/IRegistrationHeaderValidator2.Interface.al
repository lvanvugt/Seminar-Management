#if solid_component
Interface IRegistrationHeaderValidator
{
    procedure CheckMandatoryHeaderFields(var SeminarRegistrationHeader2: Record "Sem. Registration Header ASD");
}
#endif