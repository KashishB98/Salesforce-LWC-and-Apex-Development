public Interface TriggerHandlerInterface {
    void beforeInsert(List<sObject>newItemList);
    void afterInsert(Map<Id,sObject>newItemMap);
    void afterUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap);
    void beforeUpdate(Map<Id,sObject>newItemMap,Map<Id,sObject>oldItemMap);
    void afterDelete(Map<Id,sObject>oldItemMap);
    void beforeDelete(Map<Id,sObject>oldItemMap);
    void afterUnDelete(Map<Id,sObject>newItemMap);
}