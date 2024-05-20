public class ContactTriggerHandler implements TriggerHandlerInterface{
    
    public void beforeInsert(List<sObject>newItemList){
        Set<Id>accountIds = new Set<Id>();
        Map<Id,Integer>mapOfPrimCountById = new Map<Id,Integer>();
        //Approach 1
        /*
for(Contact con : (List<Contact>)newItemList){
if(con.Primary_Contact__c == true){
accountIds.add(con.AccountId);
}
}

List<Contact>conList = [SELECT Id,AccountId FROM Contact WHERE Primary_Contact__c = true and AccountId IN : accountIds];

if( !conList.isEmpty()){
for(Contact con : (List<Contact>)newItemList){
if(con.Primary_Contact__c == true){
con.addError('Primary contact already exists');
}
}
}

*/
        // Approach 2
        for(Contact con : (List<Contact>)newItemList){
            if(con.Primary_Contact__c == true){
                accountIds.add(con.AccountId);
            }
        }
        for(Account acc :[SELECT Id,(SELECT Id FROM Contacts WHERE Primary_Contact__c = true) FROM Account WHERE Id IN :accountIds]){
            mapOfPrimCountById.put(acc.Id,acc.Contacts.size());
            System.debug('mapOfPrimCountById contact size '+acc.Contacts.size());
        }
        for(Contact con : (List<Contact>)newItemList){
            
            if(con.Primary_Contact__c == true && mapOfPrimCountById.containsKey(con.AccountId) && mapOfPrimCountById.get(con.AccountId) > 0){
                System.debug('In if of verfiified condiotion');
                con.addError('Primary contact already exists');
            }
        }
    }
    public void afterInsert(Map<Id,sObject>newItemMap){}
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void afterDelete(Map<Id,sObject>oldItemMap){}
    public void beforeDelete(Map<Id,sObject>oldItemMap){}
    public void afterUnDelete(Map<Id,sObject>newItemMap){}
}