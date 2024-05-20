public class AccountTriggerHandler implements TriggerHandlerInterface {
    
    public static void updateOpportunity(List<Account> newList, Map<Id,Account>olMap) {        
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        Set<Id> accountIdSet = new Set<Id>();        
        for(Account acc : newList) {
            if(olMap != null) {
                if(acc.Close_all_Opps__c == true && olMap.get(acc.Id).Close_all_Opps__c == false) {
                    accountIdSet.add(acc.Id);
                }
            }            
        }        
        for(Opportunity opp : [Select Id,AccountId,Probability,StageName from Opportunity 
                               WHERE AccountId IN:accountIdSet AND Probability >= 70]) 
        {
            opp.StageName = 'Closed Won';
            oppListToUpdate.add(opp);
        }        
        try{
            if( !oppListToUpdate.isEmpty() && oppListToUpdate.size() > 0) {
                update oppListToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Error while updating '+e.getMessage());
        }        
    }    
    public void beforeInsert(List<sObject>newItemList){}  
    public void afterInsert(Map<Id,sObject>newItemMap){
        List<Account> listOfAcc = (List<Account>)newItemMap.values();
        updateOpportunity(listOfAcc,null);
        /*
List<Account>accList = new List<Account>();
Map<Id,Contact> mapOfIdContact = new Map<Id,Contact>();         
for(Account acc : listOfAcc) {
Contact con = new Contact(FirstName = 'creating',LastName = acc.Name,Email='abc@xyz.com',AccountId = acc.Id);             
mapOfIdContact.put(acc.Id,con);
}         
insert mapOfIdContact.values();         
for(Account acc : [Select Id,Client_Contact__c from Account WHERE Id IN :mapOfIdContact.keySet()]) {             
acc.Client_Contact__c = mapOfIdContact.get(acc.Id).Id;
accList.add(acc);
}
update accList;
*/
        List<Contact>conList = new List<Contact>();
        for(Account acc : listOfAcc){
            for(Integer i = 1;i<=acc.NumberofLocations__c;i++){
                Contact con = new Contact();
                con.FirstName = 'With Account';
                con.LastName = 'Location';
                con.AccountId = acc.Id;
                conList.add(con);
            }
        }
        insert conList;
        
    }
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap) {
        List<Account> listOfAcc = (List<Account>)newItemMap.values();
        Map<Id,Account>oldMap = (Map<Id,Account>)oldItemMap;
        updateOpportunity(listOfAcc,oldMap);   
        
        //Update related contact when account country changes
        Map<Id,Account>mapOfAccById = new Map<Id,Account>();
        List<Contact> conListToUpdate = new List<Contact>();
        
        //iterating in updated Account
        for(Account acc : listOfAcc) {
            if(oldMap != null && oldMap.get(acc.Id).Account_Country__c != acc.Account_Country__c) {
                mapOfAccById.put(acc.Id,acc);
            }
        }
        
        // Iterate on related contacts
        for(Contact con : [SELECT Id,AccountId FROM Contact WHERE AccountId IN :mapOfAccById.keySet()]) {
            if(mapOfAccById.containsKey(con.AccountId)){
                con.Contact_Country__c = mapOfAccById.get(con.AccountId).Account_Country__c;
                conListToUpdate.add(con); 
            }
        }         
        try{
            if( !conListToUpdate.isEmpty()) {
                update conListToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Error occurred while updating Contact '+e.getMessage());
        }
    }
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){
        List<Contact>contactsToInsert = new List<Contact>();
        Map<Id,Account> oldMap = (Map<Id,Account>)oldItemMap;
        for(Account acc :(List<Account>)newItemMap.values()) {
            if(acc.Create_Contact__c == true && (oldMap.get(acc.Id).Create_Contact__c == null || oldMap.get(acc.Id).Create_Contact__c == false)) {
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.FirstName = 'Raja';
                con.LastName = 'Created from Account';
                con.Phone = '124242';
                con.Title = 'Account Manager';
                contactsToInsert.add(con);
            }
        }        
        try{
            if( !contactsToInsert.isEmpty()) {
                insert contactsToInsert;
            }
        }catch(Exception e){
            System.debug('Error occurred while inserting contacts '+e.getMessage());
        }
    }
    public void beforeDelete(Map<Id,sObject>oldItemMap){
        Set<Id>accountIds = new Set<Id>();
Map<Id,Integer>countByAccountId = new Map<Id,Integer>();
for(Account acc : (List<Account>)oldItemMap.values()){
   accountIds.add(acc.Id);
}

List<AggregateResult> aggregatList = [SELECT COUNT(Id) countId,AccountId accId FROM Contact WHERE Primary_Contact__c = true AND AccountId IN : accountIds GROUP BY AccountId];
for(AggregateResult agg : aggregatList){
countByAccountId.put((Id)agg.get('accId'), (Integer)agg.get('countId'));
}

for(Account acc : (List<Account>)oldItemMap.values()){
    if(countByAccountId.containsKey(acc.Id) && countByAccountId.get(acc.Id) > 0){
    acc.addError('You cannot delete the account');
   }
}
    }
    public void afterUnDelete(Map<Id,sObject>newItemMap){}
    public void afterDelete(Map<Id,sObject>oldItemMap){}
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsTreeGrid(){
        return [SELECT Id, Name,Phone,Rating FROM Account LIMIT 10];
    }
    
    
}