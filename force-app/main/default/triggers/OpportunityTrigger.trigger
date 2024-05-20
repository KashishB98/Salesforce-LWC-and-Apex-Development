trigger OpportunityTrigger on Opportunity (before update,before insert,after insert,after update,after delete,after undelete) {
    TriggerDispatcher.run(new OpportunityTriggerHandler()); 
}