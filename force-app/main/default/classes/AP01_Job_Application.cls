/*

*/
public class AP01_Job_Application
{
    public static void creer_review(list<Job_Apllication__c> listjob)
    {
        list<review__c> list1 = new list<review__c>();
        for(Job_Apllication__c jobapp:listjob)
        {
        review__c review = new review__c();
        review.Job_Apllication__c = jobapp.id;
        review.name='first review';
        review.Recommend_for_hire__c=true;
        
        
        review__c review1 = new review__c();
        review1.Job_Apllication__c = jobapp.id;
        review1.name='second review';
        review1.Recommend_for_hire__c=false;
        
        review__c review2 = new review__c();
        review2.Job_Apllication__c = jobapp.id;
        review2.name='third review';
        review2.Recommend_for_hire__c=false;
        
        review__c review3 = new review__c();
        review3.Job_Apllication__c = jobapp.id;
        review3.name='fourth review';
        review3.Recommend_for_hire__c=false;
        
        review__c review5 = new review__c();
        review5.Job_Apllication__c = jobapp.id;
        review5.name='sixth review';
        review5.Recommend_for_hire__c=false;
        
        review__c review4 = new review__c();
        review4.Job_Apllication__c = jobapp.id;
        review4.name='fifth review';
        review4.Recommend_for_hire__c=false;
        
        review__c review6 = new review__c();
        review6.Job_Apllication__c = jobapp.id;
        review6.name='seventh review';
        review6.Recommend_for_hire__c=false;
        
        list1.add(review);
        list1.add(review1);
        list1.add(review2);
        list1.add(review3);
        list1.add(review4);
        list1.add(review5);
        list1.add(review6);
        }
        insert list1;
    }
}