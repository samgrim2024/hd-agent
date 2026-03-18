global class HDAgent {

    @InvocableMethod(label='HD Agent - Create Ticket'
                     description='Creates a new Help Desk ticket from agent conversation input.')
    global static List<HDTicketResponse> createTicket(List<HDTicketRequest> requests) {
        List<HDTicketResponse> responses = new List<HDTicketResponse>();

        for (HDTicketRequest req : requests) {
            HDTicketResponse res = new HDTicketResponse();

            try {
                String businessUnit = req.intakeData != null ? req.intakeData.businessUnit : '';
                String ticketType = req.intakeData != null ? req.intakeData.ticketType : 'Other';
                String freeText = req.intakeData != null ? req.intakeData.freeText : '';
                String subject = req.intakeData != null ? req.intakeData.subject : '';
                String expectedBehaviour = req.intakeData != null ? req.intakeData.expectedBehaviour : '';
                String stepsToReproduce = req.intakeData != null ? req.intakeData.stepsToReproduce : '';
                String linkToRecord = req.intakeData != null ? req.intakeData.linkToRecord : '';

                String fullDescription = buildDescription(expectedBehaviour, stepsToReproduce, freeText, linkToRecord);

                Help_Desk__c ticket = new Help_Desk__c();
                ticket.Subject__c = subject;
                ticket.Business_Unit__c = businessUnit;
                ticket.Type__c = ticketType;
                ticket.Status__c = 'Not Started';
                ticket.Description__c = fullDescription;
                ticket.Integration_description__c = fullDescription;

                insert ticket;

                Help_Desk__c created = [
                    SELECT Id, Name, Subject__c, Business_Unit__c, Type__c,
                           Status__c, Description__c
                    FROM Help_Desk__c
                    WHERE Id = :ticket.Id
                    LIMIT 1
                ];

                String baseUrl = URL.getOrgDomainURL().toExternalForm().replace('.my.salesforce.com', '.lightning.force.com');

                HDTicketConfirmData confirm = new HDTicketConfirmData();
                confirm.ticketId = created.Id;
                confirm.ticketNumber = created.Name;
                confirm.ticketUrl = baseUrl + '/lightning/r/Help_Desk__c/' + created.Id + '/view';
                confirm.subject = created.Subject__c;
                confirm.businessUnit = created.Business_Unit__c;
                confirm.ticketType = created.Type__c;
                confirm.status = created.Status__c;

                res.confirmData = confirm;
                res.success = true;

            } catch (Exception e) {
                res.success = false;
                res.errorMessage = e.getMessage();
            }

            responses.add(res);
        }

        return responses;
    }

    private static String buildDescription(String expectedBehaviour, String stepsToReproduce, String freeText, String linkToRecord) {
        List<String> parts = new List<String>();

        if (String.isNotBlank(expectedBehaviour)) {
            parts.add('Expected Behaviour: ' + expectedBehaviour.trim());
        }
        if (String.isNotBlank(stepsToReproduce)) {
            parts.add('Steps to Reproduce: ' + stepsToReproduce.trim());
        }
        if (String.isNotBlank(freeText)) {
            parts.add('Additional Detail: ' + freeText.trim());
        }
        if (String.isNotBlank(linkToRecord)) {
            parts.add('Link to record: ' + linkToRecord.trim());
        }

        return String.join(parts, '\n\n');
    }
}
