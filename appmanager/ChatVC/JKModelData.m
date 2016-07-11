
//

#import "JKModelData.h"




/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */
static JKModelData *sharedInstance = nil;
@implementation JKModelData
{
    //JSQMessage * locationMediaMessage;
    JSQMessage *locationMessage;
}
@synthesize kJSQSenderDisplayName,kJSQReciverDisplayName,kJSQReciverId,kJSQSenderId,kJSQReciverAvatarImage,kJSQSenderAvatarImage;
+(JKModelData*)getSharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!sharedInstance)
        {
            sharedInstance = [[self alloc] init];
        }
        //allochiamo la sharedInstance
        
    });
    return sharedInstance;
}

- (void)setSenderid:(NSString *)senderid senderDisplayname:(NSString *)senderdidplayname senderimage:(UIImage*)sendimage receiverId:(NSString *)reciverid reciverDisplayname:(NSString *)reciverdisplayname reciverImage:(UIImage*)reciverimage
{
    
    kJSQSenderId=senderid;
    kJSQSenderDisplayName=senderdidplayname;
    kJSQSenderAvatarImage=sendimage;
    kJSQReciverId=reciverid;
    kJSQReciverDisplayName=reciverdisplayname;
    kJSQReciverAvatarImage=reciverimage;
    
    [self createbubble];
}

-(void)createbubble
{
    self.messages = [NSMutableArray new];
    self.MessagesIds=[NSMutableArray new];
//    NSLog(@"%@",self.messages);
//    NSLog(@"%@", self.MessagesIds);
//    self.MessagesIds=  [self fetchMsgIds];
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    //        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JSQ"
    //                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
    //                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
    //                                                                                                 font:[UIFont systemFontOfSize:14.0f]
    //                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *senderavaterimage = [JSQMessagesAvatarImageFactory avatarImageWithImage:kJSQSenderAvatarImage
                                                                                           diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *reciverAvaterImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:kJSQReciverAvatarImage
                                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    
    
    self.avatars = @{ kJSQSenderId : senderavaterimage,
                      kJSQReciverId : reciverAvaterImage};
    //
    //
    self.users = @{ kJSQSenderId : kJSQSenderDisplayName,
                    kJSQReciverId : kJSQReciverDisplayName};
    
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    
    
    

}


#pragma mark-addTextMessage-
- (JSQMessage*)addTextMessage:(NSString*)txtMsg sendeId:(NSString*)senderid withdate:(NSDate *)date
{
     JSQMessage *textMessage;
    if ([senderid isEqualToString:kJSQReciverId])
    {
        textMessage=[JSQMessage messageWithSenderId:kJSQReciverId displayName:kJSQReciverDisplayName text:txtMsg withdate:date];
    }
    else
    {
        textMessage=[JSQMessage messageWithSenderId:kJSQSenderId displayName:kJSQSenderDisplayName text:txtMsg withdate:date];
    }
    return textMessage;
}
#pragma mark-addPhotoMediaMessage-
- (JSQMessage*)addPhotoMediaMessage:(UIImage*)image sendeId:(NSString*)senderid
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
    JSQMessage *photoMessage;
    if ([senderid isEqualToString:kJSQReciverId])
    {
        photoMessage = [JSQMessage messageWithSenderId:kJSQReciverId
                                           displayName:kJSQReciverDisplayName
                                                 media:photoItem];
    }
    else
    {
        photoMessage = [JSQMessage messageWithSenderId:kJSQSenderId
                                           displayName:kJSQSenderDisplayName
                                                 media:photoItem];
    }
    
    return photoMessage;
   // [self.messages addObject:photoMessage];
}


