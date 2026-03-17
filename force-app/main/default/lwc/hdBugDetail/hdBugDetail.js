import { LightningElement, api } from 'lwc';

export default class HdBugDetail extends LightningElement {

    subject = '';
    linkToRecord = '';
    expectedBehaviour = '';
    stepsToReproduce = '';

    _value = {};

    @api
    get value() {
        return this._value;
    }
    set value(val) {
        if (val) {
            this._value = val;
            this.subject = val.subject || '';
            this.linkToRecord = val.linkToRecord || '';
            this.expectedBehaviour = val.expectedBehaviour || '';
            this.stepsToReproduce = val.stepsToReproduce || '';
        }
    }

    get showPreview() {
        return this.subject.trim().length > 0;
    }

    handleSubjectChange(event) {
        this.subject = event.detail.value;
        this.updateValue();
    }

    handleLinkChange(event) {
        this.linkToRecord = event.detail.value;
        this.updateValue();
    }

    handleExpectedChange(event) {
        this.expectedBehaviour = event.detail.value;
        this.updateValue();
    }

    handleStepsChange(event) {
        this.stepsToReproduce = event.detail.value;
        this.updateValue();
    }

    updateValue() {
        this._value = {
            subject: this.subject,
            linkToRecord: this.linkToRecord,
            expectedBehaviour: this.expectedBehaviour,
            stepsToReproduce: this.stepsToReproduce
        };

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: { value: this._value }
        }));
    }
}
