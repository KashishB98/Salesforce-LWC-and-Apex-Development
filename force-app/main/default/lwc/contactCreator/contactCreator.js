import { LightningElement } from 'lwc';
import CONTACT_LastName_FIELD from '@salesforce/schema/Contact.LastName';
import CONTACT_FirstName_FIELD from '@salesforce/schema/Contact.FirstName';
import CONTACT_Email_FIELD from '@salesforce/schema/Contact.Email';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactCreator extends LightningElement {
    objectApiName = CONTACT_OBJECT
    fields = [CONTACT_Email_FIELD, CONTACT_FirstName_FIELD, CONTACT_LastName_FIELD];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }


}