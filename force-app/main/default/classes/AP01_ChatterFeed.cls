public class AP01_ChatterFeed 
{
    public static void ArchiveDeletedPost(list<feedItem> ListFeedItem)
    {
        Map<id,Chatter_Deleted_post__c> MapFeedItemDeletedPost = new Map<id,Chatter_Deleted_post__c>();
        List<Chatter_deleted_comment__c> ListDeletedCommentToInsert = new List<Chatter_deleted_comment__c>();
        
        for(FeedItem FI: ListFeedItem)
        {
            IF(FI.Type =='TextPost')
            {
                Chatter_Deleted_post__c CDP = new Chatter_Deleted_post__c();
                CDP.name = FI.Body;
                CDP.Date_of_post__c = FI.CreatedDate;
                CDP.User_OP__c = FI.CreatedById;
                MapFeedItemDeletedPost.put(FI.Id,CDP);
            }
        }
        if(MapFeedItemDeletedPost.size() < 1)
            return;
        Insert MapFeedItemDeletedPost.values();
        
        List<feedComment> ListFeedComment =[Select id,CommentBody,InsertedById,FeedItemId,SystemModstamp 
                                            from feedComment 
                                            Where FeedItemId IN :MapFeedItemDeletedPost.keySet()];
                                            
        for(FeedComment FC: ListFeedComment)
        {
            Chatter_deleted_comment__c CDC = new Chatter_deleted_comment__c();
            CDC.name = FC.CommentBody;
            CDC.Date_of_comment__c = FC.SystemModstamp ;
            CDC.User_commenter__c= FC.InsertedById;
            CDC.Chatter_deleted_post__c= MapFeedItemDeletedPost.get(FC.FeedItemId).id;
            ListDeletedCommentToInsert.add(CDC);
        }
        if(ListDeletedCommentToInsert.size() >0)
            Insert ListDeletedCommentToInsert;
    }
    
    public static void ArchiveDeletedComment(list<FeedComment> ListFeedComment)
    {
        Map<id,Chatter_Deleted_post__c> MapFeedItemDeletedPost = new Map<id,Chatter_Deleted_post__c>();
        List<Chatter_deleted_comment__c> ListDeletedCommentToInsert = new List<Chatter_deleted_comment__c>();
        
        for(FeedComment FC: ListFeedComment)
        {
            Chatter_Deleted_post__c CDP = new Chatter_Deleted_post__c();
            CDP.name = FC.FeedItemId;
            MapFeedItemDeletedPost.put(FC.FeedItemId,CDP);
        }
        if(MapFeedItemDeletedPost.size() < 1)
            return;
        Insert MapFeedItemDeletedPost.values();
                                   
        for(FeedComment FC: ListFeedComment)
        {
            Chatter_deleted_comment__c CDC = new Chatter_deleted_comment__c();
            CDC.name = FC.CommentBody;
            CDC.Date_of_comment__c = FC.SystemModstamp ;
            CDC.User_commenter__c= FC.InsertedById;
            CDC.Chatter_deleted_post__c= MapFeedItemDeletedPost.get(FC.FeedItemId).id;
            ListDeletedCommentToInsert.add(CDC);
        }
        if(ListDeletedCommentToInsert.size() >0)
            Insert ListDeletedCommentToInsert;
    }
}