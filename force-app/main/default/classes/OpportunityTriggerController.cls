/*
************************************************************************************************************************************************
Apex Class Name    : OpportunityTriggerController
Created Date       : May 15, 2024
@description       : This is class is used for handling trigger logics
@author            : Kashish Bansal
Modification Log:
Ver   Date         Author                               Modification
1.0   15-05-2024   Kashish Bansal                       Initial Version
*************************************************************************************************************************************************
*/
public class OpportunityTriggerController {

    /*
     **********************************************************************************************************************************************
     @Method Name    : validateOpportunity
     @author         : Amit Chaudhary
     @description    : method to is used to throw error message when stage is needs analysis and probability is higher than 50%
     @param          : newList
     @return         : void
     **********************************************************************************************************************************************
     */
    public static void validateOpportunity(List<Opportunity>newList) {
        for(Opportunity opp : newList) {
                if(opp.StageName == 'Needs Analysis' && opp.Probability > 50) {
                    opp.addError('Probability cannot be greater than 50 % if stage name is needs analysis');
                }
        }
    }
    
    /*
     *********************************************************************************************************************************************
     @Method Name    : updateOpportunity
     @author         : Kashish Bansal
     @description    : method to is used to update Opportunity Won Date when Stage changes to closed won
     @param          : newList
     @param          : oldOpportunityMap
     @return         : void
     *********************************************************************************************************************************************
    */
    public static void updateOpportunity(List<Opportunity>newList, Map<Id,Opportunity>oldOpportunityMap) {
        for(Opportunity opp : newList) {
                Opportunity oldOpportunity = oldOpportunityMap.get(opp.Id);
                if(opp.StageName == 'Closed Won' && oldOpportunity.StageName != 'Closed Won') {
                    opp.WonDate__c = Date.today();
                }
            }
    }
}