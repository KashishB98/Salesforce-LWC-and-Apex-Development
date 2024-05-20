public class UpdateContactFields implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id, Name,Account.Active__c from Contact WHERE Account.Active__c =\'No\'');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Contact> contacts = new List<Contact>();
        for(sObject s : scope)
        {
            Contact con = (Contact)s;
            con.Description = 'Belongs to inactive account';
            contacts.add(con);
        }
        update contacts;
        
        BatchChainingDemo batchdemo = new BatchChainingDemo();
        Database.executeBatch(batchdemo,200);
    }
    
    public void finish(Database.BatchableContext BC)
    {
        
    }
}