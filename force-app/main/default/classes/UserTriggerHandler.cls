public class UserTriggerHandler implements TriggerHandlerInterface{
    
    public void beforeInsert(List<sObject>newItemList){
        
        Map<String,Id> mapOfUserByTeam = new Map<String,Id>();
        Set<String> teamName = new Set<String>();
        for(User u : (List<User>)newItemList) {
            if(u.Assign_Manager__c == true && u.Team__c != null) {
                teamName.add(u.Team__c);
            }
        }        
        for(User u : [SELECT Id,isActive,Team__c FROM User WHERE Team__c IN :teamName]) {
            mapOfUserByTeam.put(u.Team__c,u.Id);
        }        
        for(User u : (List<User>)newItemList) {
            if(u.Assign_Manager__c == true){
                if(mapOfUserByTeam.containsKey(u.Team__c)) {
                    u.ManagerId = mapOfUserByTeam.get(u.Team__c);
                }
                else {
                    u.addError('Respective team dont have assign manager');
                }
            }
        }
    }
    public void afterInsert(Map<Id,sObject>newItemMap){}
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){
        Map<Id,User>userNewItemMap = (Map<Id,User>)newItemMap;
        Map<Id,User>userOldItemMap = (Map<Id,User>)oldItemMap;
        Map<Id,Id> userManagerId = new Map<Id,Id>();
        if(userNewItemMap != null) {
            for(User u : userNewItemMap.values()) {
                if(userOldItemMap != null) {
                    if(u.IsActive == false && userOldItemMap.get(u.Id).IsActive == true) {
                        userManagerId.put(u.Id,u.ManagerId);
                    }
                }
            }
        }
        if(userManagerId != null) {
            updateOwnerShip(userManagerId);
        }
        
    }
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void afterDelete(Map<Id,sObject>oldItemMap){}
    public void beforeDelete(Map<Id,sObject>oldItemMap){}
    public void afterUnDelete(Map<Id,sObject>newItemMap){}
    
    @future
    public static void updateOwnerShip(Map<Id,Id>userManagerId){
        List<Account>accounts = new List<Account>();
        
        if(userManagerId != null) {
            for(Account acc : [SELECT Id,OwnerId FROM Account WHERE OwnerId IN :userManagerId.keySet()]) {
                if(acc != null) {
                    acc.OwnerId = userManagerId.get(acc.OwnerId);
                    accounts.add(acc);
                }
            }
        }
        
        try{
            if(accounts != null) {
                update accounts;
            }
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString()); 
        }
        
        
    }
    
}