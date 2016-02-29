//
//  ViewController.m
//  ChatMessageTableViewController
//
//  Created by Davinder on 03/11/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import "ChatViewController.h"
#import "JKModelData.h"


@interface ChatViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;

@end

@implementation ChatViewController

@synthesize messageArray,selectFreindInfoDict;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;

    
    [ServerManager getSharedInstance].Delegate=self;
    
    [self initilizeInputview];
    [self TappedOnReceiveConversesion];
    timerRecive=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TappedOnReceiveConversesion) userInfo:nil repeats:YES];
    

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}


-(void)initilizeInputview
{
    

    /**
     *  You MUST set your senderId and display name
     */
    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
   NSString* from_usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
     NSString* from_name=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"name"]];
    NSData * imagedata=(NSData*)[userinfoDict valueForKey:@"imagedata"];
    UIImage * senderimage=[UIImage  imageWithData:imagedata];
  // kJSQSenderDisplayName = from_usrId;
    
    self.senderDisplayName = from_name;
    self.senderId=from_usrId;
    
    /**
     *  Load up our fake data for the demo
     */
    
    NSString * reciverid=[selectFreindInfoDict valueForKey:@"id"];
    NSString * reciverDisplayname=[selectFreindInfoDict valueForKey:@"name"];
    UIImage * reciveimage=(UIImage*)[selectFreindInfoDict valueForKey:@"image"];
    
    
    
    
    [[JKModelData getSharedInstance]setKJSQSenderId:self.senderId];
    [[JKModelData getSharedInstance]setKJSQSenderDisplayName:from_name];
    [[JKModelData getSharedInstance]setKJSQSenderAvatarImage:senderimage];
    
    [[JKModelData getSharedInstance]setKJSQReciverId:reciverid];
    [[JKModelData getSharedInstance]setKJSQReciverDisplayName:reciverDisplayname];
    [[JKModelData getSharedInstance]setKJSQReciverAvatarImage:reciveimage];
    
    [[JKModelData getSharedInstance]setSenderid:self.senderId senderDisplayname:self.senderDisplayName senderimage:senderimage receiverId:reciverid reciverDisplayname:reciverDisplayname reciverImage:reciveimage];
    /**
     *  You can set custom avatar sizes
     */

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    // This button will call the `didPressAccessoryButton:` selector on your JSQMessagesViewController subclass
   // self.inputToolbar.contentView.leftBarButtonItem = /* custom button or nil to remove */
    
    // This button will call the `didPressSendButton:` selector on your JSQMessagesViewController subclass
    //self.inputToolbar.contentView.rightBarButtonItem = /* custom button or nil to remove */
    
    // Swap buttons, move send button to the LEFT side and the attachment button to the RIGHT
    // For RTL language support
//    self.inputToolbar.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
//    self.inputToolbar.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
//    NSString * poststr=[NSString stringWithFormat:@"usr_id=%@&msg_id=12",[JKModelData getSharedInstance].kJSQReciverId];
//    [[ServerManager getSharedInstance]FetchDatafromServer:KRecivemsg withAppendString:poststr];
    // The library will call the correct selector for each button, based on this value
    //self.inputToolbar.sendButtonOnRight = NO;
    [self reloadChatMessg];
}




#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"data=%@",[JKModelData getSharedInstance].messages);
//    NSLog(@"indexPath=%ld",(long)indexPath.item);
    return [[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        return [JKModelData getSharedInstance].outgoingBubbleImageData;
    }
    else
    {
      return [JKModelData getSharedInstance].incomingBubbleImageData;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
   
    JSQMessage *message = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        // outgoing
        return [[JKModelData getSharedInstance].avatars objectForKey:message.senderId];
    }
    else {
        // incoming
        return [[JKModelData getSharedInstance].avatars objectForKey:message.senderId];
    }
    
    
    
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    
    /**
     *  iOS7-style sender name labels
     */
    
        
        if ([message.senderId isEqualToString:self.senderId]) {
            return nil;
        }
    
        
        if (indexPath.item - 1 > 0) {
            JSQMessage *previousMessage = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item - 1] valueForKey:@"jsqmessage"];
            if ([[previousMessage senderId] isEqualToString:message.senderId]) {
                return nil;
            }
        }
        
        /**
         *  Don't specify attributes to use the defaults.
         */
        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
      
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld",[[JKModelData getSharedInstance].messages count]);
    return [[JKModelData getSharedInstance].messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    
    //NSLog(@"MSEESGE%@",msg);
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId])
        {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item - 1] valueForKey:@"jsqmessage"];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


