codeunit 123456703 "Sem. Registration Printed ASD"
{
    TableNo = "Sem. Registration Header ASD";

    trigger OnRun();
    begin
        Rec.FindFirst();
        Rec."No. Printed" := Rec."No. Printed" + 1;
        Rec.Modify();
        Commit();
    end;
}