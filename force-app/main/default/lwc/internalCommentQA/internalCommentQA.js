/**
 * @module InternalCommentQA
 * @description LWC component to create internal comments for an Account record.
 *              Handles fetching title color, input validation, and saving comments via Apex.
 * @created by Elon Yifrah
 */
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createInternalComment from '@salesforce/apex/InternalCommentController.createInternalComment';
import getTitleColor from '@salesforce/apex/InternalCommentController.getTitleColor';
import getUserNameById from '@salesforce/apex/InternalCommentController.getUserNameById';
import USER_ID from '@salesforce/user/Id';

export default class InternalCommentQA extends LightningElement {
    @api recordId;
  
    @track bodyValue = '';
    @track titleColor = 'black'; 

    userId = USER_ID; 

    /**
     * @description Lifecycle hook executed when component is inserted into DOM.
     *              Fetches the title color on initialization.
     * @created by Elon Yifrah
     */
    connectedCallback() {
        this.fetchTitleColor();
    }

     /**
     * @method fetchTitleColor
     * @description Fetches the color for the title based on Account and User comparison.
     *              Defaults to 'black' in case of error.
     * @created by Elon Yifrah
     */
    fetchTitleColor() {
        getUserNameById({ userId: this.userId })
            .then(userName => {
              
                return getTitleColor({ accountId: this.recordId, userName: this.userId });
            })
            .then(color => {
                this.titleColor = color;
                console.log('Title color fetched:', color);
            })
            .catch(error => {
                console.error('Error fetching title color:', error);
                this.titleColor = 'black';
            });
    }

    get modalTitle() {
        return 'Internal Comment';
    }

    get titleStyle() {
        return `color: ${this.titleColor};`;
    }

    /**
     * @getter isSaveDisabled
     * @description Determines if the Save button should be disabled
     *              based on empty or whitespace-only input.
     * @created by Elon Yifrah
     */
    get isSaveDisabled() {
        return !this.bodyValue || this.bodyValue.trim() === '';
    }

    /**
     * @method handleBodyChange
     * @param {Event} event - Input event from the textarea
     * @description Updates the bodyValue property when user types a comment.
     * @created by Elon Yifrah
     */
    handleBodyChange(event) {
        this.bodyValue = event.target.value;
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

     /**
     * @method handleSave
     * @description Saves the internal comment via Apex, shows a success or error toast,
     *              and closes the modal on success.
     * @created by Elon Yifrah
     */
    handleSave() {
        createInternalComment({
            accountId: this.recordId,
            bodyText: this.bodyValue
        })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Thank you for your comment',
                    variant: 'success'
                })
            );

            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating comment',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        });
    }
}
