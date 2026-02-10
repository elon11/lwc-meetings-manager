import { LightningElement, api, track } from 'lwc';
import searchContacts from '@salesforce/apex/MeetingController.searchContacts';
import insertAttendees from '@salesforce/apex/MeetingController.insertAttendees';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class MeetingForm extends NavigationMixin(LightningElement) {

    @api recordId;
    @track meetingId;

    @track showForm = true;
    @track showAttendees = false;

    @track contactOptions = [];
    @track selectedContacts = [];

    allContactsMap = new Map();

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;

        if (this.recordId) {
            fields.Account__c = this.recordId;
        }

        this.template.querySelector('lightning-record-form').submit(fields);
    }

    handleSuccess(event) {
        this.meetingId = event.detail.id;
        this.showForm = false;
        this.showAttendees = true;

        this.showSuccess('Meeting Created. Now select attendees.');
    }

    handleSearch(event) {
        const key = event.target.value;

        if (key.length < 2) {
            return;
        }

        searchContacts({ searchKey: key })
            .then(result => {
                result.forEach(c => {
                    if (!this.allContactsMap.has(c.Id)) {
                        this.allContactsMap.set(c.Id, {
                            label: c.Name,
                            value: c.Id
                        });
                    }
                });

                this.contactOptions = Array.from(this.allContactsMap.values());
            })
            .catch(err => console.error(err));
    }

    handleSelect(event) {
        this.selectedContacts = event.detail.value;
    }

    saveAttendees() {
        if (!this.meetingId) {
            this.showError('Meeting ID missing.');
            return;
        }

        if (this.selectedContacts.length === 0) {
            this.showWarning('Select at least one contact.');
            return;
        }

        insertAttendees({
            meetingId: this.meetingId,
            contactIds: this.selectedContacts
        })
            .then(() => {
                this.showSuccess('Attendees added successfully.');
                this.dispatchEvent(new CloseActionScreenEvent());

                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.meetingId,
                        objectApiName: 'Meeting__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(() => {
                this.showError('Error adding attendees.');
            });
    }

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
