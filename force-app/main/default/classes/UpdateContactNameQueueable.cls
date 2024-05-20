public class UpdateContactNameQueueable implements Queueable {
    
    private List<Id> accountIds;

    public UpdateContactNameQueueable(List<Id> accIds) {
        this.accountIds = accIds;
    }
    
    public void execute(QueueableContext context) {
     
        List<Contact> contacts = [SELECT Id, Description,LastName FROM Contact WHERE AccountId IN :accountIds];
        
        for (Contact con : contacts) {
            con.LastName = con.LastName + ' - Updated Description';
        }
        
         update contacts;
    }
    
}