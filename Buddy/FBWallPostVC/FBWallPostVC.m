
//
//  FBWallPostVC.m
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "FBWallPostVC.h"
#import <CoreGraphics/CoreGraphics.h>


@interface FBWallPostVC ()
{
    BOOL isfirst;
    NSMutableArray *contactList;
    NSString *urlstr;
    
    NSDate *strCreateTime,*expireTime;
    
    NSString *strPostId;
    NSString *from_name;
}
@end

@implementation FBWallPostVC
int idx=0;

@synthesize SelectCatDict,address;
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
    activityView.hidden=YES;
    
    //GSEventSetBacklightLevel(0);
    
    friendlist=[NSMutableArray new];
    
    userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
    friendlist=(NSMutableArray*)[NSUserDefaults getNSUserDefaultObjectForKey:kFriendList];
    if (friendlist.count>=10) {
         friendlist = [friendlist subarrayWithRange:NSMakeRange(0, 10)];
    }
    
   
    
    if((friendlist==[NSNull class])||([friendlist isEqual:@"null"])||([friendlist isEqual:@"(null)"])||([friendlist isEqual:@"<null>"])||([friendlist isEqual:@"nil"])||([friendlist isEqual:@""])||([friendlist isEqual:@"<nil>"]))
    {
    }
    else
    {
        friendCollectionView.delegate=self;
        friendCollectionView.dataSource=self;
        [friendCollectionView reloadData];
    }
    
    
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        if ([[FBSession activeSession] isOpen])
        {
            [FBManager sharedInstance].Delegate=self;
            [[FBManager sharedInstance]getForMyFriendsList];
        }
    }

    
   
    [timeCatbtn setTintColor:[UIColor whiteColor]];
    [timeCatbtn setTitle:[SelectCatDict valueForKey:@"CatTime"] forState:UIControlStateNormal];
    
    catTitletext.text=[SelectCatDict valueForKey:@"cat_name"];
    catTitletext.textColor=[UIColor whiteColor];
    
    
    NSLog(@"%@",timeCatbtn.titleLabel.text);
    address=[SelectCatDict valueForKey:@"address"];
    
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:@"Cityy"];
    [self setPostMessage];
    [ServerManager getSharedInstance];
    [ServerManager getSharedInstance].Delegate=self;
    [self getAllUserList];
    
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectLocation:) name:@"chngLocation" object:nil];
    
    CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",loctCoord.latitude] forKey:@"City_LAT"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",loctCoord.longitude] forKey:@"City_LONG"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (contactList.count==1 || contactList.count==0)
    {
        txtFriendView.text=[NSString stringWithFormat:@"These %ld Friend will now post this message on their Facebook.",contactList.count];
    }
    
    isfirst=YES;
    [self bgplayer];
}
-(void)bgplayer
{
    NSString * filename=[SelectCatDict valueForKey:@"videoFile"];
    filename = [filename stringByReplacingOccurrencesOfString:@"http://buddyappnew.herokuapp.com/files/activities/video/"
                                         withString:@""];
    
    
    NSString * videoPath=[[DBManager getSharedInstance]getFilePath:filename];
    if (![videoPath isEqual:@"No found"])
    {
        NSURL * fileUrl= [NSURL fileURLWithPath:videoPath];
        [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
    }
    
}

-(void)PresentFbFriendPickerController
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        BOOL isActivelogin=[SCFacebook isSessionValid];
        if (isActivelogin==YES)
        {
            if (friendPickerViewController == nil) {
                // Create friend picker, and get data loaded into it.
                friendPickerViewController = [[FBFriendPickerViewController alloc] init];
                friendPickerViewController.title = @"Pick Friends";
                friendPickerViewController.delegate = self;
                
            }
            
            [friendPickerViewController loadData];
            [friendPickerViewController clearSelection];
            UINavigationController * frndNav=[[UINavigationController alloc]initWithRootViewController:friendPickerViewController];
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                frndNav.modalPresentationStyle=UIModalPresentationFormSheet;
            }
            
            [self presentViewController:frndNav animated:YES completion:nil];
        }
        
    }
    
    
}

