@isTest
public class CaseHierarchiesControllerTest {

    @testSetup
    static void testSetupForCaseHierarchiesController() {

        //parent Case
        Case parentCase = new Case();
        parentCase.Subject = 'Installation Error';
        parentCase.Origin = 'Phone';
        insert parentCase;

        //child Cases
        Case childCase = new Case();
        childCase.Subject = 'Motor not working';
        childCase.Origin = 'Phone';
        childCase.ParentId = parentCase.Id;
        insert childCase;

        Case nestedChildCase = new Case();
        nestedChildCase.Subject = 'Motor not working';
        nestedChildCase.Origin = 'Phone';
        nestedChildCase.ParentId = childCase.Id;
        insert nestedChildCase;
    }

    @isTest
    public static void getAllSuperParentCaseTest() {
        Id parentCaseId = [SELECT Id,ParentId FROM Case WHERE ParentId = null LIMIT 1].Id;
        Assert.isTrue(parentCaseId != null, 'No parentId found');

        Test.startTest();
        List<Case> childCaseList = CaseHierarchiesController.getCasesWithChildrenByParentId(parentCaseId);
        Test.stopTest();
        
        Assert.isTrue(childCaseList != null, 'No child cases found');
    }
}