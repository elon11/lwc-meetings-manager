import { LightningElement, wire } from 'lwc';
import getMeetings from '@salesforce/apex/MeetingController.getMeetings';

export default class MeetingList extends LightningElement {
    meetings;

    @wire(getMeetings)
    wiredMeetings({ error, data }) {
        if (data) {
            this.meetings = data;
        } else if (error) {
            console.error(error);
        }
    }
}
