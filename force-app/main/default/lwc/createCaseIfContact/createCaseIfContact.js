import { LightningElement } from 'lwc';
import checkIfContact from '@salesforce/apex/LWCApexController.checkIfContact'
export default class CreateCaseIfContact extends LightningElement {
phoneVal
ifContact = false
handleChange(event){
    this.phoneVal = event.detail.value;
    console.log('phoneVal ',this.phoneVal)
}
handleClick(){
    checkIfContact({phoneNumber:this.phoneVal})
    .then((result) => {
       this.ifContact = result 
    }).catch((error) => {
        this.ifContact = false
        console.error('Error occurred : ',error.body.message);
    });

}
}