codeunit 123456710 "Notifications ASD"
{
    local procedure SendOrRecallCreditLimitNotification(var Rec: Record "Seminar Registration Line ASD")
    var
        Customer: Record Customer;
    begin
        if Rec."Bill-to Customer No." = '' then
            exit;

        Customer.Get(Rec."Bill-to Customer No.");
        if Customer."Credit Limit (LCY)" = 0 then
            exit;

        if not IsCreditLimitNotificationEnabled(Customer) then
            exit;

        Customer.CalcFields("Balance (LCY)");
        if Rec.Amount > Customer."Credit Limit (LCY)" - Customer."Balance (LCY)" then
            SendCreditLimitNotification(Customer)
        else
            RecallCreditLimitNotification();
    end;

    local procedure SendCreditLimitNotification(Customer: Record Customer)
    var
        CreditLimitNotification: Notification;
    begin
        CreditLimitNotification.Id := NotificationId();
        CreditLimitNotification.Message := CreditLimitNotificationMsg;
        CreditLimitNotification.Scope := NotificationScope::LocalScope;
        CreditLimitNotification.SetData('CustomerNo', Customer."No.");
        CreditLimitNotification.AddAction(AdjustCreditLimitTxt, Codeunit::"Notifications ASD", 'OpenCustomer');
        CreditLimitNotification.AddAction(DontShowAgainTxt, Codeunit::"Notifications ASD", 'DeactivateNotification');
        CreditLimitNotification.Send();
    end;

    local procedure RecallCreditLimitNotification()
    var
        CreditLimitNotification: Notification;
    begin
        CreditLimitNotification.Id := NotificationId();
        CreditLimitNotification.Recall();
    end;

    procedure OpenCustomer(ThisNotification: Notification);
    var
        Customer: Record Customer;
    begin
        Customer.Get(ThisNotification.GetData('CustomerNo'));
        Page.RunModal(Page::"Customer Card", Customer);
    end;

    procedure DeactivateNotification(SetupNotification: Notification)
    var
        MyNotifications: Record "My Notifications";
    begin
        // Insert notification in case the My Notifications page has not been opened yet
        OnInitializingNotificationWithDefaultState();

        MyNotifications.Disable(NotificationId())
    end;

    local procedure NotificationId(): Guid;
    begin
        exit('7784e771-2996-4291-a588-7fdcf02c5075');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Seminar Registration Line ASD", 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure CreditLimitNotificationOnAfterValidateBillToCustomerNo(var Rec: Record "Seminar Registration Line ASD"; var xRec: Record "Seminar Registration Line ASD"; CurrFieldNo: Integer)
    begin
        SendOrRecallCreditLimitNotification(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Seminar Registration Line ASD", 'OnAfterValidateEvent', 'Amount', false, false)]
    local procedure CreditLimitNotificationOnAfterValidateAmount(var Rec: Record "Seminar Registration Line ASD"; var xRec: Record "Seminar Registration Line ASD"; CurrFieldNo: Integer)
    begin
        SendOrRecallCreditLimitNotification(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Seminar Registration Line ASD", 'OnAfterValidateEvent', 'Price', false, false)]
    local procedure CreditLimitNotificationOnAfterValidatePrice(var Rec: Record "Seminar Registration Line ASD"; var xRec: Record "Seminar Registration Line ASD"; CurrFieldNo: Integer)
    begin
        SendOrRecallCreditLimitNotification(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Seminar Registration Line ASD", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure CreditLimitNotificationOnAfterValidateLineDiscountPerc(var Rec: Record "Seminar Registration Line ASD"; var xRec: Record "Seminar Registration Line ASD"; CurrFieldNo: Integer)
    begin
        SendOrRecallCreditLimitNotification(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Seminar Registration Line ASD", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    local procedure CreditLimitNotificationOnAfterValidateLineDiscountAmount(var Rec: Record "Seminar Registration Line ASD"; var xRec: Record "Seminar Registration Line ASD"; CurrFieldNo: Integer)
    begin
        SendOrRecallCreditLimitNotification(Rec);
    end;

    local procedure IsCreditLimitNotificationEnabled(Customer: Record Customer): Boolean
    var
        MyNotifications: Record "My Notifications";
    begin
        exit(MyNotifications.IsEnabledForRecord(NotificationId(), Customer));
    end;

    [EventSubscriber(ObjectType::Page, Page::"My Notifications", 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefaultWithTableNum(NotificationId(),
          CreditLimitNotificationMsg,
          CreditLimitNotificationDescriptionTxt,
          Database::Customer);
    end;

    var
        AdjustCreditLimitTxt: Label 'Adjust credit limit.';
        DontShowAgainTxt: Label 'Don''t show again';
        CreditLimitNotificationMsg: Label 'The customer''s credit limit has been exceeded. (Seminar Management)';
        CreditLimitNotificationDescriptionTxt: Label 'Show warning when a seminar registration will exceed the customer''s credit limit.';
}