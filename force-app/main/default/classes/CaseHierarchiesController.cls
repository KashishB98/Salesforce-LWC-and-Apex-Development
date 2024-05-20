/***********************************************************************************************************************
* @name         CaseHierarchiesController
* @author       Kashish Bansal
* @date         16/04/2024
* @description  This class is for fetching all the Case hierarchies
*/
public with sharing class CaseHierarchiesController {

    /********************************************************************************************************************
    * @description  Method behind fething Case hierarchies  
    * @return       returning List<Case>
    ********************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Case> getCasesWithChildrenByParentId(Id parentId) {
        return [SELECT Id, Origin, Subject, CaseNumber, (SELECT Id, Origin, Subject, CaseNumber FROM Cases) FROM Case WHERE ParentId = :parentId WITH USER_MODE];
    }
}