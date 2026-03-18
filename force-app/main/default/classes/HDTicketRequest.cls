@JsonAccess(serializable='always' deserializable='always')
global class HDTicketRequest {

    @InvocableVariable(label='Intake Data' description='Business unit and ticket type selection')
    global HDTicketIntakeData intakeData;

    @InvocableVariable(label='Subject' required=true description='A short summary of the issue')
    global String subject;

    @InvocableVariable(label='Expected Behaviour' description='What the user expected to happen')
    global String expectedBehaviour;

    @InvocableVariable(label='Steps to Reproduce' description='Steps to reproduce the issue')
    global String stepsToReproduce;

    @InvocableVariable(label='Link to Record' description='URL link to the related record')
    global String linkToRecord;

    @InvocableVariable(label='Additional Detail' description='Any extra context')
    global String additionalDetail;
}
