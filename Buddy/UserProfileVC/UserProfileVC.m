//
//  UserProfileVC.m
//  BuddySystem
//
//  Created by Jitendra on 17/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "UserProfileVC.h"

@interface UserProfileVC ()
{
    BOOL isMessageFieldEmpty;
}

@end
#define ComINPUT_HEIGHT 60.0f
@implementation UserProfileVC
@synthesize userinfodict;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMessageFieldEmpty=YES;
    TopBarView.clipsToBounds = NO;
    TopBarView.layer.shadowColor = [[UIColor grayColor] CGColor];
    TopBarView.layer.shadowOffset = CGSizeMake(0,2);
    TopBarView.layer.shadowOpacity = 0.5;
    [self initilizeMessageView];
    
   
    // Do any additional setup after loading the view.
}

-(void)initilizeMessageView
{
    CGSize size = self.view.frame.size;
    ToolBar.frame=CGRectMake(ToolBar.frame.origin.x, size.height+2-(ComINPUT_HEIGHT-13), size.width, ComINPUT_HEIGHT-15);
    MessageText.text=@"New Message";
    MessageText.textColor=[UIColor lightGrayColor];
    MessageText.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    MessageText.layer.borderWidth=1;
    MessageText.layer.cornerRadius=5.0;
    [self.view addSubview:ToolBar];
    
     [self getAllUserList];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[inputToolBar resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
        
        // y to use
        // CGFloat inputViewFrameY = keyboardRect.origin.y + inputToolBar.frame.size.height;
        
        CGRect inputViewFrame = ToolBar.frame;
        CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
        
        [UIView animateWithDuration:2.0 animations:^{
            
            ToolBar.frame = CGRectMake(inputViewFrame.origin.x,
                                            inputViewFrameY,
                                            inputViewFrame.size.width,
                                            inputViewFrame.size.height);
            
        }];
        
        
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    //[self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
        
        CGRect inputViewFrame = ToolBar.frame;
        CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
        
        // for ipad modal form presentations
        CGFloat messageViewFrameBottom = self.view.frame.size.height - (ComINPUT_HEIGHT-15);
        if(inputViewFrameY > messageViewFrameBottom)
            
            inputViewFrameY = messageViewFrameBottom;
        
        [UIView animateWithDuration:2.0 animations:^{
            ToolBar.frame = CGRectMake(inputViewFrame.origin.x,
                                            inputViewFrameY,
                                            inputViewFrame.size.width,
                                            inputViewFrame.size.height);
            
        }];
    }];
    
}

-(void)getAllUserList
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
       NSString* to_userId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
        NSString * usrId=[NSString stringWithFormat:@"%@",[userinfodict objectForKey:@"usr_id"]];

        [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.view];
        [ServerManager getSharedInstance].Delegate=self;
        //NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id", to_userId,@"to_usrid", nil];
//<<<<<<< HEAD
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id",to_userId,@"to_usrid",  nil];
//=======
//        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:to_userId,@"to_usrid",usrId,@"usr_id",  nil];
//>>>>>>> 2381d9dc74b9c7a2608d3ce3f73838d6f32dcf0c
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:KfriendProfile];
        
        
    }
}





- (IBAction)TapedOnDots:(UIButton*)menubtn
{
   UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *profilrStr=[NSString stringWithFormat:@"Show %@'s Profile",username.text];
    NSString *commonStr=@"Things In Common";
    NSString *unmatchStr=[NSString stringWithFormat:@"Unmatch %@",username.text];
    
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
    
   
    
  // [self showREDActionSheet:menubtn.center];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)unmatch:(id)sender
{
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

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    //[self FBShare];
                    break;
                case 1:
                   // [self TwitterShare];
                    break;
                case 2:
                    //[self emailContent];
                    break;
               
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}



- (IBAction)OnBack:(id)sender
{
    [KappDelgate dismissViewController:self];
    //[KappDelgate.navigation dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OpenMenuVC:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
}

- (IBAction)TappedOnMessage:(id)sender
{
    
    if (isMessageFieldEmpty==NO)
    {
        NSString *searchWordProtection = MessageText.text;
        NSLog(@"Length: %lu",(unsigned long)searchWordProtection.length);
        if (searchWordProtection.length != 0)
        {
            
            BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
            if (is_net==YES)
            {
                [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
                NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
                NSString* from_usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
                NSString * to_userId=[NSString stringWithFormat:@"%@",[userinfodict objectForKey:@"usr_id"]];
                
                NSString * strDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
                NSDate * selectedDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:strDate];
                NSDictionary * postDict =[NSDictionary dictionaryWithObjectsAndKeys:from_usrId,@"from_usrid",to_userId,@"to_usrid",searchWordProtection,@"msg",selectedDate,@"date",[NSNumber numberWithInt:0],@"content_type",nil];
                
                
                [ServerManager getSharedInstance].Delegate=self;
                [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:KsendMessage];
                [self resignInputView];
            }
            
        }
 
    }
    else{
        
    }
    
    
    
    
}

- (IBAction)sendMap:(UIButton *)sender
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-70, 64, 44)];
    
    [self.view addSubview:bottomView];
    
    CGPoint point =bottomView.center;
    
    attachmentPopView=[PopoverView showPopoverAtPoint:point inView:self.view
                                      withContentView:menuToolBar delegate:self];
}

