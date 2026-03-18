import { LightningElement, api } from 'lwc';

export default class HdTicketConfirm extends LightningElement {

    @api value;

    get ticketNumber() {
        return this.value?.ticketNumber || '';
    }

    get ticketSubject() {
        return this.value?.subject || '';
    }

    get ticketType() {
        return this.value?.ticketType || '';
    }

    get businessUnit() {
        return this.value?.businessUnit || '';
    }

    get ticketStatus() {
        return this.value?.status || 'Not Started';
    }

    get ticketLink() {
        const ticketId = this.value?.ticketId || '';
        if (!ticketId) return '#';
        const baseUrl = window.location.origin;
        return baseUrl + '/lightning/r/Help_Desk__c/' + ticketId + '/view';
    }
}
