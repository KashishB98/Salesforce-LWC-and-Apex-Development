import { LightningElement } from 'lwc';
import sendEmailMethod from '@salesforce/apex/ContactController.sendEmailMethod'
export default class SendEmailButton extends LightningElement {


async sendEmail(){
try {
    console.log('in send Email')
    console.log(await demoSend());
     console.log('text ')
    } catch(e) {
        console.error(e);
    } finally {
        console.log('Do something no matter what');
    }
}

async demoSend(){
    return 'Text recieved';
}
}