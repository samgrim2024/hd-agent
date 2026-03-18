@JsonAccess(serializable='always' deserializable='always')
global class HDTicketIntakeData {

    @AuraEnabled
    global String businessUnit;

    @AuraEnabled
    global String ticketType;

    @AuraEnabled
    global String freeText;

    @AuraEnabled
    global String subject;

    @AuraEnabled
    global String linkToRecord;

    @AuraEnabled
    global String expectedBehaviour;

    @AuraEnabled
    global String stepsToReproduce;
}
