@isTest
private class HDAgentTest {

    @isTest
    static void testCreateTicket_BugReport() {
        HDAgent.TicketRequest req = new HDAgent.TicketRequest();
        req.businessUnit = 'Design';
        req.ticketType = 'Bug/Error Report';
        req.subject = 'Missing visibility of fields';
        req.expectedBehaviour = 'Should see In Period Revenue on finance review PS';
        req.stepsToReproduce = '1. Navigate to Commercial finance review PS\n2. Check field visibility';
        req.linkToRecord = 'https://example.salesforce.com/001xx000003ABCD';

        Test.startTest();
        List<HDAgent.TicketResponse> responses =
            HDAgent.createTicket(new List<HDAgent.TicketRequest>{ req });
        Test.stopTest();

        HDAgent.TicketResponse res = responses[0];
        System.assertEquals(true, res.success);
        System.assertNotEquals(null, res.ticketId);
        System.assertNotEquals(null, res.ticketNumber);
        System.assertEquals('Missing visibility of fields', res.subject);
        System.assertEquals('Design', res.businessUnit);
        System.assertEquals('Bug/Error Report', res.ticketType);
        System.assertEquals('Not Started', res.status);
    }

    @isTest
    static void testCreateTicket_NewFeature() {
        HDAgent.TicketRequest req = new HDAgent.TicketRequest();
        req.businessUnit = 'Build';
        req.ticketType = 'New Feature/Functionality Request';
        req.subject = 'Add bulk assignment for installations';
        req.additionalDetail = 'Would save 2 hours per week on large projects';

        Test.startTest();
        List<HDAgent.TicketResponse> responses =
            HDAgent.createTicket(new List<HDAgent.TicketRequest>{ req });
        Test.stopTest();

        HDAgent.TicketResponse res = responses[0];
        System.assertEquals(true, res.success);
        System.assertEquals('Build', res.businessUnit);
        System.assert(res.description.contains('Additional Detail:'));
    }

    @isTest
    static void testCreateTicket_MinimalFields() {
        HDAgent.TicketRequest req = new HDAgent.TicketRequest();
        req.businessUnit = 'Operations';
        req.ticketType = 'Other';
        req.subject = 'General enquiry';

        Test.startTest();
        List<HDAgent.TicketResponse> responses =
            HDAgent.createTicket(new List<HDAgent.TicketRequest>{ req });
        Test.stopTest();

        HDAgent.TicketResponse res = responses[0];
        System.assertEquals(true, res.success);
        System.assertEquals('Not Started', res.status);
    }
}