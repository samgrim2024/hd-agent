public with sharing class HDTicketRequest {

    @InvocableVariable(label='Business Unit' required=true
        description='The business unit this ticket relates to')
    public String businessUnit;

    @InvocableVariable(label='Ticket Type' required=true
        description='The type of ticket')
    public String ticketType;

    @InvocableVariable(label='Subject' required=true
        description='A short summary of the issue or request')
    public String subject;

    @InvocableVariable(label='Expected Behaviour'
        description='What the user expected to happen')
    public String expectedBehaviour;

    @InvocableVariable(label='Steps to Reproduce'
        description='Steps to reproduce the issue')
    public String stepsToReproduce;

    @InvocableVariable(label='Link to Record'
        description='URL link to the Salesforce record related to this issue')
    public String linkToRecord;

    @InvocableVariable(label='Additional Detail'
        description='Any extra context or detail provided by the user')
    public String additionalDetail;

    @InvocableVariable(label='Free Text'
        description='Free text description when ticket type does not match a preset option')
    public String freeText;
}
