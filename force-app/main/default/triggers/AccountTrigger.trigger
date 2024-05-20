trigger AccountTrigger on Account (after insert,after update,after delete,after undelete,before update,before insert,before delete) {
        
    if(TriggerDispatcher.runOnce(Trigger.newMap?.keySet(),Trigger.oldMap?.keySet(),Trigger.operationType)) {
        return;
    }    
     TriggerDispatcher.run(new AccountTriggerHandler());   
}