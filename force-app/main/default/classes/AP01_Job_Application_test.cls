@istest
public class AP01_Job_Application_test{
@istest
    private static void test_review_insert()
        {
        test.starttest();
        list<Job_Apllication__c> listjob= new list<Job_Apllication__c>();
        integer k= 300;
        candidate__c samer=new candidate__c();
        samer.name='samer';
        insert samer;
            for(integer i =0;i< k;i++)
            {
            Job_Apllication__c job1=new Job_Apllication__c();
            job1.name='job'+i;
            job1.tech_candidate_ID__c='samer';
            listjob.add(job1);
               
            }
    insert listjob;
    list<Job_Apllication__c> job =[select Candidate__c
                                   from Job_Apllication__c
                                   where tech_candidate_ID__c='samer'];
    for(Job_Apllication__c jobb:job)
    {
    system.assertequals(jobb.candidate__c,samer.id);       
    
    }
    test.stoptest();
}
}