#pragma mark- Delegate Methods Of FBFriendPickerViewController-

-(void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker handleError:(NSError *)error
{
    [ServerManager showAlertView:@"Message" withmessage:error.localizedDescription];
}
-(void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    
}
-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    
}
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)facebookViewControllerDoneWasPressed:(id)sender
{
    friendlist = [NSMutableArray arrayWithArray:((FBFriendPickerViewController *)sender).selection];
    
}
#pragma mark - Data Source Method Of Collection View-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [friendlist count];
    return [contactList count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    if (contactList.count==1)
    {
        txtFriendView.text=[NSString stringWithFormat:@"These %ld Friend will now post this message on their Facebook.",contactList.count];
    }else{
        txtFriendView.text=[NSString stringWithFormat:@"These %ld Friends will now post this message on their Facebook.",contactList.count];
    }
    
    CategoryCell *playingCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //[playingCardCell loadFBWallPostCellData:[friendlist objectAtIndex:indexPath.row]];
    [playingCardCell loadFBWallPostCellData:[contactList objectAtIndex:indexPath.row]];
    return playingCardCell;
    
}

#pragma mark-saveEventOnServer-
-(void)saveEventOnServer
{
    
    NSLog(@"%@",[NSUserDefaults getNSUserDefaultObjectForKey:@"eventtimeDict"]);
    
    NSMutableDictionary *timedict=[NSMutableDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:@"eventtimeDict"]];
    
    NSLog(@"timedict %@",timedict);
    
    NSString* myid=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
    NSString* from_name1=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"name"]];
    [[NSUserDefaults standardUserDefaults]setObject:from_name forKey:@"FromName"];
    int category_id=[[SelectCatDict valueForKey:@"cat_id"]intValue];
    NSString * category_name=[NSString stringWithFormat:@"%@",[SelectCatDict valueForKey:@"cat_name"]];
    
    int expiryparam=[[timedict valueForKey:@"expiry_param"]intValue];
    
    NSDate * create_date=(NSDate*)[timedict valueForKey:@"create_date"];
    NSDate * expire_date=(NSDate*)[timedict valueForKey:@"expire_date"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *create_dateStr=[dateFormatter stringFromDate:create_date];
     NSString *expire_dateStr=[dateFormatter stringFromDate:expire_date];
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //
    NSString *timeZone=[currentTimeZone name];
    
    NSLog(@"timedict create_date expire_date %@ %@ %@",timedict,create_date,expire_date);
    
    if(!create_date)
    {
        create_date=(NSDate*)@"1";
    }
    
    if(!expire_date)
    {
        expire_date=(NSDate*)@"1";
    }
    
    NSString*PublisStr= @"Published";
    
    NSMutableDictionary *postdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:category_id],@"category_id",category_name,@"category_name",myid,@"usr_id",from_name1,@"usr_name",address,@"place",create_dateStr,@"create_date",[NSNumber numberWithInt:expiryparam],@"expiry_param",  [[NSUserDefaults standardUserDefaults]valueForKey: @"City_LAT"],@"latitude",[[NSUserDefaults standardUserDefaults]valueForKey:@"City_LONG"],@"longitude",timeZone,@"time_zone",PublisStr,@"activity_status",expire_dateStr,@"expire_date",nil];
    

    
    strCreateTime=create_date;
    expireTime=expire_date;
    
    if ([[ServerManager getSharedInstance]checkNetwork]==YES)
    {
        [ServerManager getSharedInstance].Delegate=self;
        //[[ServerManager getSharedInstance]showactivityHub:@"Updating.." addWithView:self.navigationController.view];
        [[ServerManager getSharedInstance]postDataOnserver:postdict withrequesturl:KSaveUsrActivity];
    }
}

- (IBAction)OnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TappedOnGotIt:(id)sender
{
    //[[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.navigationController.view];
    
    if([[SelectCatDict valueForKey:@"status"] isEqualToString:@"Publish"]){
        activityView.hidden=NO;
        [self saveEventOnServer];
    }
    else{
        //[ServerManager showAlertView:@"Message" withmessage:@"You have not permission to share this activity. "];
        [self shareacitivityOnSocialNetwork];

    }
        
    
    
}