#pragma mark- addlocationMediaMessageLat-
-(JSQMessage*)addlocationMediaMessageLat:(CLLocationDegrees)lat longi:(CLLocationDegrees)longit sendeid:(NSString*)senderId Completion :(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
   // JSQMessage *locationMessage;
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    if ([senderId isEqualToString:kJSQReciverId])
    {
        locationMessage = [JSQMessage messageWithSenderId:kJSQReciverId
                                              displayName:kJSQReciverDisplayName
                                                    media:locationItem];
    }
    else
    {
        locationMessage = [JSQMessage messageWithSenderId:kJSQSenderId
                                              displayName:kJSQSenderDisplayName
                                                    media:locationItem];
    }
    
    return locationMessage;
    //[self.messages addObject:locationMessage];

}
-(JSQMessage*)addlocationMediaMessageLat:(CLLocationDegrees)lat longi:(CLLocationDegrees)longit sendeid:(NSString*)senderId
{
    JSQLocationMediaItemCompletionBlock completion;
    
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    // JSQMessage *locationMessage;
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    if ([senderId isEqualToString:kJSQReciverId])
    {
        locationMessage = [JSQMessage messageWithSenderId:kJSQReciverId
                                              displayName:kJSQReciverDisplayName
                                                    media:locationItem];
    }
    else
    {
        locationMessage = [JSQMessage messageWithSenderId:kJSQSenderId
                                              displayName:kJSQSenderDisplayName
                                                    media:locationItem];
    }
    
    return locationMessage;

}



#pragma mark-addVideoMediaMessage-
- (JSQMessage*)addVideoMediaMessage:(NSURL*)videoUrl sendeid:(NSString*)senderId
{
    // don't have a real video, just pretending
   // NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoUrl isReadyToPlay:YES];
    JSQMessage *videoMessage;
    if ([senderId isEqualToString:kJSQReciverId])
    {
        videoMessage = [JSQMessage messageWithSenderId:kJSQReciverId
                                           displayName:kJSQReciverDisplayName
                                                 media:videoItem];

    }
    else
    {
        videoMessage = [JSQMessage messageWithSenderId:kJSQSenderId
                                           displayName:kJSQSenderDisplayName
                                                 media:videoItem];

    }
    return videoMessage;
    //[self.messages addObject:videoMessage];
}

