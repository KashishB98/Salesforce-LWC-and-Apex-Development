global class UpdateOpportunityStageBatch implements Database.Batchable<sObject>,Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, CloseDate FROM Opportunity]);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        for (Opportunity opp : scope) {
            if (opp.CloseDate < Date.today()) {
                opp.StageName = 'Closed Won';
            } else {
                opp.StageName = 'Prospecting';
            }
        }
        update scope;
    }
    global void execute(SchedulableContext sc){
        UpdateOpportunityStageBatch us = new UpdateOpportunityStageBatch();
       Database.ExecuteBatch(us);
    }
    global void finish(Database.BatchableContext BC) {}
}