- (IBAction)TappedOnChangeLocation:(id)sender
{
    
    ILGeoNamesSearchController * locationview=[self.storyboard instantiateViewControllerWithIdentifier:@"ILGeoNamesSearchController"];
    //     UINavigationController * loactionnav=[[UINavigationController alloc]initWithRootViewController:locationview];
    
    locationview.myDelegate=self;
    UIButton * locationbtn=sender;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        //        loactionnav.navigationBarHidden=YES;
        popOver =[[UIPopoverController alloc] initWithContentViewController:locationview];
        popOver.popoverContentSize = CGSizeMake(400.0, 600.0);
        popOver.delegate=self;
        [popOver presentPopoverFromRect:locationbtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        //        loactionnav.navigationBarHidden=NO;
        [self presentViewController:locationview animated:YES completion:nil];
    }
    
}

#pragma mark- Delegate method ILGeoNamesController-
-(void)locationView:(ILGeoNamesSearchController *)locationView didselectlocation:(NSDictionary *)locationdict
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        [popOver dismissPopoverAnimated:YES];
    }
    address= [NSString stringWithFormat:@"%@",[locationdict objectForKey:kILGeoNamesNameKey]];
    [self setPostMessage];
    
}

-(void)selectLocation:(NSNotification *)notification
{
    NSLog(@"notification %@",notification);
    address= [NSString stringWithFormat:@"%@",[notification object]];
    [self setPostMessage];
}



#pragma mark- Delegate Methods of PopOverController-

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController==popOver)
    {
        [popoverController dismissPopoverAnimated:YES];
    }
}



#pragma mark-TappedOnPostFbWall-
- (IBAction)TappedOnPostFbWall:(id)sender
{
    if (contactList.count>10)
    {
        [JKAlertView showalertWithMessage:@"Your are able to post message on friend's wall.\n your friend count less than 10" title:@"Message" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Choose Friends"] alertComplitionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex==alertView.firstOtherButtonIndex)
            {
                [self PresentFbFriendPickerController];
            }
        }];
    }
    else
    {
        if([[SelectCatDict valueForKey:@"status"] isEqualToString:@"Publish"])
        {
            activityView.hidden=NO;
            [self postWallOnFriends];
        }
        else{
            //[ServerManager showAlertView:@"Message" withmessage:@"You have not permission to share this activity. "];
            [self shareacitivityOnSocialNetwork];
        }
       
    }
}

#pragma mark-postWallOnFriends-
-(void)postWallOnFriends
{
   
    
    idx=0;
    NSLog(@"user device token >>%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]);
    
    ///// amit changes
   // NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.3/%@/feed?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]]];
    
    
     NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] ]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] forKey:@"friend_id"];
    urlstr=@"facebook";
    
   // NSString *message=[NSString stringWithFormat:@"message=%@\n\n&link=%@",myWall,[SelectCatDict valueForKey:@"youtube_link"]];
    
    NSString *message=[NSString stringWithFormat:@"access_token=392003234294832|8b61486e00b73967e154980ece91511b&message=%@\n\n&link=%@",myWall,[SelectCatDict valueForKey:@"youtube_link"]];
    
    NSData *postData = [message dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlString];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    FirstTime=YES;
    
   
}

