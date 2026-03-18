@JsonAccess(serializable='always' deserializable='always')
global class HDTicketConfirmData {

    @AuraEnabled
    global String ticketId;

    @AuraEnabled
    global String ticketNumber;

    @AuraEnabled
    global String ticketUrl;

    @AuraEnabled
    global String subject;

    @AuraEnabled
    global String businessUnit;

    @AuraEnabled
    global String ticketType;

    @AuraEnabled
    global String status;
}
