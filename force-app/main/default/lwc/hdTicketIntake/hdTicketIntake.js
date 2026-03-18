import { api, LightningElement } from 'lwc';

const BUSINESS_UNITS = [
    { value: 'Acquisition', label: 'Acquisition' },
    { value: 'Design', label: 'Design' },
    { value: 'Build', label: 'Build' },
    { value: 'Business Development', label: 'Business Dev' },
    { value: 'Operations', label: 'Operations' },
    { value: 'Management', label: 'Management' },
    { value: 'HSSEQ', label: 'HSSEQ' },
    { value: 'Stores & Logistics', label: 'Stores & Logistics' },
    { value: 'External Contractor', label: 'Ext. Contractor' },
    { value: 'Fixed Line', label: 'Fixed Line' },
    { value: 'SPEN FSL - O&M', label: 'SPEN FSL' }
];

const TICKET_TYPES = [
    {
        value: 'Bug/Error Report',
        label: 'Bug / Error report',
        description: 'Report unexpected or broken behaviour'
    },
    {
        value: 'New Feature/Functionality Request',
        label: 'New feature request',
        description: 'Suggest an enhancement or new capability'
    },
    {
        value: 'User Management',
        label: 'User management',
        description: 'Create, deactivate, or change user access rights'
    }
];

export default class HdTicketIntake extends LightningElement {

    currentStep = 1;
    submitted = false;
    selectedBu = null;
    selectedType = null;
    freeTextValue = '';
    subject = '';
    linkToRecord = '';
    expectedBehaviour = '';
    stepsToReproduce = '';

    @api
    get readOnly() { return this._readOnly; }
    set readOnly(value) {
        this._readOnly = value;
        if (value === true) {
            this.submitted = true;
        }
    }
    _readOnly = false;

    _value;
    @api
    get value() { return this._value; }
    set value(val) {
        this._value = val;
        if (val && val.businessUnit) {
            this.selectedBu = val.businessUnit;
            this.selectedType = val.ticketType;
            this.freeTextValue = val.freeText || '';
            this.subject = val.subject || '';
            this.linkToRecord = val.linkToRecord || '';
            this.expectedBehaviour = val.expectedBehaviour || '';
            this.stepsToReproduce = val.stepsToReproduce || '';
            this.submitted = true;
        }
    }

    get isSubmitted() { return this.submitted; }
    get isStep1() { return !this.submitted && this.currentStep === 1; }
    get isStep2() { return !this.submitted && this.currentStep === 2; }
    get isStep3Bug() { return !this.submitted && this.currentStep === 3 && this.selectedType === 'Bug/Error Report'; }
    get isStep3Other() { return !this.submitted && this.currentStep === 3 && this.selectedType !== 'Bug/Error Report'; }

    get businessUnits() {
        return BUSINESS_UNITS.map(bu => ({
            ...bu,
            cssClass: 'pill-btn' + (this.selectedBu === bu.value ? ' pill-selected' : '')
        }));
    }

    get ticketTypes() {
        return TICKET_TYPES.map(tt => ({
            ...tt,
            cssClass: 'type-btn' + (this.selectedType === tt.value ? ' type-selected' : ''),
            radioClass: 'radio-outer' + (this.selectedType === tt.value ? ' radio-selected' : ''),
            isSelected: this.selectedType === tt.value
        }));
    }

    get selectedBuLabel() {
        const found = BUSINESS_UNITS.find(bu => bu.value === this.selectedBu);
        return found ? found.label : '';
    }

    get selectedTypeLabel() {
        if (this.freeTextValue) return 'Custom request';
        const found = TICKET_TYPES.find(tt => tt.value === this.selectedType);
        return found ? found.label : '';
    }

    get summarySubject() { return this.subject || ''; }

    handleBuClick(event) {
        event.stopPropagation();
        this.selectedBu = event.currentTarget.dataset.id;
        this.selectedType = null;
        this.freeTextValue = '';
        this.resetFields();
        this.currentStep = 2;
        this.fireValueChange();
    }

    handleTypeClick(event) {
        event.stopPropagation();
        this.selectedType = event.currentTarget.dataset.id;
        this.freeTextValue = '';
        this.resetFields();
        this.currentStep = 3;
        this.fireValueChange();
    }

    handleFreeTextChange(event) {
        event.stopPropagation();
        this.freeTextValue = event.detail.value;
        if (this.freeTextValue) {
            this.selectedType = null;
        }
        this.fireValueChange();
    }

    handleFreeTextContinue() {
        this.selectedType = 'Other';
        this.currentStep = 3;
        this.fireValueChange();
    }

    handleBack() {
        this.selectedBu = null;
        this.selectedType = null;
        this.freeTextValue = '';
        this.resetFields();
        this.currentStep = 1;
        this.fireValueChange();
    }

    handleBackToType() {
        this.selectedType = null;
        this.freeTextValue = '';
        this.resetFields();
        this.currentStep = 2;
        this.fireValueChange();
    }

    handleFieldChange(event) {
        event.stopPropagation();
        const { name, value } = event.target;
        this[name] = value;
        this.fireValueChange();
    }

    resetFields() {
        this.subject = '';
        this.linkToRecord = '';
        this.expectedBehaviour = '';
        this.stepsToReproduce = '';
    }

    fireValueChange() {
        this.dispatchEvent(
            new CustomEvent('valuechange', {
                detail: {
                    value: {
                        businessUnit: this.selectedBu,
                        ticketType: this.selectedType,
                        freeText: this.freeTextValue || null,
                        subject: this.subject || null,
                        linkToRecord: this.linkToRecord || null,
                        expectedBehaviour: this.expectedBehaviour || null,
                        stepsToReproduce: this.stepsToReproduce || null
                    }
                }
            })
        );
    }
}
