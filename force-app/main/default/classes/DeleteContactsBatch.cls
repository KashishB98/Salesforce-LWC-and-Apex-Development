public class DeleteContactsBatch implements Database.Batchable<sObject>,Database.Stateful {
    
   public static final Date StartDate;
   public static final Date EndDate;
   public static Integer contactSize = 0;

   public DeleteContactsBatch(Date startDate,Date endDate){
       StartDate = startDate;
       EndDate = endDate;
   }
    public static Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id,Name FROM Contact WHERE CreatedDate <= :endDate');
    }    
    public static void execute(Database.BatchableContext bc,List<sObject> scope) {
        List<Contact> conList = (List<contact>)scope;
        Set<Id>conIdSet = new Set<Id>();
        for(Contact con : conList) {
            conIdSet.add(con.Id);
        }
        checkInTask(conIdSet);        
    }    
    public static void finish(Database.BatchableContext bc) {
         List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();  
        List<String> toAddress = new List<String>();
            toAddress.add('kasishbansal17@gmail.com');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);            	 
            mail.setSubject('Total contacts');
            mail.setHtmlBody(                    
                'Dear Kashish'+',' +'<br>'+'<br>'+
                'The Total ' +contactSize +' which is linked to '+'<br>'+'<br>'
            );  
       
            allMails.add(mail);
         System.debug('allMails size '+allMails.size());
         System.debug('contactSize size '+contactSize);
    }    
    
    
    public static void checkInTask(Set<Id>conIdSet){
        List<Contact>conList = [SELECT Id,(SELECT Id,WhoId from Tasks) FROM Contact WHERE Id IN :conIdSet];
        Set<Id>conIdwithoutTask = new Set<Id>();
        for(Contact con : conList){
            if(con.tasks.size() == 0){
                conIdwithoutTask.add(con.Id);
            }
        }
        checkCase(conIdwithoutTask);
    }    
    public static void checkCase(Set<Id>conIdSet){
        List<Contact>conList = [SELECT Id,(SELECT Id,ContactId from Cases ) FROM Contact WHERE Id IN :conIdSet];
        Set<Id>conIdwithoutCase = new Set<Id>();
        for(Contact con : conList){
            if(con.cases.size() == 0){
                conIdwithoutCase.add(con.Id);
            }
        }
        finalMethod(conIdwithoutCase);
    }
    public static Set<Id> finalMethod(Set<Id> conIdSet) {
        contactSize = conIdSet.size();
        return conIdSet;
    }
}