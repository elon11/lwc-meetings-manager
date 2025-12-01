import { LightningElement, api, track } from 'lwc';
import insertAttendees from '@salesforce/apex/MeetingController.insertAttendees';
import searchContacts from '@salesforce/apex/MeetingController.searchContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MeetingForm extends LightningElement {
    @api recordId;
    showForm = true;
    showAttendees = false;

    meetingId;

    // OLD: attendeeInput kept for backward compatibility
    attendeeInput = '';

    // NEW: Multi-Select & Lookup
    @track contactOptions = [];
    @track selectedContacts = [];

    /**
     * @Method Name: handleSuccess
     * @input event - the onsuccess event from lightning-record-form
     * @Description: Triggered when a Meeting__c record is created successfully.
     *              Saves the meetingId and shows the attendees section.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    handleSuccess(event) {
        this.meetingId = event.detail.id;
        this.showForm = false;
        this.showAttendees = true;
    }

    /**
     * @Method Name: handleAttInput
     * @input event - the onchange event from the old attendee input
     * @Description: Updates the attendeeInput property when IDs are manually entered.
     *              Kept for backward compatibility.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    handleAttInput(event) {
        this.attendeeInput = event.target.value;
    }

    /**
     * @Method Name: handleSearch
     * @input event - the onchange event from the search input
     * @Description: Calls the Apex method searchContacts to fetch Contacts
     *              matching the typed search key. Updates contactOptions
     *              for the Dual Listbox.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    handleSearch(event) {
        const searchKey = event.target.value;
        if (searchKey.length > 1) {
            searchContacts({ searchKey })
                .then(result => {
                    this.contactOptions = result.map(c => ({ label: c.Name, value: c.Id }));
                })
                .catch(error => console.error(error));
        }
    }

    /**
     * @Method Name: handleSelect
     * @input event - the onchange event from the Dual Listbox
     * @Description: Updates the selectedContacts property with the selected
     *              contacts from the Dual Listbox.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    handleSelect(event) {
        this.selectedContacts = event.detail.value;
    }

    /**
     * @Method Name: saveAttendees
     * @Description: Inserts Meeting_Attendee__c records for the selected contacts.
     *              Uses selectedContacts from the Dual Listbox if available,
     *              otherwise falls back to attendeeInput (comma-separated IDs).
     *              Displays a success toast after insertion.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    async saveAttendees() {
        const contactsToSave = this.selectedContacts.length > 0 
            ? this.selectedContacts 
            : this.attendeeInput.split(',').map(id => id.trim());

        try {
            await insertAttendees({ meetingId: this.meetingId, contactIds: contactsToSave });

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
