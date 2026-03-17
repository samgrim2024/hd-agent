public with sharing class HDAgent {

    public class TicketRequest {
        @InvocableVariable(label='Business Unit' required=true
            description='The business unit this ticket relates to: Acquisition, Design, Build, Business Development, Operations, Management, HSSEQ, Stores & Logistics, External Contractor, Fixed Line, SPEN FSL - O&M')
        public String businessUnit;

        @InvocableVariable(label='Ticket Type' required=true
            description='The type of ticket: Bug/Error Report, New Feature/Functionality Request, Data Management, User Management, Reporting/Dashboards, SmartHOPs, Training Request, New Software Request, DNO/ICP Installation, Other')
        public String ticketType;

        @InvocableVariable(label='Subject' required=true
            description='A short summary of the issue or request')
        public String subject;

        @InvocableVariable(label='Expected Behaviour'
            description='What the user expected to happen (for bug reports)')
        public String expectedBehaviour;

        @InvocableVariable(label='Steps to Reproduce'
            description='Steps to reproduce the issue (for bug reports)')
        public String stepsToReproduce;

        @InvocableVariable(label='Link to Record'
            description='URL link to the Salesforce record related to this issue')
        public String linkToRecord;

        @InvocableVariable(label='Additional Detail'
            description='Any extra context or detail provided by the user')
        public String additionalDetail;
    }

    public class TicketResponse {
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

    @InvocableMethod(label='HD Agent - Create Ticket'
                     description='Creates a new Help Desk ticket from agent conversation input. Use when the user wants to raise a ticket, report a bug, request a feature, or log any support request.')
    public static List<TicketResponse> createTicket(List<TicketRequest> requests) {
        List<TicketResponse> responses = new List<TicketResponse>();

        for (TicketRequest req : requests) {
            TicketResponse res = new TicketResponse();

            try {
                String fullDescription = buildDescription(req);

                Help_Desk__c ticket = new Help_Desk__c();
                ticket.Subject__c = req.subject;
                ticket.Business_Unit__c = req.businessUnit;
                ticket.Type__c = req.ticketType;
                ticket.Status__c = 'Not Started';
                ticket.Description__c = fullDescription;
                ticket.Integration_description__c = fullDescription;

                insert ticket;

                Help_Desk__c created = [
                    SELECT Id, Name, Subject__c, Business_Unit__c, Type__c,
                           Status__c, Description__c, Ticket_URL__c
                    FROM Help_Desk__c
                    WHERE Id = :ticket.Id
                    LIMIT 1
                ];

                res.ticketId = created.Id;
                res.ticketNumber = created.Name;
                res.ticketUrl = created.Ticket_URL__c;
                res.subject = created.Subject__c;
                res.businessUnit = created.Business_Unit__c;
                res.ticketType = created.Type__c;
                res.status = created.Status__c;
                res.description = created.Description__c;
                res.success = true;

            } catch (Exception e) {
                res.success = false;
                res.errorMessage = e.getMessage();
            }

            responses.add(res);
        }

        return responses;
    }

    private static String buildDescription(TicketRequest req) {
        List<String> parts = new List<String>();

        if (String.isNotBlank(req.expectedBehaviour)) {
            parts.add('Expected Behaviour: ' + req.expectedBehaviour.trim());
        }

        if (String.isNotBlank(req.stepsToReproduce)) {
            parts.add('Steps to Reproduce: ' + req.stepsToReproduce.trim());
        }

        if (String.isNotBlank(req.additionalDetail)) {
            parts.add('Additional Detail: ' + req.additionalDetail.trim());
        }

        if (String.isNotBlank(req.linkToRecord)) {
            parts.add('Link to record: ' + req.linkToRecord.trim());
        }

        return String.join(parts, '\n\n');
    }
}