//9888423315


#pragma mark- Delegate Method of Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [[ServerManager getSharedInstance]hideHud];
    NSMutableArray * messageids=[NSMutableArray new];
    NSMutableArray * chatResponseArr=[NSMutableArray new];
    messageids=  [[JKModelData getSharedInstance] fetchMsgIds];
    if ([serviceurl isEqual:KsendMessage])
    {

        [self TappedOnReceiveConversesion];
        [self insertnewMsg:responseDict];
    }
    else if ([serviceurl isEqual:KRecivemsg])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        
        switch (success)
        {
            case 0:
            {
               [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"wantReload"];
                 [self.collectionView reloadData];
            }
                break;
            case 1:
            {
                chatResponseArr= [responseDict valueForKey:@"Chat"] ;
             // chatResponseArr= responseDict ;
                for (int msgindx=0; msgindx<[chatResponseArr count]; msgindx++)
                {
                    NSString * msgid=[[chatResponseArr objectAtIndex:msgindx] valueForKey:@"msg_id"];
                    if([messageids count]>0)
                    {
                        if (![messageids containsObject:msgid])
                        {
                            [self insertnewMsg:[chatResponseArr objectAtIndex:msgindx]];
                        }
                    }
                    else
                    {
                        [self insertnewMsg:[chatResponseArr objectAtIndex:msgindx]];
                    }
                }
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"wantReload"];
                [self reloadChatMessg];

            }
                break;
                
            default:
                break;

    }
    }
}
-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Erorr!!" withmessage:failureError.localizedDescription];
}


#pragma mark - JSQMessagesViewController method overrides

#pragma mark- Send Text Message-
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    [self sendtextMessage:text withsenderId:[JKModelData getSharedInstance].kJSQSenderId withreciverid:[JKModelData getSharedInstance].kJSQReciverId ];
    
//    NSString * myid=[[NSUserDefaults standardUserDefaults]valueForKey:@"myid"];
//    if ([myid isEqualToString:senderId])
//    {
//        
//    }
//    else
//    {
//        
//        [self sendtextMessage:text withsenderId:[JKModelData getSharedInstance].kJSQSenderId withreciverid:[JKModelData getSharedInstance].kJSQReciverId ];
//    }
//    
    
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
    //
    //    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
    //                                             senderDisplayName:senderDisplayName
    //                                                          date:date
    //                                                          text:text];
    //
    //    [[JKModelData getSharedInstance].messages addObject:message];
    //
     [self finishSendingMessageAnimated:YES];
}
#pragma mark-sendtextMessage -
-(void)sendtextMessage:(NSString*)message withsenderId:(NSString*)senderid withreciverid:(NSString*)reciverid
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSString * strDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
        NSDate * selectedDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:strDate];

        
         NSString * poststr=[NSString stringWithFormat:@"from_usrid=%@&to_usrid=%@&msg=%@&content_type=%@&date=%@",[JKModelData getSharedInstance].kJSQSenderId,[JKModelData getSharedInstance].kJSQReciverId,message,[NSNumber numberWithInt:0],strDate];
        
         NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:senderid,@"from_usrid",message,@"msg",reciverid,@"to_usrid",[NSNumber numberWithInt:0],@"content_type",selectedDate,@"date",nil];
         NSLog(@"Params=%@",params);

        [ServerManager getSharedInstance].Delegate=self;
       // [[ServerManager getSharedInstance]postDataOnserverWithAppend:poststr withrequesturl:KsendMessage withPostDic:params];
        
        [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KsendMessage];
        
         [JSQSystemSoundPlayer jsq_playMessageSentSound];
        
        
    }
    
}

