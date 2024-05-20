public class BatchChainingDemo implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id from Contact');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        
        // perform execute logic
    }
    
    public void finish(Database.BatchableContext BC)
    {
        // any post process
    }
}