-(void)getAllUserList
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSDictionary * userinfoDicts=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
        NSString *usrId=[NSString stringWithFormat:@"%@",[userinfoDicts objectForKey:@"id"]];
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id", nil];
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:kaccessToken];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webData=[[NSMutableData alloc]init];
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[ServerManager getSharedInstance] hideHud];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
   stringResponse= [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"facebook   %@",[stringResponse valueForKey:@"id"]);
    
    
   if([urlstr isEqualToString:@"facebook"])
    {
        NSLog(@"stringResponse---->>>%@",stringResponse);

     if([stringResponse valueForKey:@"id"]!=nil)
    {

        
            //if(idx<[friendlist count])
            if(idx<[contactList count])
            {
                
                
//                strPostId=[stringResponse valueForKey:@"id"];
//                NSString * frd_id=[[friendlist objectAtIndex:idx] valueForKey:@"id"];
//                [[NSUserDefaults standardUserDefaults] setObject:[friendlist[idx] valueForKey:@"id"] forKey:@"friend_id"];
                
                
                //amit changes
                strPostId=[stringResponse valueForKey:@"id"];
                NSString * frd_id=[[contactList objectAtIndex:idx] valueForKey:@"fb_id"];
                [[NSUserDefaults standardUserDefaults] setObject:[contactList[idx] valueForKey:@"fb_id"] forKey:@"friend_id"];
                
                idx++;
                
                //            NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.3/%@/feed?access_token=%@",frd_id,[[contactList objectAtIndex:idx] valueForKey:@"access_token"] ]];
                
                // NSString *message=[NSString stringWithFormat:@"message=%@\n\n&link=%@",descriptiontxt.text,[SelectCatDict valueForKey:@"youtube_link"]];
                
                
                
                
                NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",frd_id ]];
                urlstr=@"facebook";
                
                NSString *message=[NSString stringWithFormat:@"access_token=392003234294832|8b61486e00b73967e154980ece91511b&message=%@\n\n&link=%@",[NSString stringWithFormat:@"%@ %@", descriptiontxt.text ,from_name],[SelectCatDict valueForKey:@"youtube_link"]];
                
                
                
                NSData *postData = [message dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:urlString];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:postData];
                
                // print json:
                
                NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:postData
                                                                 encoding:NSUTF8StringEncoding]);
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [connection start];
                
                
                //used for get current date and time
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
                NSString *timeZone=[currentTimeZone name];
                
                
                NSDate *now = [NSDate date];
                NSInteger sourceGMTOffset = [currentTimeZone secondsFromGMTForDate:now];
                NSTimeInterval interval = sourceGMTOffset;
                NSDate *destinationDate = [NSDate dateWithTimeInterval:interval sinceDate:now];
                NSString *currentDate=[dateFormatter stringFromDate:destinationDate];

                
                
                NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://buddyappnew.herokuapp.com/webs/post_share?"]];
                NSLog(@"%@",urli);
                
                NSString * str = [NSString stringWithFormat:@"post_id=%@&access_token=%@",[stringResponse valueForKey:@"id"],@"392003234294832|8b61486e00b73967e154980ece91511b"];
                
                
                NSLog(@"%@",str);
                NSData * postData1 = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData1 length]];
                NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
                [request1 setURL:urli];
                [request1 setHTTPMethod:@"POST"];
                [request1 setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request1 setHTTPBody:postData1];
                NSError * error = nil;
                NSURLResponse * response = nil;
                //    NSURLConnection * connec = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                NSData * data = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response error:&error];
                NSDictionary * json;
                if(data)
                {
                    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                }
                
                NSLog(@"%@",json);
                
                if((json==[NSNull class])||([json isEqual:@"null"])||([json isEqual:@"(null)"])||([json isEqual:@"<null>"])||([json isEqual:@"nil"])||([json isEqual:@""])||([json isEqual:@"<nil>"]))
                {
                    
                }
                else
                {
                    NSLog(@"Share post");
                }
                
                
            }
           else if (idx==[contactList count])
            {
                //idx++;
                
                //used for get current date and time
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
                NSString *timeZone=[currentTimeZone name];
                
                
                NSDate *now = [NSDate date];
                NSInteger sourceGMTOffset = [currentTimeZone secondsFromGMTForDate:now];
                NSTimeInterval interval = sourceGMTOffset;
                NSDate *destinationDate = [NSDate dateWithTimeInterval:interval sinceDate:now];
                NSString *currentDate=[dateFormatter stringFromDate:destinationDate];
                
                NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://buddyappnew.herokuapp.com/webs/post_share?"]];
                NSLog(@"%@",urli);
                
                
                NSString * str = [NSString stringWithFormat:@"post_id=%@&access_token=%@",[stringResponse valueForKey:@"id"],@"392003234294832|8b61486e00b73967e154980ece91511b"];
                
                
                NSLog(@"%@",str);
                NSData * postData1 = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData1 length]];
                NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
                [request1 setURL:urli];
                [request1 setHTTPMethod:@"POST"];
                [request1 setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request1 setHTTPBody:postData1];
                NSError * error = nil;
                NSURLResponse * response = nil;
                //    NSURLConnection * connec = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                NSData * data = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response error:&error];
                NSDictionary * json;
                if(data)
                {
                    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                }
                
                NSLog(@"%@",json);
                
                if((json==[NSNull class])||([json isEqual:@"null"])||([json isEqual:@"(null)"])||([json isEqual:@"<null>"])||([json isEqual:@"nil"])||([json isEqual:@""])||([json isEqual:@"<nil>"]))
                {
                    
                }
                else
                {
                    NSLog(@"Share post");
                }
                
            }
            
        
       
      }
    else if(idx<[contactList count])
    {
        NSLog(@"In contact list1.");

        NSString * frd_id=[[contactList objectAtIndex:idx] valueForKey:@"usr_id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[contactList[idx] valueForKey:@"fb_id"] forKey:@"friend_id"];
        
        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.3/%@/feed?access_token=%@",frd_id,[[contactList objectAtIndex:idx] valueForKey:@"access_token"] ]];
        
        urlstr=@"facebook";
        
        NSString *message=[NSString stringWithFormat:@"message=%@\n\n&source=%@",descriptiontxt.text,[SelectCatDict valueForKey:@"youtube_link"]];
        NSData *postData = [message dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlString];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        // print json:
        NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:postData
                                                         encoding:NSUTF8StringEncoding]);
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        
        idx++;
    }
 
    [[ServerManager getSharedInstance] hideHud];
    
    if(idx==[contactList count] && isfirst)
    {
        isfirst=NO;
        [[ServerManager getSharedInstance]hideHud];
        [self shareacitivityOnSocialNetwork];
    }
    }
    
}

