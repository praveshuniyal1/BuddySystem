//
//  ViewController.m
//  ChatMessageTableViewController
//
//  Created by Davinder on 03/11/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import "ChatViewController.h"
#import "JKModelData.h"
#import "UserProfileVC.h"
#import "MapView.h"


@interface ChatViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;

@end

@implementation ChatViewController

@synthesize messageArray,selectFreindInfoDict,profilePic,profileName,friendId,toUserId;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
        profilePic.layer.cornerRadius=profilePic.frame.size.width/2;
        profilePic.layer.masksToBounds=YES;
        profilePic.layer.borderColor=[[UIColor whiteColor] CGColor];
        profilePic.layer.borderWidth=1;
   
    
    if (IS_IPHONE_6P)
    {
        headerView.frame=CGRectMake(0, 0, 414, 54);
    }
    else if (IS_IPHONE_6)
    {
        headerView.frame=CGRectMake(0, 0, 375, 54);
    }
    
    [self.navigationController.view addSubview:headerView];
    

    NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:friendId,@"from_usrid",toUserId,@"to_usrid", nil];
    [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KReadUnread];
    
    
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;

    
    [ServerManager getSharedInstance].Delegate=self;
    
    [self initilizeInputview];
//    [self TappedOnReceiveConversesion];
//    timerRecive=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TappedOnReceiveConversesion) userInfo:nil repeats:YES];
    
   
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.collectionView.collectionViewLayout.springinessEnabled = YES;
     [self scrollToBottomAnimated:YES];
}

- (IBAction)TapedOnDot:(UIButton*)menubtn
{
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *profilrStr=[NSString stringWithFormat:@"Show %@'s Profile",profileName.text];
    NSString *commonStr=@"Things In Common";
    NSString *unmatchStr=[NSString stringWithFormat:@"Unmatch %@",profileName.text];
    
    UIAlertAction *showFriendProfile = [UIAlertAction actionWithTitle:profilrStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            [self performSelector:@selector(showFriendProfile:) withObject:nil];
                                        }];
    
    UIAlertAction *commonThings = [UIAlertAction actionWithTitle:commonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       [self performSelector:@selector(commonThings:) withObject:nil];
                                   }];
    UIAlertAction *unmatch = [UIAlertAction actionWithTitle:unmatchStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self performSelector:@selector(unmatch:) withObject:nil];
                              }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                             {
                                 [actionSheetController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                             }];
    
    
    [actionSheetController addAction:showFriendProfile];
    [actionSheetController addAction:commonThings];
    [actionSheetController addAction:unmatch];
    [actionSheetController addAction:cancel];
    
    
    //******** THIS IS THE IMPORTANT PART!!!  ***********
    actionSheetController.view.tintColor = [UIColor colorWithRed:120.0f/255.0f green:230.0f/255.0f blue:252.0f/255.0f alpha:1.0];
    
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    
    
    //[self showREDActionSheet:menubtn.center];

}

-(void)showFriendProfile:(id)sender
{
    NSString * profileLink=[NSString stringWithFormat:@"https://www.facebook.com/%@",friendId];
    NSURL *url = [NSURL URLWithString:profileLink];
    [[UIApplication sharedApplication] openURL:url];
    [menuPopview dismiss];
}
-(void)commonThings:(id)sender
{
    [timerRecive invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UserProfileVC * profileview=[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    NSMutableDictionary *selectdict=[[NSMutableDictionary alloc]init];
    [selectdict setObject:friendId forKey:@"usr_id"];
    profileview.userinfodict=[selectdict mutableCopy];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        profileview.modalPresentationStyle=UIModalPresentationFormSheet;
        
        [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
    }
    else
    {
        // [KappDelgate.navigation pushViewController:profileview animated:YES];
        [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
    }

}
-(void)unmatch:(id)sender
{
    [ServerManager getSharedInstance].Delegate=self;
    [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
    NSDictionary * userDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
    NSString * usrId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
    
    NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"user_id",friendId,@"block_user", nil];
    [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KaddActivity];
}




- (IBAction)TappedOnMapPoint:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to share your location to your friend?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self ClickOnToolBarButtons:nil];
    }
}


