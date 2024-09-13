#if solid or solid_component
Interface IFactory
{
    procedure GetIRegistrationHeaderValidator(): Interface IRegistrationHeaderValidator;
    procedure GetIRegistrationLineValidator(): Interface IRegistrationLineValidator;
    procedure GetIRegistrationLineExistance(): Interface IRegistrationLineExistance;
}
#endif