public class ContactController {
    
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(String recordId,Integer offsetVal, Integer pageSizeval)
    {
        List<Contact> conList = new List<Contact>();
        if(offSetVal != null && pageSizeval != null && recordId != null){
            conList = [SELECT AccountId,Name,Email,Phone FROM Contact WHERE AccountId = :recordId LIMIT :pageSizeval OFFSET :offsetVal];
        }

        else{
            conList = [SELECT AccountId,Name,Email,Phone FROM Contact];
        }
        return conList;
    }

        @AuraEnabled(cacheable = true)
    public static List<Contact> getContactsChild(String recordId,Integer offsetVal, Integer pageSizeval)
    {
        List<Contact> conList = new List<Contact>();
        if(offSetVal != null && pageSizeval != null && recordId != null){
            conList = [SELECT AccountId,Name,Email,Phone FROM Contact WHERE AccountId = :recordId LIMIT :pageSizeval OFFSET :offsetVal];
        }

        else{
            conList = [SELECT AccountId,Name,Email,Phone FROM Contact];
        }
        return conList;
    }

    @future
    @AuraEnabled
    public static void sendEmailMethod(String EmailVal)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {EmailVal};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Demo Email');
        mail.setPlainTextBody('Sending Email async and future');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
    
    public static void sendDateRangeToBatch() {
                
       Date_Range__C mcs = Date_Range__c.getInstance();
       Date startDate = mcs.Start_Date__c;
       Date endDate = mcs.Start_Date__c;
       
      DeleteContactsBatch db = new DeleteContactsBatch(startDate,endDate);
      Id jobId = Database.executeBatch(db);
    }
}