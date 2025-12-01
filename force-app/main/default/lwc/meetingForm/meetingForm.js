import { LightningElement } from 'lwc';
import insertAttendees from '@salesforce/apex/MeetingController.insertAttendees';

export default class MeetingForm extends LightningElement {

    showForm = true;
    showAttendees = false;

    meetingId;
    attendeeInput = '';

    handleSuccess(event) {
        this.meetingId = event.detail.id;
        this.showForm = false;
        this.showAttendees = true;
    }

    handleAttInput(event) {
        this.attendeeInput = event.target.value;
    }

    async saveAttendees() {
        const contacts = this.attendeeInput
            .split(',')
            .map(id => id.trim());

        try {
            await insertAttendees({ meetingId: this.meetingId, contactIds: contacts });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Attendees added successfully!',
                    variant: 'success'
                })
            );
        } catch (err) {
            console.error(err);
        }
    }

}
