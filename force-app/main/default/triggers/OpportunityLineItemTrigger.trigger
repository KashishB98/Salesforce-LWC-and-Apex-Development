trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert,after insert,after update,before update) {
    TriggerDispatcher.run(new OpportunityLineItemHandler());
}