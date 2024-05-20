global class FutureMethodDemo
{
    @future
    public static void sendEmailMethod(Set<Id> OpportunityId){   
        
        // mail list for sending mails
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();        
        for(Opportunity opp : [SELECT Id,AccountId,Name,StageName,Account.Owner.Name,Account.Owner.Email,Account.Name 
                               FROM Opportunity WHERE Id IN :OpportunityId]) 
        {            
            List<String> toAddress = new List<String>();
            toAddress.add(opp.Account.Owner.Email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);            	 
            mail.setSubject('Opportunity update to Closed Won');
            mail.setHtmlBody(                    
                'Dear '+ opp.Account.Owner.Name+',' +'<br>'+'<br>'+
                'The Opportunity ' +opp.Name +' which is linked to '+ opp.Account.Name+' is closed won '+'<br>'+'<br>'
            );  
            allMails.add(mail);
        }        
        try{
            if( allMails.size() > 0 && allMails != null) {
                Messaging.sendEmail(allMails);
            }}        
        catch(Exception e){
            System.debug('Error occurred while sending mail '+e.getMessage());
            System.debug('Error occurred while sending mail at line no '+e.getLineNumber());
        }}
    
    
    public static void mixedDMLDemo() {
         Account a = new Account(Name='Test Account');
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CEO'];
        User usr = new User(alias = 'testGeek', email='test@geek.com', 
            emailencodingkey='UTF-8', lastname='Geek', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
            timezonesidkey='America/Los_Angeles', 
            username='test@geek.com');
        insert usr;
    }
}