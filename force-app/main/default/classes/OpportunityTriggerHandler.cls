public class OpportunityTriggerHandler implements TriggerHandlerInterface{
    
    // send mail when opportunity updated to closed won
    public static void futureHandler(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        
        Set<Id> OpportunityIds = new Set<Id>();
        if(newList != null && newList.size() > 0) {
            for(Opportunity opp : newList) {
                if(oldMap != null) {
                    if(opp.StageName == 'Closed Won' && oldMap.get(opp.Id).StageName != 'Closed Won') {
                        OpportunityIds.add(opp.Id);
                    }
                }
            }
        }
        FutureMethodDemo.sendEmailMethod(OpportunityIds);     
    }  
    
    // preventing more than one records being inserted
    public void beforeInsert(List<sObject>newItemList) {
        Map<Id,Id> mapOfAccountOppId = new Map<Id,Id>();
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : (List<Opportunity>)newItemList) {
            accountIds.add(opp.AccountId);
        }
        
        for(Opportunity opp : [SELECT Id,AccountId FROM Opportunity WHERE AccountId IN : accountIds AND CreatedDate = TODAY]) {
            mapOfAccountOppId.put(opp.AccountId,opp.Id);
        }
        
        for(Opportunity opp : (List<Opportunity>)newItemList) {
            if(mapOfAccountOppId.containsKey(opp.AccountId)) {
                opp.addError('You cannot add more than opportunity per account in a day');
            }
        }
    }
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap) {
        /*
// Trigger asked in metacube Line 41 - 61
List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

// Collect AccountIds for Opportunities with stage changed to 'Closed Won'
Set<Id> accountIds = new Set<Id>();
for(Opportunity opp : (List<Opportunity>)newItemMap.values()) {
if (opp.StageName == 'Closed Won' && opp.AccountId != null) {
accountIds.add(opp.AccountId);
}
}

// Query related Accounts
Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountIds AND Name = 'Metacube']);

// Update Opportunities based on criteria
for(Opportunity opp : (List<Opportunity>)newItemMap.values()) {
if (opp.StageName == 'Closed Won' && accountsMap.containsKey(opp.AccountId)) {
opp.WonDate__c = Date.today();
opportunitiesToUpdate.add(opp);
}
}
*/
        // Trigger with Type field
        Map<String,Id>mapOfOppIdbyType = new Map<String,Id>();
        Map<String,Id>mapOfConIdbyType = new Map<String,Id>();
        List<OpportunityContactRole>opconRoleToInsert = new List<OpportunityContactRole>();
        Map<Id,Opportunity> oldMapOppById = (Map<Id,Opportunity>)oldItemMap;
        for(Opportunity opp : (List<Opportunity>)newItemMap.values()) {
            if(opp.Type__c != oldMapOppById.get(opp.Id).Type__c) {
                mapOfOppIdbyType.put(opp.Type__c,opp.Id);
            }
        }  
        // Iterating on Contact with same type
        for(Contact con : [SELECT Id,Type__c FROM Contact WHERE Type__c IN :mapOfOppIdbyType.keySet()]) {
            mapOfConIdbyType.put(con.Type__c,con.Id);
        }
        
        // Iterating on Opportunity to insert OpportunityContactRole        
        for(Opportunity opp : (List<Opportunity>)newItemMap.values()) {
            if(opp.Type__c != oldMapOppById.get(opp.Id).Type__c) {
                OpportunityContactRole opconRole = new OpportunityContactRole();
                if(mapOfConIdbyType.containsKey(opp.Type__c)) {
                    opconRole.OpportunityId = opp.Id;
                    opconRole.ContactId = mapOfConIdbyType.get(opp.Type__c);
                    opconRoleToInsert.add(opconRole);
                }
                else {
                    opp.addError('Cannot find contact with same type');
                }
            }
        }
        
        if( !opconRoleToInsert.isEmpty()){
            List<OpportunityContactRole>opConListToDelete = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId IN :mapOfOppIdbyType.values()];
            Database.DeleteResult[] drList;
            if( !opconRoleToInsert.isEmpty()){
                drList = Database.delete(opConListToDelete, false);  
            }
            
            // Iterate through each returned result
            if( !drList.isEmpty()){
                for(Database.DeleteResult dr : drList) {
                    if (dr.isSuccess()) {
                        
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully deleted account with ID: ' + dr.getId());
                    }
                    else {
                        
                        // Operation failed, so get all errors                
                        for(Database.Error err : dr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('OpportunityContactRole fields that affected this error: ' + err.getFields());
                        }
                    }
                }        
            }        
            Database.SaveResult[] srList = Database.insert(opconRoleToInsert, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('OpportunityContactRole fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    public void afterInsert(Map<Id,sObject>newItemMap){
        createUpdateTassk((Map<Id,Opportunity>)newItemMap,null);
        updateAccountStatus((Map<Id,Opportunity>)newItemMap,null);
        
    }
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){
        System.debug('componentRefreshPE');
        Refresh_Custom_Component__e refreshEvent = new Refresh_Custom_Component__e();
        EventBus.publish(refreshEvent);
        createUpdateTassk((Map<Id,Opportunity>)newItemMap,(Map<Id,Opportunity>)oldItemMap);
        updateAccountStatus((Map<Id,Opportunity>)newItemMap,(Map<Id,Opportunity>)oldItemMap);
    }
    public void afterDelete(Map<Id,sObject>oldItemMap){
        updateAccountStatus((Map<Id,Opportunity>)oldItemMap,null);
    }
    public void beforeDelete(Map<Id,sObject>oldItemMap){}
    public void afterUnDelete(Map<Id,sObject>newItemMap){
        updateAccountStatus((Map<Id,Opportunity>)newItemMap,null);
    }
    
    public static void createUpdateTassk(Map<Id,Opportunity>newMap,Map<Id,Opportunity>oldMap){
        List<Task> tasksToInsert = new List<Task>();
        Map<Id,Task> mapOfTaskById = new Map<Id,Task>();
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity opp : (List<Opportunity>)newMap.values()){
            if(oldMap != null && oldMap.get(opp.Id).StageName != opp.StageName){
                oppIds.add(opp.Id);
            }
            oppIds.add(opp.Id);
        }
        for(Task ta : [SELECT Id,WhatId FROM Task WHERE WhatId IN :oppIds]){
            mapOfTaskById.put(ta.WhatId,ta);
        }
        
        for(Opportunity opp : (List<Opportunity>)newMap.values()){
            Task ta = new Task();
            if( !mapOfTaskById.containsKey(opp.Id)){
                ta.WhatId = opp.Id;
                ta.ActivityDate = Date.today();
                ta.Subject = 'created for opp';
                ta.Status = 'Not Started';
            }
            else{
                ta.Id = mapOfTaskById.get(opp.Id).Id;
                ta.ActivityDate = Date.today();
                ta.Subject = 'created for opp when updated';
            }
            tasksToInsert.add(ta);
        }
        
        upsert tasksToInsert;
    }
    
    public static void updateAccountWithOppName(Map<Id,Opportunity>newItemMap,Map<Id,Opportunity>oldItemMap){
        
        List<Account> accListToUpdate = new List<Account>();
        Set<Id>parentIds = new Set<Id>();
        Map<Id,Decimal> mapOfAmountByAccId = new Map<Id,Decimal>();
        for(Opportunity opp : newItemMap.values()){
            if(oldItemMap != null){
                if(oldItemMap.get(opp.Id).Amount != opp.Amount){
                    parentIds.add(opp.AccountId);
                }
                if(oldItemMap.get(opp.Id).AccountId != opp.AccountId){
                    parentIds.add(oldItemMap.get(opp.Id).AccountId);
                    parentIds.add(opp.AccountId);
                }
            }
            parentIds.add(opp.AccountId);
        }
        
        for(Account acc : [SELECT Id,Opp_with_highest_amount__c,(SELECT Id,Amount,Name from Opportunities WHERE Amount != null ORDER BY Amount DESC LIMIT 1) FROM Account WHERE Id IN :parentIds]){
            acc.Opp_with_highest_amount__c = acc.Opportunities[0].Name;
        }
        
    }
    
    public static void updateAccountStatus(Map<Id,Opportunity>oppMap, Map<Id,Opportunity>oldItemMap){
        List<Account>accountsToUpdate = new List<Account>();
        Map<Id,Integer>allOppCountByAccId = new Map<Id,Integer>();
        Map<Id,Integer>closedOppCountByAccId = new Map<Id,Integer>();
        Set<Id>accountIdSet = new Set<Id>();
        for(Opportunity opp : (List<Opportunity>)oppMap.values()) {
            if(oldItemMap != null) {
                if(opp.StageName != oldItemMap.get(opp.Id).StageName) {
                    accountIdSet.add(opp.AccountId);
                }
                else if(opp.AccountId != oldItemMap.get(opp.Id).AccountId) {
                    accountIdSet.add(opp.AccountId);
                }
            }
            else {
                accountIdSet.add(opp.AccountId);              
            }
        }
        for(AggregateResult agg : [SELECT COUNT(Id) oppId, AccountId accId FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId IN:accountIdSet GROUP BY AccountId]){
            closedOppCountByAccId.put((Id)agg.get('accId'),(Integer)agg.get('oppId'));            
        }
        for(AggregateResult agg : [SELECT COUNT(Id) oppId, AccountId accId FROM Opportunity WHERE AccountId IN:accountIdSet GROUP BY AccountId]){
            allOppCountByAccId.put((Id)agg.get('accId'),(Integer)agg.get('oppId'));            
        }
        
        for(Account acc : [SELECT Id,Account_Status__c FROM Account WHERE Id IN :accountIdSet]){
            if(closedOppCountByAccId.containsKey(acc.Id) && allOppCountByAccId.containsKey(acc.Id)){
                if(closedOppCountByAccId.get(acc.Id) == allOppCountByAccId.get(acc.Id)){
                    acc.Account_Status__c = 'Inactive';
                }
                else{
                    acc.Account_Status__c = 'Active';
                }
            }
            accountsToUpdate.add(acc);
        }
        try{
            if(accountsToUpdate != null){
                update accountsToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Error occurred while updating account '+e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpptyOverAmount(Id recordId) {
        return [SELECT Id, Name, Amount, StageName, CloseDate FROM Opportunity WHERE AccountId=:recordId];
    }
}