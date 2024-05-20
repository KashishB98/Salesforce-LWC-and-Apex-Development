/***********************************************************************************************************************
* @name         LWCApexController
* @author       Kashish Bansal
* @date         16/04/2024
* @description  This class is for fetching all the Case hierarchies
*/
public class LWCApexController {
    
    /********************************************************************************************************************
    * @description  Method behind fething multiple sObject list  
    * @return       returning List<LWCApexControllerWrapper>
    * @param        numberLimit
    ********************************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static List<LWCApexControllerWrapper> fetchMultiObjectList(Integer numberLimit){
        List<LWCApexControllerWrapper> wrapperList = new List<LWCApexControllerWrapper>(); 
        for(Task ta : [SELECT Id,ActivityDate,Subject FROM Task WHERE ActivityDate != null AND Subject != null ORDER BY ActivityDate Desc]) {
            LWCApexControllerWrapper wrap = new LWCApexControllerWrapper();
            wrap.Subject = ta.Subject;
            wrap.recId = ta.Id;
            wrap.ActivityDate = ta.ActivityDate;
            wrapperList.add(wrap);
        }
        for(Obj_A__c ta : [SELECT Id,Activity_Date__c,Comment_Text__c FROM Obj_A__c WHERE Activity_Date__c != null ORDER BY Activity_Date__c Desc]) {
            LWCApexControllerWrapper wrap = new LWCApexControllerWrapper();
            wrap.Subject = ta.Comment_Text__c;
            wrap.ActivityDate = ta.Activity_Date__c;
            wrap.recId = ta.Id;
            wrapperList.add(wrap);
        }
        return wrapperList;
    }
    
    public class LWCApexControllerWrapper{
        @AuraEnabled
        public string Subject;
        @AuraEnabled
        public Date ActivityDate;
        @AuraEnabled
        public Id recId;
    }
    
    @AuraEnabled
    public static List<EntityDefinition> fetchAllObjet(Integer limitsize, Integer offsetsize){
        return [SELECT Id,Label, QualifiedApiName,DeveloperName From EntityDefinition LIMIT :limitsize OFFSET :offsetsize];
    }
    @AuraEnabled
    public static Boolean checkIfContact(String phoneNumber) {
        Contact contact = [SELECT Id,Phone FROM Contact WHERE Phone =: phoneNumber LIMIT 1];
        if(contact != null)return true;
        return false;
    }

    /********************************************************************************************************************
    * @description  Method behind fething multiple sObject list  
    * @return       returning List<Account>
    ********************************************************************************************************************/
    @AuraEnabled
    public static List<Account> fetchAccountData(){
            List<Account> accList = [SELECT Id,Name,Phone,Industry FROM Account LIMIT 20];
            return accList;
    }
    

    
}