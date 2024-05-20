import { LightningElement,wire } from 'lwc';
import messageChannel from '@salesforce/messageChannel/TestMessageChannel__c';
import {publish, MessageContext} from 'lightning/messageService'
import getContacts from '@salesforce/apex/ContactController.getContacts'
const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName:'Phone', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];
export default class PublisherLMS extends LightningElement {


columns = COLUMNS
contactsData = []

@wire(MessageContext)
    messageContext;


connectedCallback() {
    this.fetchContact()
}
fetchContact(){
    getContacts({recordId:null,offsetVal:null,pageSizeval:null})
    .then(data=>{
        console.log('data length ',data.length)
        this.contactsData = data
    })
    .catch(error=>{
        console.log('Error occurred while fetching contact ',error.body.message)
    })
}

    handleClick(){
        let allData = {contactList: this.contactsData,colList : this.columns};
        publish(this.messageContext, messageChannel, allData);
    }
}