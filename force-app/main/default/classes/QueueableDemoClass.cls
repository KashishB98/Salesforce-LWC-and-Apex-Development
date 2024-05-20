public class QueueableDemoClass implements Queueable {
    
    private List<Id> accountIds;
    
    public QueueableDemoClass(List<Id> accIds) {
        this.accountIds = accIds;
    }
    
    public void execute(QueueableContext context) {
        
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        
        for (Account acc : accounts) {
            acc.Name = acc.Name + ' - Updated with queueable';
        }
        
        update accounts;
        
        System.enqueueJob(new UpdateContactNameQueueable(accountIds));
    }
    
}