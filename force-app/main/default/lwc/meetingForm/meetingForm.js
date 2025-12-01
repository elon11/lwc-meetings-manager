import { LightningElement, api, track } from 'lwc';
import searchContacts from '@salesforce/apex/MeetingController.searchContacts';
import insertAttendees from '@salesforce/apex/MeetingController.insertAttendees';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class MeetingForm extends LightningElement {

    @api recordId;     // Account Id
    @track meetingId;

    @track showForm = true;
    @track showAttendees = false;

    @track contactOptions = [];
    @track selectedContacts = [];

    /** STEP 1 — BEFORE SAVE: inject Account__c */
    handleSubmit(event) {
        event.preventDefault();

        const fields = event.detail.fields;

        // אם הגיע מהדף של חשבון → מאכלסים
        if (this.recordId) {
            fields.Account__c = this.recordId;
        }

        // שמירה בפועל
        this.template.querySelector('lightning-record-form').submit(fields);
    }

    /** STEP 2 — after success */
    handleSuccess(event) {
        this.meetingId = event.detail.id;

        this.showForm = false;
        this.showAttendees = true;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Meeting Created',
                message: 'Now select attendees.',
                variant: 'success'
            })
        );
    }

    /** SEARCH CONTACTS */
    handleSearch(event) {
        const key = event.target.value;

        if (key.length < 2) {
            this.contactOptions = [];
            return;
        }

        searchContacts({ searchKey: key })
            .then(result => {
                this.contactOptions = result.map(c => ({
                    label: c.Name,
                    value: c.Id
                }));
            })
            .catch(err => console.error(err));
    }

    handleSelect(event) {
        this.selectedContacts = event.detail.value;
    }

    /** SAVE ATTENDEES */
    saveAttendees() {
        if (!this.meetingId) {
            this.showError('Meeting ID missing.');
            return;
        }

        if (this.selectedContacts.length === 0) {
            this.showWarning('Select at least one contact.');
            return;
        }

        insertAttendees({ meetingId: this.meetingId, contactIds: this.selectedContacts })
            .then(() => {
                this.showSuccess('Attendees added successfully.');
                this.selectedContacts = [];
                
              
            })
            .catch(err => {
                console.error(err);
                this.showError('Error adding attendees.');
            });
    }

    /** UTILITIES */
    showSuccess(msg) {
        this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: msg, variant: 'success' }));
    }
    showWarning(msg) {
        this.dispatchEvent(new ShowToastEvent({ title: 'Warning', message: msg, variant: 'warning' }));
    }
    showError(msg) {
        this.dispatchEvent(new ShowToastEvent({ title: 'Error', message: msg, variant: 'error' }));
    }
}
