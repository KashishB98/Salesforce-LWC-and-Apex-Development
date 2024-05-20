import { LightningElement, api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RefreshViewApiComp extends LightningElement {
    @api recordId

    refreshComponent() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'success',
                message: 'Record Updated Successfully!',
                variant: 'success'
            })
        )
        this.dispatchEvent(new RefreshEvent());
    }
}