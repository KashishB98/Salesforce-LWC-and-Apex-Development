global class AccountTriggerController implements Schedulable{
    
    @ReadOnly
    global void execute(SchedulableContext sc)
    {
        list<Account> accounts =  [SELECT id, Name FROM Account];
        ScheduleCleanOpportunity m = new ScheduleCleanOpportunity();
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Merge Job', sch, m);
    }
}