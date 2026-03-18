@isTest
private class HDAgentTest {

    @isTest
    static void testCreateTicket_BugReport() {
        HDTicketIntakeData intake = new HDTicketIntakeData();
        intake.businessUnit = 'Design';
        intake.ticketType = 'Bug/Error Report';
        intake.subject = 'Missing visibility of fields';
        intake.expectedBehaviour = 'Should see In Period Revenue';
        intake.stepsToReproduce = '1. Navigate to finance review PS';
        intake.linkToRecord = 'https://example.salesforce.com/001xx000003ABCD';

        HDTicketRequest req = new HDTicketRequest();
        req.intakeData = intake;

        Test.startTest();
        List<HDTicketResponse> responses =
            HDAgent.createTicket(new List<HDTicketRequest>{ req });
        Test.stopTest();

        System.assertEquals(true, responses[0].success);
        System.assertNotEquals(null, responses[0].confirmData);
        System.assertEquals('Design', responses[0].confirmData.businessUnit);
    }

    @isTest
    static void testCreateTicket_FreeText() {
        HDTicketIntakeData intake = new HDTicketIntakeData();
        intake.businessUnit = 'Operations';
        intake.ticketType = 'Other';
        intake.subject = 'Dashboard access';
        intake.freeText = 'Need access to Build team dashboards';

        HDTicketRequest req = new HDTicketRequest();
        req.intakeData = intake;

        Test.startTest();
        List<HDTicketResponse> responses =
            HDAgent.createTicket(new List<HDTicketRequest>{ req });
        Test.stopTest();

        System.assertEquals(true, responses[0].success);
        System.assertNotEquals(null, responses[0].confirmData.ticketNumber);
    }
}