//get current time and date
- (NSDate *) getCountryDateWithTimeZone:(NSString *)zone
{
    
    NSDate *now = [NSDate date];
    NSTimeZone *szone = [NSTimeZone timeZoneWithName:zone];
    
    NSInteger sourceGMTOffset = [szone secondsFromGMTForDate:now];
    NSTimeInterval interval = sourceGMTOffset;
    NSDate *destinationDate = [NSDate dateWithTimeInterval:interval sinceDate:now];
    
    return destinationDate;
}


-(void) postToWall: (NSMutableDictionary*) params
{
    //    m_postingInProgress = YES; //for not allowing multiple hits
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             //showing an alert for failure
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Post Failed"
                                       message:error.localizedDescription
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         }
         else
         {
             [[ServerManager getSharedInstance]hideHud];
         }
         //         m_postingInProgress = NO;
     }];

}
#pragma mark-TappedOnInfo-
- (IBAction)TappedOnInfo:(id)sender
{ BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSURL * videoUrl=[[NSBundle mainBundle]URLForResource:@"info" withExtension:@"mov"];
        MPMoviePlayerViewController* moviewplayer=[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
        // Start playback
        moviewplayer.moviePlayer.fullscreen=YES;
        [moviewplayer.moviePlayer prepareToPlay];
        [moviewplayer.moviePlayer play];
        [moviewplayer.moviePlayer setShouldAutoplay:YES];
        
        // Present the movie player view controller
        
        [[NSNotificationCenter defaultCenter] removeObserver:moviewplayer
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviewplayer.moviePlayer];
        // Register this class as an observer instead
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviewplayer.moviePlayer];
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:moviewplayer
                                                        name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                      object:moviewplayer.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:moviewplayer.moviePlayer];
        
        [self presentViewController:moviewplayer animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        
    }
    
}
#pragma mark  moviePlayerPlaybackStateDidChange

-(void)moviePlayerPlaybackStateDidChange:(NSNotification*)aNotification
{
    NSLog(@"change==%@",aNotification.object);
}
#pragma mark-movieFinishedCallback-
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        
        [self dismissMoviePlayerViewControllerAnimated];
        
        
    }
}


