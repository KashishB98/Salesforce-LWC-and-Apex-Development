import { LightningElement } from 'lwc';

export default class CountCharacters extends LightningElement {

    inputValue
    resultArr = {}

    handleChange(event){
        this.inputValue = event.detail.value
    }

    calculateChar(){
        for(let i = 0;i<this.inputValue.length;i++){
            let l = this.inputValue.charAt(i)
            if(this.resultArr[l]){
                this.resultArr[l]+=1
            }
            else{
                this.resultArr[l] = 1
            }
        }
        console.log(' the char count is ',JSON.stringify(this.resultArr))
    }
}