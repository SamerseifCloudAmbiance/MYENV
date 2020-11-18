@istest
public class AP01_ChatterFeed_TEST{
    static testMethod void Chatter_Test()
    {
        Test.StartTest();
        FeedItem f = new FeedItem();
        f.ParentId = UserInfo.getUserId();
        f.body = 'test';
        insert f;
        list<feedcomment> listComment = new list<feedcomment>();
        For(integer i=0; i < 200 ; i++ )
        {
           Feedcomment FC = new feedcomment();
           FC.CommentBody = 'test ' + i;
           FC.FeedItemId = f.id ;
           listComment.add(FC);
        }
        insert listComment;
        Delete listComment[0];
        Delete f;
        Test.StopTest();
    }
}