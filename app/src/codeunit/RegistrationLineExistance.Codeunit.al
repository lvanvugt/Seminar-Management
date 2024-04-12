codeunit 123456713 RegistrationLineExistance implements IRegistrationLineExistance
{

    procedure HandleLinesExist(IsEmpty: Boolean)
    var
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        if IsEmpty then
            Error(NothingToPostErr);
    end;

}