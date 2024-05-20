public class SalesforcedataSend {
    
    //GET
    public static void getDetails() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TrailheadOrgApi/services/apexrest/ktrailhead/Cases');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(req);
        Integer statusCode = response.getStatusCode();
        
        // Final Response Handling
        if (statusCode == 200) {
            System.debug('Final Response code: ' + statusCode);
            System.debug('Final Response body: ' + response.getBody());
        } else {
            System.debug('Failed with status code: ' + statusCode);
            System.debug('Final Response body: ' + response.getBody());
        }
    }
    
    //POST
    public static void createRecordTargetOrg(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TrailheadOrgApi/services/apexrest/ktrailhead/Cases');
         req.setHeader('Content-Type', 'application/json');
        req.setBody('{"subject": "Int Subject", "status": "New", "origin": "Phone", "priority": "Low"}');
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('response code:'+response.getStatusCode());
        System.debug('response body : '+response.getBody());
    }
    /*
//DELETE
@future(callout=true)
public static void deleteRecords(){ 
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:Sample_App_Cred/services/apexrest/Cases/0012w000021fTieAAE');
req.setHeader('content-type','application/json; charset=UTF-8');
req.setHeader('Accept', 'application/json');
req.setMethod('DELETE');
Http h = new Http();
HttpResponse response = h.send(req);
System.debug('response code:'+response.getStatusCode());
System.debug('response body : '+response.getBody());
}

//PUT
@future(callout=true)
public static void upsertMultipleRecorsUsingPut() {
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:Sample_App_Cred/services/apexrest/Account/');
req.setHeader('Content-Type', 'application/json; charset=UTF-8');
req.setHeader('Accept', 'application/json');
req.setBody('[{ "Name": "Andrew1","Phone": "96304571464","City2__c" : "jaipur","External_ID__c":"0012w0000225gKyAAI"},{ "Name": "OMO1","Phone": "96304571464","City2__c":"jaipur","External_ID__c":"0012w0000225gKzAAI"},{ "Name": "Aruni","Phone": "96304591464","City2__c" :"jaipur","External_ID__c":"0012w0000225KyzzAI"}]');
req.setMethod('PUT'); 
Http h = new Http();
HttpResponse response = h.send(req);
System.debug('response code: ' + response.getStatusCode());
System.debug('response body: ' + response.getBody());
}
*/
}