#pragma mark- Create Message for Post-
-(void)setPostMessage
{
    
    
  // amit changes
    
    NSString* name=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"tagLink"]];
    
   
     from_name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * mes;
   
    
    
    if ([[SelectCatDict valueForKey:@"CatTime"]isEqualToString:@"Now"])
    {
        mes=[NSString stringWithFormat:@"Anyone in %@ up for some %@ right %@? %@ my buddy %@ for the details ",address,catTitletext.text,[[SelectCatDict valueForKey:@"CatTime"] lowercaseString],@"Message",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserName"]];
        myWall=[NSString stringWithFormat:@"Anyone in %@ up for some %@ right %@?",address,catTitletext.text,[[SelectCatDict valueForKey:@"CatTime"] lowercaseString]];
        
        
    }
    else if ([[SelectCatDict valueForKey:@"CatTime"]isEqualToString:@"Other"])
    {
        NSString *dayDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"OtherDate"];
        mes=[NSString stringWithFormat:@"Anyone in %@ up for some %@ on %@? %@ my buddy %@ for the details ",address,catTitletext.text,dayDate,@"Message",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserName"]];
        myWall=[NSString stringWithFormat:@"Anyone in %@ up for some %@ on %@?",address,catTitletext.text,dayDate];
    }
    
    else
    {
        mes=[NSString stringWithFormat:@"Anyone in %@ up for some %@ %@? %@ my buddy %@ for the details ",address,catTitletext.text,[[SelectCatDict valueForKey:@"CatTime"] lowercaseString],@"Message",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserName"]];
        myWall=[NSString stringWithFormat:@"Anyone in %@ up for some %@ %@?",address,catTitletext.text,[[SelectCatDict valueForKey:@"CatTime"] lowercaseString]];
    }
    
    
    
  
    NSRange range = [mes rangeOfString:from_name];
    NSRange addRange=[mes rangeOfString:address];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:mes];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(range.location,range.length)];
    [string addAttributes:@{ NSUnderlineStyleAttributeName : @1 , NSStrokeColorAttributeName : [UIColor darkGrayColor]} range:addRange];
    
    descriptiontxt.attributedText=string;
    
}


#pragma mark- delegate Method's of ServerManager-
-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    NSLog(@"Response tripathi -->> %@ and serviceURL------->>> %@",responseDict,serviceurl);
    
    if ([serviceurl isEqual:KSaveUsrActivity])
    {
        int success=[[responseDict valueForKey:@"success"]intValue];
        
        switch (success)
        {
            case 1:
                [[NSUserDefaults standardUserDefaults] setObject:[responseDict valueForKey:@"activity_id"] forKey:@"activityID"];
                [self postWallOnFriends];

                break;
                
            default:
                break;
        }
    }
    else if ([serviceurl isEqual:kaccessToken])
    {
        
        int success=[[responseDict valueForKey:@"success"] intValue];
        switch (success) {
            case 1:
            {
                contactList=[[NSMutableArray alloc]init];
                
                for(int i=0;i<[[responseDict valueForKey:@"data"] count];i++)
                {
                    if([[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"access_token"] != [NSNull null])
                    {
                     [contactList addObject:[[responseDict valueForKey:@"data"] objectAtIndex:i]];
                    }
                }
                //limitation to 10 friends
                if (contactList.count>=10) {
                    contactList = [contactList subarrayWithRange:NSMakeRange(0, 10)];
                }
                
                
                
                
                friendCollectionView.delegate=self;
                friendCollectionView.dataSource=self;
                [friendCollectionView reloadData];
                
//                [self postWallOnFriends];
            }
            case 0:{
                
//                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"msg"]];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

-(void)shareacitivityOnSocialNetwork
{
          
            [[ServerManager getSharedInstance]hideHud];
    
             activityView.hidden=YES;
    
            ShareVC * shareview=[self.storyboard instantiateViewControllerWithIdentifier:@"ShareVC"];
            
            shareview.shareDict=SelectCatDict ;
            [self.navigationController pushViewController:shareview animated:YES];
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Error!!" withmessage:failureError.localizedDescription];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
