import { LightningElement,wire } from 'lwc';
import getAccountsTreeGrid from '@salesforce/apex/AccountTriggerHandler.getAccountsTreeGrid'

const COLUMNS = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Account Name',
    },
    {
        type: 'phone',
        fieldName: 'phone',
        label: 'Phone Number',
    },
     {
        type: 'text',
        fieldName: 'Rating',
        label: 'Account Rating'
    }
];
export default class SelfParentTreeGrid extends LightningElement {

gridColumns = COLUMNS

@wire(getAccountsTreeGrid)
wiredDate({data,error}){
    if(data){
        let accounts = JSON.parse(JSON.stringify(data))
        console.log('OUTPUT : ',accounts);
    }
}
}