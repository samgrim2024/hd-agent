public with sharing class HDTicketResponse {

    @InvocableVariable(label='Ticket ID')
    public String ticketId;

    @InvocableVariable(label='Ticket Number')
    public String ticketNumber;

    @InvocableVariable(label='Ticket URL')
    public String ticketUrl;

    @InvocableVariable(label='Subject')
    public String subject;

    @InvocableVariable(label='Business Unit')
    public String businessUnit;

    @InvocableVariable(label='Ticket Type')
    public String ticketType;

    @InvocableVariable(label='Status')
    public String status;

    @InvocableVariable(label='Description')
    public String description;

    @InvocableVariable(label='Success')
    public Boolean success;

    @InvocableVariable(label='Error Message')
    public String errorMessage;
}
