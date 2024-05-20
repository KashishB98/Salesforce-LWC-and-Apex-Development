/***********************************************************************************************************************
* @name         DependentPicklistController
* @author       Kashish Bansal
* @date         20/05/2024
* @description  This class is for displaying contact on the basis of acocunt as a dependent picklist
*/
public with sharing class DependentPicklistController {

    /********************************************************************************************************************
    * @description  Method fetching all account to diplay in combobox
    * @return       returning List<Account>
    ********************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount() {
        return [SELECT Id,Name FROM Account LIMIT 20];
    }

    /********************************************************************************************************************
    * @description  Method behind fething contact list on the basis of account id  
    * @return       returning List<Contact>
    * @param        accId which will store the account Id
    ********************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactByAccountId(Id accId) {
        return [SELECT Id,Name FROM Contact WHERE AccountId =: accId];
    }
}