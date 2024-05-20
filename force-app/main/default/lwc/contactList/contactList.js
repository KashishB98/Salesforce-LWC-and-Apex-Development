import { LightningElement, wire,api } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts'


const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName:'Phone', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];


export default class ContactList extends LightningElement {


@api recordId
columns = COLUMNS
contactsData = []
Currentpage = 1
pageSize = 10
offsetVal = 0
pageSizeval = 10


// Server Side pagination
connectedCallback() {
    this.fetchContact(this.offsetVal)
}
fetchContact(offsetVal){
    getContacts({recordId:this.recordId,offsetVal:offsetVal,pageSizeval:this.pageSizeval})
    .then(data=>{
        //console.log('data length ',data.length)
        this.contactsData = data
    })
    .catch(error=>{
        console.log('Error occurred while fetching contact ',error.body.message)
    })
}


handleNext(){
        this.offsetVal = this.Currentpage*this.pageSize
        this.Currentpage = this.Currentpage + 1
        this.fetchContact(this.offsetVal)
        console.log('current page on next ',this.Currentpage)
        console.log('offset on next ',this.offsetVal)
}


handlePrevious(){
    if(this.Currentpage > 1){
        this.Currentpage = this.Currentpage - 1
         this.offsetVal = (this.Currentpage-1)*this.pageSize
        console.log('current page on previous ',this.Currentpage)
        console.log('offset on previous ',this.offsetVal)
        this.fetchContact(this.offsetVal)
    }
}
}