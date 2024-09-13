#if solid_component
Interface IRegistrationLineValidator
{
    procedure VerifyRegLineForPosting(var SeminarRegistrationLine: Record "Seminar Registration Line ASD");
}
#endif