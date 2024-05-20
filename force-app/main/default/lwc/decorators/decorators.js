import { LightningElement, track} from 'lwc';
export default class Decorators extends LightningElement {

    @track nestedArr = {name:'salesforce geek',area:'salesforce'}
    message
    
    handleChange(event){
        this.nestedArr.name = event.detail.value

    }
}