import { LightningElement } from 'lwc';
import fetchAllObjet from '@salesforce/apex/LWCApexController.fetchAllObjet'
const COLUMNS = [{fieldName : 'Label',label :'Label',type : 'text'},
                 {fieldName : 'QualifiedApiName',label :'Qualified Api Name',type : 'text'}]
export default class ShowAllObjectList extends LightningElement {
columnsList = COLUMNS
dataList = []
offsetsize = 0
limitsize = 25

connectedCallback() {
    this.retrieveObjectList();
}
retrieveObjectList(){
    fetchAllObjet({limitsize:this.limitsize,offsetsize:this.offsetsize})
    .then(result=>{
        let updatedRecords = [...this.dataList,...result]
        this.dataList = updatedRecords
    })
    .catch(error=>{
        console.log('Error occurred while fetching object list ',error.body.message)
    })

}
loadMoreData(event){
    console.log('event fired')
    this.offsetsize = this.offsetsize + this.limitsize
    console.log('offsetsize ',this.offsetsize)
    const { target } = event;
    target.isLoading = true;
    this.retrieveObjectList()
    target.isLoading = false;
}

}