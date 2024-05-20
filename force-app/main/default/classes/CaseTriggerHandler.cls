public class CaseTriggerHandler implements TriggerHandlerInterface{
    
    public void beforeInsert(List<sObject>newItemList) {
        /* 
* Approach 1 with standard SuppliedEmail fields as If already contact exists then it automatic attached that (Web to case email functionality)
Set<String>emailSet = new Set<String>();
Map<String,Contact> emailContactMap = new Map<String,Contact>();
List<Case>caseList = new List<Case>();        
for(Case c : (List<Case>)newItemList) {
if(c.SuppliedEmail != null) {
emailSet.add(c.SuppliedEmail);
}
}
for(Case c :(List<Case>)newItemList) {
if(c.SuppliedName != null 
&& c.SuppliedEmail != null
&& c.ContactId == null
&& c.SuppliedEmail != ''
&& c.SuppliedName != '') {
String[]NameArr = c.SuppliedName.split(' ');
Contact con = new Contact(FirstName = NameArr[0],
LastName = NameArr[1],
Email = c.SuppliedEmail);                       
emailContactMap.put(c.SuppliedEmail,con);
caseList.add(c);
}
}
List<Contact>conRecords = emailContactMap.values();
insert conRecords;        
for(Case c : caseList){
c.ContactId = emailContactMap.get(c.SuppliedEmail).Id;
}
*/
        
        // Approach 2 with custom field with contact exist with email attached otherwise insert
        Map<String,Contact>mapOfContactByEmail = new Map<String,Contact>();
        Set<String>emailSet = new Set<String>();
        List<Case>caseListNoContact = new List<Case>();
        Map<String,Contact>mapOfConByEmailToInsert = new Map<String,Contact>();
        for(Case ca : (List<Case>)newItemList) {
            if(ca != null) {
                emailSet.add(ca.Supplied_Email__c);
            }
        }        
        for(Contact con : [SELECT Id,Email FROM Contact WHERE Email IN :emailSet]) {
            mapOfContactByEmail.put(con.Email,con);
        }
        
        for(Case ca : (List<Case>)newItemList) {
            if(mapOfContactByEmail.containsKey(ca.Supplied_Email__c)) {
                ca.ContactId = mapOfContactByEmail.get(ca.Supplied_Email__c).Id;                
            }
            else {
                Contact con = new Contact();
                con.FirstName = 'Created with';
                con.LastName = 'Case';
                con.Email = ca.Supplied_Email__c;
                mapOfConByEmailToInsert.put(ca.Supplied_Email__c,con);
                caseListNoContact.add(ca);
            }              
        }
        insert mapOfConByEmailToInsert.values();
        for(Case ca : caseListNoContact){
            ca.ContactId = mapOfConByEmailToInsert.get(ca.Supplied_Email__c).Id;
        }
    } 
    
    //after insert method
    public void afterInsert(Map<Id,sObject>newItemMap){ 
        updateAccountRating((Map<Id,Case>)newItemMap,null);
        
        Set<Id> accountIds = new Set<Id>();
        List<Task> tasks = new List<Task>();
        for(Case ca : (List<Case>)newItemMap.values()) {
            if(ca.Create_Task__c == true) {
                accountIds.add(ca.AccountId);
            }
        }
        
        for(Contact con : [Select Id,AccountId,Primary_Contact__c from Contact WHERE AccountId IN:accountIds AND Primary_Contact__c = true]) {
            Task ta = new Task();
            ta.WhoId = con.Id;
            ta.Subject = 'Follow up';
            ta.ActivityDate = Date.today();
            ta.Status = 'Not Started';
            ta.WhatId = con.AccountId;
            tasks.add(ta);  
        }
        
        try{
            if(tasks != null && tasks.size() > 0) {
                insert tasks;
            }
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }
    }    
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap) {
        updateAccountRating((Map<Id,Case>)newItemMap,(Map<Id,Case>)oldItemMap);
    }
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void afterUnDelete(Map<Id,sObject>newItemMap) {
        updateAccountRating((Map<Id,Case>)newItemMap,null);
    }
    public void beforeDelete(Map<Id,sObject>oldItemMap){}
    public void afterDelete(Map<Id,sObject>oldItemMap){
        System.debug('in after delete ');
        updateAccountRating((Map<Id,Case>)oldItemMap,null);
    }  
    
    //Account rating update based on case closed count on that
    public static void updateAccountRating(Map<Id,Case>newItemMap,Map<Id,Case>oldItemMap) {
        List<Account> accListToUpdate = new List<Account>();
        Set<Id>accIds = new Set<Id>();
        Map<Id,Integer> mapOfAccountByCount = new Map<Id,Integer>();
        for(Case ca : (List<Case>)newItemMap.values()) {            
            if(oldItemMap != null && ((ca.AccountId != oldItemMap.get(ca.Id).AccountId ) || (ca.Status == 'Closed' && oldItemMap.get(ca.Id).Status != 'Closed'))) {
                accIds.add(ca.AccountId);
            }
            else{
                accIds.add(ca.AccountId);
            }
        }
        List<AggregateResult> aggList = [Select Count(Id) countIds,AccountId accId,Status FROM Case WHERE AccountId IN :accIds AND Status = 'Closed' GROUP BY AccountId,Status];
        System.debug('aggList size '+aggList.size());
        for(AggregateResult agg : aggList) {
            Account acc = new Account();
            acc.Id = (Id)agg.get('accId');
            Integer closedCount = (Integer)agg.get('countIds');
            
            mapOfAccountByCount.put((Id)agg.get('accId') , closedCount);
        }        
        System.debug('mapOfAccountByCount size '+mapOfAccountByCount.size());
        
        for(Account acc : [SELECT Id,Rating FROM Account WHERE Id IN :mapOfAccountByCount.keySet()]){
            Integer closedCount = mapOfAccountByCount.get(acc.Id);
            System.debug('closedCount '+closedCount);
            if(closedCount == 2){
                acc.Rating = 'Cold';
            }
            else if(closedCount == 4){
                acc.Rating = 'Warm';
            }
            else if(closedCount == 5){
                acc.Rating = 'Hot';
            }
            accListToUpdate.add(acc);
            System.debug('accListToUpdate size '+accListToUpdate.size());
        }
        update accListToUpdate;
    }
}