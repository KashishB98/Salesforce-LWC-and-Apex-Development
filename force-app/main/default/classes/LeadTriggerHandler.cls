public class LeadTriggerHandler implements TriggerHandlerInterface{
    
    public void beforeInsert(List<sObject>newItemList) {
        Set<String>companySet = new Set<String>();
        Set<String>emailSet = new Set<String>();
        Set<String>leadNameSet = new Set<String>();
        Boolean isduplicateExist;
        
        for(Lead le : (List<Lead>)newItemList) {
            companySet.add(le.Company);
            emailSet.add(le.Email);
            leadNameSet.add(le.FirstName + ' '+le.LastName);
        }
        System.debug('leadNameSet '+leadNameSet);
        System.debug('emailSet '+emailSet); 
         System.debug('companySet '+companySet);
        List<Lead>existingLeads = [SELECT Id,Name,Company,Email FROM Lead WHERE Name IN : leadNameSet AND Email IN :emailSet AND Company IN :companySet];
        System.debug('existingLeads '+existingLeads);
        if(existingLeads != null && existingLeads.size() > 0) {
            isduplicateExist = true;
        }
        else{
            isduplicateExist = false;
        }
        System.debug('isduplicateExist '+isduplicateExist);
        if(isduplicateExist == true){
            for(Lead le : (List<Lead>)newItemList){
                le.addError('Duplicate exist');
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