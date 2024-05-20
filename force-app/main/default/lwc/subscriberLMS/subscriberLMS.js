import { LightningElement,wire } from 'lwc';
import messageChannel from '@salesforce/messageChannel/TestMessageChannel__c';
import { subscribe, MessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
export default class SubscriberLMS extends LightningElement {

columns
contactsData

    subscription = null;
    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(this.messageContext, messageChannel, (message) => {
                this.contactsData = JSON.parse(JSON.stringify(message.contactList))
                console.log(`grand parent received ${this.contactsData}`);
                this.columns = message.colList
                console.log('lenght data coming from punlisher ',this.contactsData.length)
            },{ scope: APPLICATION_SCOPE });
        }
    }

}