trigger UserTrigger on User (after update,before insert) {

    TriggerDispatcher.run(new UserTriggerHandler());
}