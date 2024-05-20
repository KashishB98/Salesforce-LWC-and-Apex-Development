trigger CaseTrigger on Case (before insert,after delete,after update,after undelete,after insert) {

    TriggerDispatcher.run(new CaseTriggerHandler());
}