#pragma mark-REDActionSheet-
-(void)showREDActionSheet:(CGPoint)point
{
    menuPopview=[PopoverView showPopoverAtPoint:point inView:self.view withContentView:menuContentView delegate:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return 3;
            break;
            
        default:
            return 1;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.clipsToBounds = NO;
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowOpacity = 0.5;
    cell.layer.cornerRadius=7;
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    switch (indexPath.section) {
        case 0:
        {
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.textLabel.textColor=[ServerManager colorWithR:242 G:92 B:80 A:1];//[UIColor colorWithR:242 G:92 B:80 A:1];
        }
            break;
        case 1:
        {
            [cell setBackgroundColor:[ServerManager colorWithR:242 G:92 B:80 A:1]];
            cell.textLabel.textColor=[UIColor whiteColor];
        }
            break;
            
            
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowOpacity = 0.5;
    cell.layer.cornerRadius=12;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section)
    {
        case 0:
        {
            
            switch (indexPath.row)
            {
                case 0:
                    
                    cell.textLabel.text=[NSString stringWithFormat:@"Show %@'s Profile",profileName.text];
                    break;
                case 1:
                    
                    cell.textLabel.text=@"Things In Common";
                    break;
                case 2:
                    
                    cell.textLabel.text=[NSString stringWithFormat:@"Unmatch %@",profileName.text];
                    break;
                    
            }
            
        }
            break;
        case 1:
            cell.textLabel.text=@"Cancel";
            break;
            
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            // NSLog(@"%d",indexPath.row);
            
            switch (indexPath.row)
            {
                case 0:
                    
                {
                    // user profile
                   
                    NSString * profileLink=[NSString stringWithFormat:@"https://www.facebook.com/%@",friendId];
                    NSURL *url = [NSURL URLWithString:profileLink];
                    [[UIApplication sharedApplication] openURL:url];
                    [menuPopview dismiss];
                }
                    break;
                case 1:
                    
                    // things in commmon
                {
                    
                    [timerRecive invalidate];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    UserProfileVC * profileview=[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
                    NSMutableDictionary *selectdict=[[NSMutableDictionary alloc]init];
                    [selectdict setObject:friendId forKey:@"usr_id"];
                    profileview.userinfodict=[selectdict mutableCopy];
                    
                    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                    {
                        profileview.modalPresentationStyle=UIModalPresentationFormSheet;
                        
                        [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
                    }
                    else
                    {
                       // [KappDelgate.navigation pushViewController:profileview animated:YES];
                        [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
                    }
                    
                    [menuPopview dismiss];
                    
                }
                    
                   
                    break;
                case 2:
                {
                    // user Unmatch
                    [menuPopview dismiss];
                    if ([[ServerManager getSharedInstance ]checkNetwork]==YES)
                    {
                        [ServerManager getSharedInstance].Delegate=self;
                        [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
                        NSDictionary * userDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
                        NSString * usrId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
                        
                        NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"user_id",friendId,@"block_user", nil];
                        [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KaddActivity];
                        
                        
                    }
                    
                    
                }
                    
                    
                    break;
                    
            }
        }
            break;
            
        case 1:
            [menuPopview dismiss];
            break;
           
            
    }
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
     JSQMessage *currentMessage = [[[JKModelData getSharedInstance].messages objectAtIndex:indexPath.item] valueForKey:@"jsqmessage"];
    
    if (currentMessage.isMediaMessage) {
        id<JSQMessageMediaData> mediaItem = currentMessage.media;
        
        if ([mediaItem isKindOfClass:[JSQLocationMediaItem class]]) {
            JSQLocationMediaItem *locationItem = (JSQLocationMediaItem *)mediaItem;
            
            CLLocationCoordinate2D location=locationItem.coordinate;
           // NSString *s = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
            
            UIStoryboard * mainStoryboard=[self mainstoryboard];
            MapView * mapview=[mainStoryboard instantiateViewControllerWithIdentifier:@"MapView"];
            mapview.location=locationItem.coordinate;
            
            [self presentViewController:mapview
                               animated:YES
                             completion:nil];
            // do stuff with the image
        }
    }
    
    
    
    
    
    //[self.view addSubview:mapBackGroundView];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


//9888423315


#pragma mark-mainstoryboard-
-(UIStoryboard*)mainstoryboard
{
    UIStoryboard * mainStoryboard;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        mainStoryboard=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    else
    {
        mainStoryboard=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    return mainStoryboard;
}


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
    else if ([serviceurl isEqual:KReadUnread])
    {
        [self TappedOnReceiveConversesion];
        timerRecive=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TappedOnReceiveConversesion) userInfo:nil repeats:YES];
        
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success)
        {
            case 0:
            {
            }
                break;
            case 1:
            {
            }
                break;
                
            default:
                break;
        }
   
    }
    else if([serviceurl isEqual:KaddActivity])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                [ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"message"]];
                [KappDelgate dismissViewController:self];
            }
                break;
                
            case 0:
            {
                [ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"message"]];
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
