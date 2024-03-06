profile "Seminar Manager ASD"
{
    Description = 'Seminar Manager';
    Caption = 'Seminar Manager';
    RoleCenter = "Seminar Manager RC ASD";
    Customizations = "My Dummy Customization ASD";
}

pagecustomization "My Dummy Customization ASD" customizes "Customer List" //22
{
    // This is a dummy pagecustomization as the Customizations property of the profile object needs to be provided
}