- (IBAction)sendLocationToFriend:(id)sender
{
    [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
    [self ClickOnToolBarButtons:userinfodict];
}

- (IBAction)TappedOnMapPoint:(UIButton*)menubtn
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to share your location to your friend?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=100;
    
    
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==1)
        {
            [self ClickOnToolBarButtons:userinfodict];
        }
        else{
            
        }
        
    }
    else
    {
        if (alertView == alertNew) {
            if (buttonIndex==0)
            {
                MessageText.text=nil;
                
                [self resignInputView];
                [self LoadChatView:userinfodict];
                
            }
        }

    }
    
    
    
}
-(void)ClickOnToolBarButtons:(NSMutableDictionary*)selectDic
{
    CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
    
    NSString * lati=[NSString stringWithFormat:@"%f", loctCoord.latitude];
    NSString * longi=[NSString stringWithFormat:@"%f", loctCoord.longitude];
    
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    
    if (is_net==YES)
    {
        NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
        NSString* from_usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
        NSString *msg=@"aa";
        NSString * strDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
        NSDate * selectedDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:strDate];
         NSString * friendid=[NSString stringWithFormat:@"%@",[selectDic valueForKey:@"usr_id"]];
        NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:from_usrId,@"from_usrid",friendid,@"to_usrid",selectedDate,@"date",lati,@"latitude",longi,@"longitude",[NSNumber numberWithInt:1],@"content_type",msg,@"msg" ,nil];
        [ServerManager getSharedInstance].Delegate=self;
        [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KsendMessage];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        
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
                     
                     cell.textLabel.text=[NSString stringWithFormat:@"Show %@'s Profile",username.text];
                     break;
                 case 1:
                     
                     cell.textLabel.text=@"Things In Common";
                     break;
                 case 2:
                     
                     cell.textLabel.text=[NSString stringWithFormat:@"Unmatch %@",username.text];
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
                    // user profile
                    NSString * profileLink=[NSString stringWithFormat:@"https://www.facebook.com/%@",friendId];
//                    UIFacebookBrowser * fbbrowser=[self.storyboard instantiateViewControllerWithIdentifier:@"UIFacebookBrowser"];
//                    fbbrowser.fblink=[NSURL URLWithString:profileLink];
//                    self.navigationController.navigationBarHidden=NO;
//                  
//                    [self.navigationController pushViewController:fbbrowser animated:YES];
                    
                    NSURL *url = [NSURL URLWithString:profileLink];
                    [[UIApplication sharedApplication] openURL:url];
                    [menuPopview dismiss];
                }
                    break;
                case 1:
                    
                    // things in commmon
                    
                    [menuPopview dismiss];
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

#pragma mark- Deleage Method 0f Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [[ServerManager getSharedInstance]hideHud];
    if ([serviceurl isEqual:KfriendProfile])
    {
//        int success=[[responseDict valueForKey:@"success"] intValue];
//        switch (success) {
//            case 1:
//            {
              // NSDictionary *contactdict=[NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
              NSDictionary *contactdict=responseDict;
                [self showProfile:contactdict];
//            }
//                break;
//                
//            default:
//                break;
 //       }
        
    }
    else  if ([serviceurl isEqual:KaddActivity])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                [ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"message"]];
                MessageText.text=nil;
                [self resignInputView];
                [KappDelgate dismissViewController:self];
            }
                break;
                
            case 0:
            {
                [ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"message"]];
                MessageText.text=nil;
                [self resignInputView];
            }
                break;
                
                
            default:
                break;
        }
        
    }
    else if([serviceurl isEqual:KsendMessage])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                //[ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"msg"]];
//                [ServerManager showAlertView:@"Message!!" withmessage:@"message send successfully"];
                
                MessageText.text=nil;
                [self resignInputView];
                [self LoadChatView:userinfodict];
                
//       alertNew=[[UIAlertView alloc]initWithTitle:@"Message!!" message:@"Message send successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OKay", nil];
//        [alertNew show];
                
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
                MessageText.text=nil;
                [self resignInputView];
                [KappDelgate dismissViewController:self];
            }
                break;
                
            case 0:
            {
                [ServerManager showAlertView:@"Message!!" withmessage:[responseDict valueForKey:@"message"]];
                MessageText.text=nil;
                [self resignInputView];
            }
                break;

                
            default:
                break;
        }

    }
    
}




