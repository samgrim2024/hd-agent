import { LightningElement, api } from 'lwc';

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

    @api businessUnit;
    @api ticketType;
    @api subject;

    selectedBu = null;
    selectedType = null;
    freeTextValue = '';

    _value = {};

    @api
    get value() {
        return this._value;
    }
    set value(val) {
        this._value = val || {};
    }

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

    get showTicketTypes() {
        return this.selectedBu !== null;
    }

    get showSummary() {
        return this.selectedBu !== null && (this.selectedType !== null || this.freeTextValue);
    }

    get selectedBuLabel() {
        const found = BUSINESS_UNITS.find(bu => bu.value === this.selectedBu);
        return found ? found.label : '';
    }

    get selectedTypeLabel() {
        if (this.freeTextValue) {
            return 'Custom request';
        }
        const found = TICKET_TYPES.find(tt => tt.value === this.selectedType);
        return found ? found.label : '';
    }

    handleBuClick(event) {
        this.selectedBu = event.currentTarget.dataset.id;
        this.selectedType = null;
        this.freeTextValue = '';
        this.updateValue();
    }

    handleTypeClick(event) {
        this.selectedType = event.currentTarget.dataset.id;
        this.freeTextValue = '';
        this.updateValue();
    }

    handleFreeTextChange(event) {
        this.freeTextValue = event.detail.value;
        if (this.freeTextValue) {
            this.selectedType = null;
        }
        this.updateValue();
    }

    updateValue() {
        this._value = {
            businessUnit: this.selectedBu,
            ticketType: this.selectedType,
            freeText: this.freeTextValue || null
        };

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: { value: this._value }
        }));
    }
}
