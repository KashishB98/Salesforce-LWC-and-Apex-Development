import { LightningElement } from 'lwc';
export default class GrandParentCToP extends LightningElement {


handleEvent(event){
    alert('You selected in grand parent : ' + event.detail);
    console.log('name recieved from child grand parent',event.detail)
}
}