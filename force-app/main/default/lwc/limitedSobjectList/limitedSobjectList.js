import { LightningElement,wire } from 'lwc';
import fetchMultiObjectList from '@salesforce/apex/LWCApexController.fetchMultiObjectList'
const COLUMNS = [
    {fieldName : 'activeDate',label : 'Activity Date',type: 'date'},
    {fieldName : 'subjectField',label : 'Subject',type: 'text'},
    ]
export default class LimitedSobjectList extends LightningElement {

resultData = []
columns = COLUMNS

@wire(fetchMultiObjectList,{numberLimit:2})
getData({data,error}){
    if(data){
        this.resultData = JSON.parse(JSON.stringify(data)).map(item => {
            let activeDate = item.ActivityDate
            let subjectField = item.Subject
            return {...item,activeDate,subjectField};
        });
        console.log('Data is '+JSON.stringify(this.resultData));
    }
}
}