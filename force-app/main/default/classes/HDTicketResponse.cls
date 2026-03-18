@JsonAccess(serializable='always' deserializable='always')
global class HDTicketResponse {

    @InvocableVariable @AuraEnabled
    global HDTicketConfirmData confirmData;

    @InvocableVariable @AuraEnabled
    global Boolean success;

    @InvocableVariable @AuraEnabled
    global String errorMessage;
}