#pragma mark-readAllChatMessage-
-(void)readAllChatMessage
{
    NSMutableArray * getmsgs=[NSMutableArray new];
    getmsgs=[self readAllChat];

    if ([getmsgs count]>0)
    {
        
//        NSOperationQueue * myQueie=[[NSOperationQueue alloc]init];
//        [myQueie addOperationWithBlock:^{
        
            for (int msgindx=0; msgindx<[getmsgs count]; msgindx++)
            {
                NSString * msg_id=[[getmsgs objectAtIndex:msgindx] valueForKey:@"msg_id"];
                
                if (![[self.messages valueForKey:@"msg_id"] containsObject:msg_id])
                {
                    NSMutableDictionary * objectkeyDict=[NSMutableDictionary new];
                    int type_id=[[[getmsgs objectAtIndex:msgindx] valueForKey:@"type_id"] intValue];
                    NSString * from_id=[[getmsgs objectAtIndex:msgindx] valueForKey:@"from_id"];
                    NSLog(@"fromId=%@",from_id);
                    switch (type_id)
                    {
                        case 0:
                        {
                            NSString *  content=[NSString stringWithFormat:@"%@",[[getmsgs objectAtIndex:msgindx] valueForKey:@"content"]];
                            
                            NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
                            [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate *dateMessage=[dateFormater dateFromString:[[getmsgs objectAtIndex:msgindx] valueForKey:@"create_time"]];
                            NSLog(@"%@",dateMessage);
                            JSQMessage * textMessage;
                            
                            if ([from_id isEqualToString:kJSQSenderId])
                            {
                                textMessage=[self addTextMessage:content sendeId:kJSQSenderId withdate:dateMessage];
                                [objectkeyDict setValue:textMessage  forKey:@"jsqmessage"];
                                [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
                                [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
                                [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
                                [objectkeyDict setValue:msg_id forKey:@"msg_id"];
                                [self.messages addObject:objectkeyDict];
                                
                                
                                
                            }
                            else
                            {
                                textMessage=[self addTextMessage:content sendeId:kJSQReciverId withdate:dateMessage];
                                [objectkeyDict setValue:textMessage  forKey:@"jsqmessage"];
                                [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
                                [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
                                [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
                                [objectkeyDict setValue:msg_id forKey:@"msg_id"];
                                [self.messages addObject:objectkeyDict];
                                
                            }
                            
                            // txt
                            // content=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"message"]];
                            
                            
                            
                        }
                            break;
                        case 1:
                        {
                            // location
                            double latitute=[[[getmsgs objectAtIndex:msgindx] valueForKey:@"latitute"] doubleValue];
                            double longitute=[[[getmsgs objectAtIndex:msgindx] valueForKey:@"longitute"] doubleValue];
                            
                            
                            JSQMessage * locationMediaMessage;
                            
                            if ([from_id isEqualToString:kJSQSenderId])
                            {
                                
                                [self addlocationMediaMessageLat:latitute longi:longitute sendeid:kJSQSenderId ];
                                [objectkeyDict setValue:locationMessage forKey:@"jsqmessage"];
                                [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
                                [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
                                [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
                                [objectkeyDict setValue:msg_id forKey:@"msg_id"];
                                if (locationMessage!=nil) {
                                    [self.messages addObject:objectkeyDict];
                                }
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"wantReload"]==YES)
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
                                }

                               
//                                locationMediaMessage=[self addlocationMediaMessageLat:latitute longi:longitute sendeid:kJSQSenderId Completion:^{
//                                    
//                                    [objectkeyDict setValue:locationMessage forKey:@"jsqmessage"];
//                                    [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
//                                    [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
//                                    [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
//                                    [objectkeyDict setValue:msg_id forKey:@"msg_id"];
//                                    if (locationMessage!=nil) {
//                                        [self.messages addObject:objectkeyDict];
//                                    }
//                                    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"wantReload"]==YES)
//                                    {
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
//                                    }
//                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
//                                     NSLog(@"message array=%@",self.messages);
//                                }];
                                
                            }
                            else
                            {
                                
                                
                                [self addlocationMediaMessageLat:latitute longi:longitute sendeid:kJSQReciverId ];
                                [objectkeyDict setValue:locationMessage forKey:@"jsqmessage"];
                                [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
                                [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
                                [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
                                [objectkeyDict setValue:msg_id forKey:@"msg_id"];
                                if (locationMessage!=nil) {
                                    [self.messages addObject:objectkeyDict];
                                }
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"wantReload"]==YES)
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
                                }

                                
//                               locationMediaMessage=[self addlocationMediaMessageLat:latitute longi:longitute sendeid:kJSQReciverId Completion:^{
//                                   
//                                    [objectkeyDict setValue:locationMessage  forKey:@"jsqmessage"];
//                                    [objectkeyDict setValue:kJSQSenderId  forKey:@"senderid"];
//                                    [objectkeyDict setValue:kJSQReciverId  forKey:@"reciverid"];
//                                    [objectkeyDict setValue:[NSNumber numberWithInt:type_id]  forKey:@"type_id"];
//                                    [objectkeyDict setValue:msg_id forKey:@"msg_id"];
//                                   if (locationMessage!=nil) {
//                                        [self.messages addObject:objectkeyDict];
//                                   }
//                                   
//                                   if ([[NSUserDefaults standardUserDefaults]boolForKey:@"wantReload"]==YES)
//                                   {
//                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
//                                   }
//                                   
//                                   //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLocation" object:self];
//                                   
//                                NSLog(@"message array=%@",self.messages);
//                                }];
                               
                               
                            }
                            
                            NSLog(@"message array=%@",self.messages);
                            
                            //content=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"userfile"]];
                        }
                            break;
                            
                    }
                    
                }
            }

//            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
//            }];
            
//        }];

           }
    
      NSLog(@"message array=%@",self.messages);
    
    
    
   
}
//-----------------  DBManager's Methods---------------

#pragma mark- insert new message Query-
-(void)insertChatConversesion:(NSDictionary*)chatDict
{
    
     NSString *dateString=[[ServerManager getSharedInstance]getUTCFormateDate:[NSDate date]];
    
    
    int type_id=[[chatDict valueForKey:@"content_type"] intValue];
    int state=1;
    NSInteger msg_id=[[chatDict valueForKey:@"msg_id"]integerValue];
    
    NSInteger chatid=[[chatDict valueForKey:@"chat_id"]integerValue];
    double lati = 0.0;
    double longit = 0.0;
    NSString * content;
    switch (type_id) {
        case 0:
        {
            // txt
            
            //content=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"msg"]];
            content=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"message"]];
            
        }
            break;
        case 1:
        {
            // location
             lati=[[chatDict valueForKey:@"latitude"]doubleValue];
             longit=[[chatDict valueForKey:@"longitude"]doubleValue];
            
//            lati=30.7800;
//            longit=76.6900;
            
        }
            break;
       
    }
    
    
   
    if ([kJSQSenderId isEqual:[chatDict valueForKey:@"sender_user"]])
    {
       
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Messages (to_name,to_id,from_name,from_id,msg_id,session_id,content,type_id,state,create_time,latitute,longitute) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%d\",\"%ld\",\"%@\",\"%d\",\"%d\",\"%@\",\"%f\",\"%f\")",kJSQReciverDisplayName, kJSQReciverId, kJSQSenderDisplayName,kJSQSenderId,(int)msg_id,(long)chatid,content,type_id,state,dateString,lati,longit];
        
        
        [[DBManager getSharedInstance]insertQuery:insertSQL];
        
       
    }
    else
    {
      
         NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Messages (to_name,to_id,from_name,from_id,msg_id,session_id,content,type_id,state,create_time,latitute,longitute) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%d\",\"%ld\",\"%@\",\"%d\",\"%d\",\"%@\",\"%f\",\"%f\")",kJSQSenderDisplayName ,kJSQSenderId,kJSQReciverDisplayName,kJSQReciverId,(int)msg_id,(long)chatid,content,type_id,state,dateString,lati,longit];
        
       
         [[DBManager getSharedInstance]insertQuery:insertSQL];
    }
    
    
    
    
}


#pragma mark-fetchMsgIds-
-(NSMutableArray*)fetchMsgIds
{
    NSMutableArray * msgIds=[NSMutableArray new];
    NSString *selectQuery=@"SELECT msg_id FROM Messages";
    
    msgIds=[[DBManager getSharedInstance]fetchAllIds:selectQuery];
    
    return msgIds;
}

#pragma mark- Select Query-
-(NSMutableArray*)readAllChat
{
     NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Messages   WHERE ((to_id='%@'and from_id='%@')or (to_id='%@'and from_id='%@'))  order by msg_id ASC",kJSQReciverId,kJSQSenderId,kJSQSenderId,kJSQReciverId];
    return [[DBManager getSharedInstance]readallMessageQuery:querySQL];
}

#pragma mark-Update Query-
-(void)updatemsgtablelastmessge:(NSInteger)messgeId
{
    int state=1;
    NSString *updateSQL=[NSString stringWithFormat:@"UPDATE Messages SET  state='%d',msg_id='%ld' WHERE ((to_id='%@'and from_id='%@')or (from_id='%@'and to_id='%@'))",state,(long)messgeId,kJSQReciverId,kJSQSenderId,kJSQSenderId,kJSQReciverId];
    [[DBManager getSharedInstance]updateQuery:updateSQL];
}

#pragma mark- Delete Query-
-(void)deleteMessageOfSelectUser:(NSString*)selectuser
{
     NSString *querySQL = [NSString stringWithFormat: @"DELETE * FROM Messages WHERE ((to_id='%@'and from_id='%@')or (from_id='%@'and to_id='%@'))",selectuser,selectuser,selectuser,selectuser];
    [[DBManager getSharedInstance]deleteQuery:querySQL];
}
@end
