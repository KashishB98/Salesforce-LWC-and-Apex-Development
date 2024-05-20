import { LightningElement,api } from 'lwc';
export default class ChildInPToC extends LightningElement {

@api columns
@api contactsData

getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++) {
            const eve = new CustomEvent('sendname',{detail:selectedRows[i].Name,bubbles:true,composed: true })
            this.dispatchEvent(eve);
        }
    }

}