import { LightningElement } from 'lwc';
export default class ParentComp extends LightningElement {

message = ''
handleChange(event){
this.message = event.detail.value
}
}