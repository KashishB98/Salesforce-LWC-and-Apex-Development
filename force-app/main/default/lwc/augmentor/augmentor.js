import { LightningElement } from 'lwc';

export default class Augmentor extends LightningElement {

    startCounter = 2;

    handleStartChange(event) {
        this.startCounter = parseInt(event.target.value);
    }

    handleMaximizeCounter() {
        this.template.querySelector('c-numerator').maximizeCounter();
    }
}