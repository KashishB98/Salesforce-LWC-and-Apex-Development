public class OpportunityLineItemHandler implements TriggerHandlerInterface {
    
    public void beforeInsert(List<sObject>newItemList){}
    public void afterInsert(Map<Id,sObject>newItemMap) {
        Set<Id>oppIds = new Set<Id>();
        Map<Id,Integer>mapOfOliCountByOppId = new Map<Id,Integer>();
        Map<Id,Integer>mapOfCountByAccId = new Map<Id,Integer>();
        List<Account>accListToUpdate = new List<Account>();
        for(OpportunityLineItem opp : (List<OpportunityLineItem>)newItemMap.values()) {
            if(opp.ListPrice > 50000) {  
                oppIds.add(opp.Id);
            }
        }
        List<AggregateResult>aggList = [SELECT COUNT(Id) countIds, OpportunityId oId from OpportunityLineItem WHERE ListPrice > 50000 AND Id IN : oppIds GROUP BY OpportunityId];
        for(AggregateResult agg : aggList) {
            mapOfOliCountByOppId.put((Id)agg.get('oId'),(Integer)agg.get('countIds'));
        }
        
        for(Opportunity opp : [SELECT Id,AccountId FROM Opportunity WHERE Id IN :mapOfOliCountByOppId.keySet()]) {
            if(mapOfOliCountByOppId.containsKey(opp.Id)) {
                mapOfCountByAccId.put(opp.AccountId,mapOfOliCountByOppId.get(opp.Id));
            }
        }
        for(Account acc : [SELECT Id,Description FROM Account WHERE Id IN :mapOfCountByAccId.keySet()]) {
            if(mapOfCountByAccId.containsKey(acc.Id)) {
                acc.OLI_Count__c = (Decimal)mapOfCountByAccId.get(acc.Id);
                accListToUpdate.add(acc);
            }
        }
        
        try{
            if( !accListToUpdate.isEmpty()) {
                update accListToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Error while updating accounts '+e.getMessage());
        }
    }
    public void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap){}
    public void afterDelete(Map<Id,sObject>oldItemMap){}
    public void beforeDelete(Map<Id,sObject>oldItemMap){}
    public void afterUnDelete(Map<Id,sObject>newItemMap){}

}