import { LightningElement } from 'lwc'

import fetchAccountData from '@salesforce/apex/LWCApexController.fetchAccountData'

const COLUMNS = [
                    {fieldName : 'Name', label : 'Account Name',type : 'text'},
                    {fieldName : 'Phone', label : 'Phone', type : 'text'},
                    {fieldName : 'Industry' ,label : 'Industry', type : 'text'}
                ]
export default class ExportToExcelComponent extends LightningElement {
    accColumns = COLUMNS
    accountsData = []
    checked = true
    columnHeader = ['ID', 'Name', 'Phone', 'Industry' ]

    constructor(){
        super();
        this.getAccounts();   
    }
    getAccounts(){
        fetchAccountData()
        .then(data=>{
            this.accountsData = data
            console.log('data is ',data)
        })
        .catch(error=>{
            console.log('Error is ',JSON.stringify(error));
        })
    }
    changeToggle() {
        this.checked = !this.checked;
    }

    handleClick() {
        let doc = '<table>';
        // Add styles for the table
        doc += '<style>';
        doc += 'table, th, td {';
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';          
        doc += '</style>';
        // Add all the Table Headers
        doc += '<tr>';
        this.columnHeader.forEach(element => {            
            doc += '<th>'+ element +'</th>'           
        });
        doc += '</tr>';
        // Add the data rows
        this.accountsData.forEach(record => {
            doc += '<tr>';
            doc += '<th>'+record.Id+'</th>'; 
            doc += '<th>'+record.Name+'</th>'; 
            doc += '<th>'+record.Phone+'</th>';
            doc += '<th>'+record.Industry+'</th>'; 
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Account Data.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}