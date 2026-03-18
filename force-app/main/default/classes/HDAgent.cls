public with sharing class HDAgent {

    @InvocableMethod(label='HD Agent - Create Ticket'
                     description='Creates a new Help Desk ticket from agent conversation input. Use when the user wants to raise a ticket, report a bug, request a feature, or log any support request.')
    public static List<HDTicketResponse> createTicket(List<HDTicketRequest> requests) {
        List<HDTicketResponse> responses = new List<HDTicketResponse>();

        for (HDTicketRequest req : requests) {
            HDTicketResponse res = new HDTicketResponse();

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

    private static String buildDescription(HDTicketRequest req) {
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

        if (String.isNotBlank(req.freeText)) {
            parts.add('Additional Detail: ' + req.freeText.trim());
        }

        if (String.isNotBlank(req.linkToRecord)) {
            parts.add('Link to record: ' + req.linkToRecord.trim());
        }

        return String.join(parts, '\n\n');
    }
}
