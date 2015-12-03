//
//  SettingVC.m
//  BuddySystem
//
//  Created by Jitendra on 04/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-openOnDrawer-
- (IBAction)done:(id)sender
{
    [KappDelgate dismissViewController:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
            {
                // contact us
                [self showContactUsActionsheet];
            }
                break;
            case 1:
            {
                // Privacy Policy
            }
                break;
            case 2:
            {
                // Terms Of Services
            }
                break;
                
            
        }
        
    }
    else if (indexPath.section==1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                // logout
                [self showlogoutActionsheet];
            }
                break;
            case 1:
            {
                // Delete Account
                [self showdeleteAccountActionsheet];
            }
                break;
                
        }
    }
}

#pragma mark-showCustonActionsheet-
-(void)showContactUsActionsheet
{
    REDActionSheet *actionSheet = [[REDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesList:@"Contact us", nil];
    // [actionSheet addButtonWithTitle:@"4"];
	actionSheet.actionSheetTappedButtonAtIndexBlock = ^(REDActionSheet *actionSheet, NSUInteger buttonIndex)
    {
		//...
        switch (buttonIndex) {
            case 0:
            {
                // Partner with us
                [self openMailComposersetSubject:@"Partnerships" mailaddress:@[@"BuddySystem.com"] messagebody:@"Here is some main text in the email!"];
                
            }
                break;
            
               
            default:
                break;
        }
        
	};
	[actionSheet showInView:self.view];
}

#pragma mark- mail composer-
-(void)openMailComposersetSubject:(NSString*)txtsubject mailaddress:(NSArray*)Recipientarr messagebody:(NSString*)messagebody
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:txtsubject];
        [mail setMessageBody:messagebody isHTML:NO];
        [mail setToRecipients:Recipientarr];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

#pragma mark- delegate of Mail composer-
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark-showCustonActionsheet-
-(void)showlogoutActionsheet
{
    REDActionSheet *actionSheet = [[REDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesList: @"Logout",nil];
    // [actionSheet addButtonWithTitle:@"4"];
	actionSheet.actionSheetTappedButtonAtIndexBlock = ^(REDActionSheet *actionSheet, NSUInteger buttonIndex)
    {
		//...
        switch (buttonIndex) {
            case 0:
            {
                // logout
                BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
                if (is_net==YES)
                {
                    BOOL isActivelogin=[SCFacebook isSessionValid];
                    if (isActivelogin==YES)
                    {
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogout"];
                        [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.navigationController.view];
                        [SCFacebook logoutCallBack:^(BOOL success, id result)
                         {
                             if (success)
                             {
                                 // Alert(@"Alert", [result description]);
                                 [self logoutWithinApp];
                                
                             }
                         }];
                    }
                    
                    
                    
                }
            }
                break;
                
            default:
                break;
        }
        
	};
	[actionSheet showInView:self.view];
}

#pragma mark-showdeleteAccountActionsheet-
-(void)showdeleteAccountActionsheet
{
    REDActionSheet *actionSheet = [[REDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesList: @"Delete Account",nil];
    // [actionSheet addButtonWithTitle:@"4"];
	actionSheet.actionSheetTappedButtonAtIndexBlock = ^(REDActionSheet *actionSheet, NSUInteger buttonIndex)
    {
		//...
        switch (buttonIndex) {
            case 0:
            {
                // delete account
                
                
                [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                             parameters:nil HTTPMethod:@"delete"
                                      completionHandler:^(FBRequestConnection *connection, id result,    NSError *error)                                                                               {
                                          if (!error )
                                          {
                                              [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogout"];
                                              [SCFacebook logoutCallBack:^(BOOL success, id result)
                                               {
                                                   if (success)
                                                   {
                                                       [self closeAccount];
                                                   }
                                                   }];
                                              // Revoking the permission worked
                                              NSLog(@"Permission successfully revoked");
                                          } else {
                                              // There was an error, handle it
                                              NSLog(@"here was an error");
                                              // See https://developers.facebook.com/docs/ios/errors/
                                          }
                                      }];
                
            }
                break;
                
            default:
                break;
        }
        
	};
	[actionSheet showInView:self.view];
}


#pragma mark-closeaccount-
-(void)closeAccount
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        
        [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.navigationController.view];
        
        [ServerManager getSharedInstance].Delegate=self;
        NSDictionary * user=[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo];
        NSString*  user_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
        
        NSDictionary * param=[NSDictionary dictionaryWithObjectsAndKeys:user_id,@"usr_id", nil];
        [[ServerManager getSharedInstance]postDataOnserver:param withrequesturl:KCloseAccount];
        
    }
    
    
}

-(void)logoutWithinApp
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        
        [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.navigationController.view];
        
        [ServerManager getSharedInstance].Delegate=self;
        NSDictionary * user=[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo];
        NSString*  user_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
        
        NSDictionary * param=[NSDictionary dictionaryWithObjectsAndKeys:user_id,@"usr_id",@"logout",@"action", nil];
        [[ServerManager getSharedInstance]postDataOnserver:param withrequesturl:KLogout];
        
    }

}
#pragma mark- Delegate method of ServerManager-
-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [[ServerManager getSharedInstance]hideHud];
    if ([serviceurl isEqual:KCloseAccount])
    {
        NSInteger status=[[responseDict valueForKeyPath:@"status"] integerValue];
        
        switch (status) {
            case 0:
                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"msg"]];
                break;
            case 1:
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
                [NSUserDefaults removeNSUserDefaultObjectForKey:kLoginUserInfo];
                [NSUserDefaults removeNSUserDefaultObjectForKey:kFriendList];
                
                [[DBManager getSharedInstance]deleteQuery:@"DELETE * FROM Messages"];
                
                [KappDelgate loginView];
                
                break;
                
            default:
                break;
        }
        
        
    }
    else if ([serviceurl isEqual:KLogout])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
        [NSUserDefaults removeNSUserDefaultObjectForKey:kLoginUserInfo];
        [NSUserDefaults removeNSUserDefaultObjectForKey:kFriendList];

        [KappDelgate loginView];
    }
    
    
    
}

#pragma mark-failureRsponseError-
-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Error!!" withmessage:failureError.localizedDescription];
}



@end
