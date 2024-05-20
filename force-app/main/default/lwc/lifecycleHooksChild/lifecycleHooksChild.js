import { LightningElement,api,wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts'
export default class LifecycleHooksChild extends LightningElement {
@api valueReceieved
contactsDataChild = []
offsetVal = 0

constructor() {
    super();
    console.log('in child constructor ',this.valueReceieved)
}
@wire(getContacts,{recordId:'$valueReceieved',offsetVal:0,pageSizeval:20})
fetchData({data,error}){
     console.log(' in wire child 2',data)
   this.contactsDataChild = data
}
connectedCallback() {
    console.log('in connected callback child')
}
renderedCallback(){
    console.log('in rendered callback child')
}
}