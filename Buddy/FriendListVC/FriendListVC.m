//
//  FriendListVC.m
//  BuddySystem
//
//  Created by Jitendra on 14/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "FriendListVC.h"
#import "UIColor+JP.h"
@interface FriendListVC ()

@end

@implementation FriendListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];

    searchResults=[NSMutableArray new];
    contactList =[NSMutableArray new];
    
    topbarView.clipsToBounds = NO;
     topbarView.layer.shadowRadius = 10.0;
   topbarView.layer.shadowColor = [[UIColor grayColor] CGColor];
    topbarView.layer.shadowOffset = CGSizeMake(0,2);
    topbarView.layer.shadowOpacity = 0.9;
    topbarView.layer.cornerRadius=7;
    //topbarView.layer.backgroundColor = [UIColor whiteColor]. CGColor;
    topbarView.layer.masksToBounds = YES;
    
    searchtext.placeholder=@"Search by name..";
//    [ServerManager changeTextColorOfSearchBarButton:[UIColor colorWithRed:242/255 green:92/255 blue:80/255 alpha:1]];
//   
    // Do any additional setup after loading the view.
    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
    usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
    name=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"name"]];
    [self getAllUserList];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:72 alpha:.08];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(handleRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [contactTable addSubview:self.refreshControl];

}


-(void)getAllUserList
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.view];
        // NSString * poststr=[NSString stringWithFormat:@"usr_id=%@&usr_name=%@",usrId,name];
        [ServerManager getSharedInstance].Delegate=self;
        
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id", nil];
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:KUserFriendlist];
        
        
    }
}

- (void)handleRefresh
{
    // Reload table data
    // End the refreshing
    if (self.refreshControl) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(queue, ^{
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor darkGrayColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
            if (is_net==YES)
            {
                
                NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id", nil];
                [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:KUserFriendlist];
                
                [self.refreshControl beginRefreshing];
            }
            
            
        });
        
        
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
        
    } else {
         return [contactList count];;
    }
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[contactTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        
        [cell loadFriendCellData:[searchResults objectAtIndex:indexPath.row] ShowSearchBarController:NO];
    } else
    {
        
        
        [cell loadFriendCellData:[contactList objectAtIndex:indexPath.row]ShowSearchBarController:NO];
    }

    
    cell.btnUserimage.tag=indexPath.row;
    [cell.btnUserimage addTarget:self action:@selector(TappedOnUserProfileVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.navigationController.view];
    NSMutableDictionary * selectdict;
    if (self.searchDisplayController.active)
    {
        didindexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        selectdict=[NSMutableDictionary dictionaryWithDictionary:[searchResults objectAtIndex:didindexPath.row]];
        [self HideSearchController];
    }
    else
    {
        didindexPath = [contactTable indexPathForSelectedRow];
        selectdict=[NSMutableDictionary dictionaryWithDictionary:[contactList objectAtIndex:didindexPath.row]];
    }
    
    
    ChatViewController * chatview=[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
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


#pragma mark- UIserView's Delegate methods-
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *searchWordProtection = [searchtext.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Length: %lu",(unsigned long)searchWordProtection.length);
    if (searchWordProtection.length != 0) {
        
         [self filterContentForSearchText:searchWordProtection];
        
    } else {
        NSLog(@"The searcTextField is empty.");
    }
    
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *searchWordProtection = [searchtext.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Length: %lu",(unsigned long)searchWordProtection.length);
    if (searchWordProtection.length != 0)
    {
        
        [self filterContentForSearchText:searchWordProtection];
        
    } else {
        NSLog(@"The searcTextField is empty.");
    }
    
}

#pragma mark-filterContentForSearchText-
- (void)filterContentForSearchText:(NSString*)searchText
{

    
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        
        // NSString * poststr=[NSString stringWithFormat:@"usr_id=%@&usr_name=%@",usrId,name];
        [ServerManager getSharedInstance].Delegate=self;
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id",searchText,@"username", nil];
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:KSearch];
        
        
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller

{
    
    [self showSearchController];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
   
  [self HideSearchController];
   
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self HideSearchController];
}
-(void)showSearchController
{
    [UIView animateWithDuration:0.2 animations:^{
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[self.view layer] addAnimation:animation forKey:@"Fade"];
        contactTable.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [CATransaction commit];
       
    }];
}

-(void)HideSearchController
{
    [UIView animateWithDuration:0.2 animations:^{
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[self.view layer] addAnimation:animation forKey:@"Fade"];
         contactTable.frame=CGRectMake(0, topbarView.frame.size.height+topbarView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-topbarView.frame.size.height);
        
        [CATransaction commit];
        
    }];
}



#pragma mark- -TappedOnUserProfileVC-
-(void)TappedOnUserProfileVC:(UIButton*)btn
{
    NSMutableDictionary*selectdict;
    int btnindex=(int)btn.tag;
    if (self.searchDisplayController.active)
    {
        selectdict=[NSMutableDictionary dictionaryWithDictionary:[searchResults objectAtIndex:btnindex]];
    }
    else
    {
         selectdict=[NSMutableDictionary dictionaryWithDictionary:[contactList objectAtIndex:btnindex]];
    }
    UserProfileVC * profileview=[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    profileview.userinfodict=[selectdict mutableCopy];
//    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:profileview];
//    nav.navigationBarHidden=YES;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        profileview.modalPresentationStyle=UIModalPresentationFormSheet;
        
        [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
    }
    else
    {
         [KappDelgate.navigation presentViewController:profileview animated:YES completion:nil];
    }
}

#pragma mark--OnBack--
- (IBAction)OnBack:(id)sender
{
    
    [KappDelgate popToCurrentViewController:self];
}


#pragma mark- Deleage Method 0f Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [self.refreshControl endRefreshing];

    [[ServerManager getSharedInstance]hideHud];
    if ([serviceurl isEqual:KUserFriendlist])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                contactList=[responseDict valueForKey:@"data"];
                if (contactList.count>0)
                {
                    [contactTable reloadData];
                }
            }
                break;
            case 0:
            {
            
                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"message"]];
           }
               break;
                
            default:
                break;
        }
        
    }
    
    else if ([serviceurl isEqual:KSearch])
    {
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                searchResults=[NSMutableArray new];
                searchResults=[responseDict valueForKey:@"data"];
                if (searchResults.count>0)
                {
                    
                    [self.searchDisplayController.searchResultsTableView reloadData];
                    
                }
                else{
                    [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"msg"]];
                    
                }
            }
                break;
                
            default:
                //[ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"message"]];
                break;
        }
 
    }
    
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Message" withmessage:failureError.localizedDescription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
