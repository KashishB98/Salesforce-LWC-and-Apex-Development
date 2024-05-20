import { LightningElement, wire, api } from 'lwc';

import getAccount from '@salesforce/apex/DependentPicklistController.getAccount'
import getContactByAccountId from '@salesforce/apex/DependentPicklistController.getContactByAccountId'

export default class DependentPicklist extends LightningElement {

    @api accId
    accountOptions = []
    contactsOptions = []
    contactsValue
    accValue

    /**************************************************************************************************************************************************
     * @description     This function is called whenever component gets loaded on DOM because its a wire and performing following actions
     *                      1) Calling Apex method with and fetching the account list
     *                      2) Providing and designing options for Account combobox
     ***************************************************************************************************************************************************/
    @wire(getAccount)
    wiredAccResult({ data, error }) {
        if (data) {
            console.log('data coming for accounts are ', data)
            console.log('length of data coming for accounts are ', data.length)
            for (let i = 0; i < data.length; i++) {
                this.accountOptions = [...this.accountOptions, { label: data[i].Name, value: data[i].Id }];
            }
        }
        if (error) {
            console.log('Error in fetch9ing account ', JSON.stringify(error.message));
        }
    }

    /**************************************************************************************************************************************************
     * @description     This function is called whenever component gets loaded on DOM because its a wire and performing following actions
     *                      1) Calling Apex method with AccountId selected in combobox and fetching the child contacts by accId
     * @param           accId is the variable that represents the currently selected accountId in parent combobox
     ***************************************************************************************************************************************************/
    @wire(getContactByAccountId, { accId: '$accId' })
    wiredcontactResult({ data, error }) {
        if (data) {
            console.log('data coming for contacts are ', data)
            console.log('length of data coming for accounts are ', data.length)
            for (let i = 0; i < data.length; i++) {
                this.contactsOptions = [...this.contactsOptions, { label: data[i].Name, value: data[i].Id }];
            }
        }
        if (error) {
            console.log('Error in fetch9ing account ', JSON.stringify(error.message));
        }
    }

    handleContactsChange(event) {
        this.contactsValue = event.detail.value
    }

    handleAccountChange(event) {
        this.accId = event.detail.value
        console.log('account Id are ', this.accId)
        this.contactsValue = undefined
    }
}