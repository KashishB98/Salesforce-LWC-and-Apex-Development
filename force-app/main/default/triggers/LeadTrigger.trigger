trigger LeadTrigger on Lead (after update,before insert) {
TriggerDispatcher.run(new LeadTriggerHandler());
}