-(void)LoadChatView:(NSMutableDictionary*)selectdict
{
    ChatViewController * chatview=[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatview.profileName.text =[NSString stringWithFormat:@"%@",[selectdict valueForKey:@"usr_name"]];
    chatview.friendId=[NSString stringWithFormat:@"%@",[selectdict valueForKey:@"usr_id"]];
   // chatview.toUserId=usrId;
    chatview.toUserId = [selectdict objectForKey:@"id"];
    NSURL * profileurl=[NSURL URLWithString:[selectdict valueForKey:@"profile_pic"]];
    [chatview.profilePic sd_setImageWithURL:profileurl];
    
    NSURL * imageUrl=[NSURL URLWithString:[selectdict valueForKey:@"profile_pic"]];
    NSString * frindId=[NSString stringWithFormat:@"%@",[selectdict valueForKey:@"usr_id"]];
    NSString * frindname=[NSString stringWithFormat:@"%@",[selectdict valueForKey:@"usr_name"]];
    
    NSOperationQueue * myQueie=[[NSOperationQueue alloc]init];
    [myQueie addOperationWithBlock:^{
        
        [[ServerManager getSharedInstance]getImageFromServerPath:imageUrl completed:^(UIImage *image, BOOL finished)
         {
             
             if (finished==YES)
             {
                 
                 
                 if (image)
                 {
                     [[JKModelData getSharedInstance]setKJSQReciverId:frindId];
                     [[JKModelData getSharedInstance]setKJSQReciverDisplayName:frindname];
                     [[JKModelData getSharedInstance]setKJSQReciverAvatarImage:image];
                     
                     
                 }
                 
             }
         }];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [[ServerManager getSharedInstance]hideHud];
            
            UIImage * image=[JKModelData getSharedInstance].kJSQReciverAvatarImage;
            
            NSDictionary * selectcontac=[NSDictionary dictionaryWithObjectsAndKeys:frindname,@"name",frindId,@"id",image,@"image", nil];
            chatview.selectFreindInfoDict=selectcontac;
            UINavigationController * chatnav=[[UINavigationController alloc]initWithRootViewController:chatview];
            
            [self presentViewController:chatnav animated:YES completion:nil];
            
            
        }];
        
    }];
    
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Message" withmessage:failureError.localizedDescription];
}


-(void)showProfile:(NSDictionary*)contactdict
{
    friendId=[contactdict valueForKey:@"usr_id"];
    username.text=[contactdict valueForKey:@"name"];
    
    if (![[contactdict valueForKey:@"common_activity"] isKindOfClass:[NSNull class]])
    {
        //lbl_event.text=[NSString stringWithFormat:@"%@ and more",[[contactdict valueForKey:@"common_activity"] componentsJoinedByString:@","]];
        lbl_event.text=[NSString stringWithFormat:@"You are both for %@ and more...",[[contactdict valueForKey:@"common_activity"] valueForKey:@"Activity"]];
    }
    else
    {
        lbl_event.text=@"No match any common activities";
    }
    
    NSURL * profileurl=[NSURL URLWithString:[contactdict valueForKey:@"profile_pic"]];
    for (UIImageView * profileimgv in profilepick)
    {
        [profileimgv sd_setImageWithURL:profileurl];
        profileimgv.layer.cornerRadius=profileimgv.frame.size.width/2;
        profileimgv.layer.masksToBounds=YES;
        profileimgv.layer.borderColor=[[UIColor whiteColor] CGColor];
        profileimgv.layer.borderWidth=1;
    }
    
    int mutual=[[[contactdict valueForKey:@"mutual"] valueForKey:@"type"] intValue];
    switch (mutual)
    {
        case 0:
            
            lbl_relation.text=[NSString stringWithFormat:@"%@ is friend of %@",username.text,[contactdict valueForKey:@"friend_name"]];
            break;
        case 1:
        {
            lbl_relation.text=[NSString stringWithFormat:@"%@ is mutual friends of %@",username.text,[[[contactdict valueForKey:@"mutual"] valueForKey:@"usr_name"] componentsJoinedByString:@","]];
        }
            break;
            
        default:
            break;
    }

}
#pragma mark-Delegate Method of TextView-
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([MessageText.text isEqual:@"New Message"])
    {
        isMessageFieldEmpty=NO;
        MessageText.text=@"";
        MessageText.textColor=[UIColor blackColor];
        MessageText.layer.borderColor=[[UIColor redColor]CGColor];
        
    }
    
    return YES;
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (MessageText.text.length==0)
    {
        isMessageFieldEmpty=YES;
        MessageText.text=@"New Message";
        MessageText.textColor=[UIColor lightGrayColor];
        MessageText.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        [MessageText resignFirstResponder];
        [sendButton setTintColor:[UIColor lightGrayColor]];
        
    }
    else if (![MessageText.text isEqual:@"New Message"])
    {
        isMessageFieldEmpty=NO;
        MessageText.textColor=[UIColor blackColor];
        MessageText.layer.borderColor=[[UIColor redColor]CGColor];
        [sendButton setTintColor:[UIColor blueColor]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignInputView];
}

-(void)resignInputView
{
    if (MessageText.text.length==0)
    {
        isMessageFieldEmpty=YES;
        MessageText.text=@"New Message";
        MessageText.textColor=[UIColor lightGrayColor];
        MessageText.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    }
    else if (![MessageText.text isEqual:@"New Message"])
    {
        isMessageFieldEmpty=NO;
        MessageText.textColor=[UIColor blackColor];
        MessageText.layer.borderColor=[[UIColor redColor]CGColor];
    }
    [MessageText resignFirstResponder];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
