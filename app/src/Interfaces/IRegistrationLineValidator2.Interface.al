#if solidComponent
Interface IRegistrationLineValidator
{
    procedure VerifyRegLineForPosting(var SeminarRegistrationLine: Record "Seminar Registration Line ASD");
}
#endif