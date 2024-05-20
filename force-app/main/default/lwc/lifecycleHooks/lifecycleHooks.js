import { LightningElement,wire,api } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts'
const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName:'Phone', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];
export default class LifecycleHooks extends LightningElement {

constructor(){
    super()
    console.log('constructor called ')
}

contactsData = []
@api recordId
offsetVal = 0
pageSizeval = 10
columns = COLUMNS

@wire(getContacts,{recordId:'$recordId',offsetVal:0,pageSizeval:20})
fetchData({data,error}){
    console.log(' in wire ',data)
   this.contactsData = data
}
connectedCallback() {
    console.log('in connected callback ')
}
renderedCallback(){
    console.log('in rendered callback')
}
}