#pragma mark- Attach media file and send-
- (void)didPressAccessoryButton:(UIButton *)attachmentbtn
{
    
    
    //CGRect barButtonFrame = barButton.frame;
    CGPoint point =attachmentbtn.center;
    
    
    attachmentPopView=[PopoverView showPopoverAtPoint:point inView:self.inputToolbar withContentView:menuToolbar delegate:self];
}
#pragma mark-ClickOnToolBarButtons-
- (IBAction)ClickOnToolBarButtons:(id)sender
{
    CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
    
    NSString * lati=[NSString stringWithFormat:@"%f", loctCoord.latitude];
    NSString * longi=[NSString stringWithFormat:@"%f", loctCoord.longitude];
    
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    
    if (is_net==YES)
    {
        NSString *msg=@"aa";
        NSString * strDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
        NSDate * selectedDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:strDate];
        NSString* friendid= [JKModelData getSharedInstance].kJSQReciverId ;
        NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:self.senderId,@"from_usrid",friendid,@"to_usrid",selectedDate,@"date",lati,@"latitude",longi,@"longitude",[NSNumber numberWithInt:1],@"content_type",msg,@"msg" ,nil];
        [ServerManager getSharedInstance].Delegate=self;
        [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KsendMessage];
         [JSQSystemSoundPlayer jsq_playMessageSentSound];
        
    }

}

- (IBAction)OnCancel:(id)sender
{
    [timerRecive invalidate];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-TappedOnReceiveConversesion-
-(void)TappedOnReceiveConversesion
{
    
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSMutableArray * messageids=[NSMutableArray new];
        messageids=  [[JKModelData getSharedInstance] fetchMsgIds];
        int lastmessageid=0;
        if ([messageids count]>0)
        {

            lastmessageid=[[messageids lastObject] intValue];
            
           // NSString * poststr=[NSString stringWithFormat:@"usr_id=%@&msg_id=%d",[JKModelData getSharedInstance].kJSQReciverId,lastmessageid];
            NSString * poststr=[NSString stringWithFormat:@"to_usrid=%@&from_usrid=%@&msg_id=%d",[JKModelData getSharedInstance].kJSQSenderId,[JKModelData getSharedInstance].kJSQReciverId,lastmessageid];
            [[ServerManager getSharedInstance]FetchDatafromServer:KRecivemsg withAppendString:poststr];
        }
        
        else
        {
             //NSString * poststr=[NSString stringWithFormat:@"usr_id=%@",[JKModelData getSharedInstance].kJSQReciverId];
            NSString * poststr=[NSString stringWithFormat:@"to_usrid=%@&from_usrid=%@&msg_id=%d",[JKModelData getSharedInstance].kJSQReciverId,[JKModelData getSharedInstance].kJSQSenderId,0];
            NSLog(@"Post str%@",poststr);
              [[ServerManager getSharedInstance]FetchDatafromServer:KRecivemsg withAppendString:poststr];
        }
        
        
        
    }
}


#pragma mark-reloadChatMessg- 
-(void)reloadChatMessg
{
    
    /**
     *  DEMO ONLY
     *
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:NO];

        /**
         *  Media is "finished downloading", re-display visible cells
         *
         *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
         *
         *  Reload the specific item, or simply call `reloadData`
         */
        
        [[JKModelData getSharedInstance] readAllChatMessage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"LoadLocation" object:nil];
    
    NSLog(@"message=%@",[JKModelData getSharedInstance].messages);
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self finishReceivingMessage];
       
       [self.collectionView reloadData];
}

- (void)cacheUpdated:(NSNotification *)notification
{
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)insertnewMsg:(NSDictionary*)newmsgDict
{
    
        [[JKModelData getSharedInstance] insertChatConversesion:newmsgDict];
    
}

@end
