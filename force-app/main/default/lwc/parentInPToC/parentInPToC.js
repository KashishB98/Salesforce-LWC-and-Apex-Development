import { LightningElement,api } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts'
const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName:'Phone', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];
export default class ParentInPToC extends LightningElement {

@api recordId
columns = COLUMNS
contactsData = []


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

handleEvent(event){
    alert('You selected in first parent: ' + event.detail);
    console.log('name recieved from child parent',event.detail)
}

}