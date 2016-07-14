//
//  WhatHappendVC.m
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "WhatHappendVC.h"
#import "AppDelegate.h"

@interface WhatHappendVC ()
{
    NSString *activityName;
}

@end

@implementation WhatHappendVC

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
    KappDelgate.downloadIndx=0;
    KappDelgate.isFromWhatHappen=YES;
    
    eventVideoList=[NSMutableArray new];
    eventVideoList=[KappDelgate readAllCategory];

   
    eventList=[NSMutableArray new];
    
    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
    usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
     name=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"name"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllEventSAfterLoad:) name:@"loadVideoFromAppDelegate" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:DBInsertStmt object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         [self afterDownloadReload];
         
         if ( [[note object] isKindOfClass:[NSURL class]])
         {
             
             NSURL * fileUrl=(NSURL*)[note object];
             NSIndexPath *changedRow = [NSIndexPath
                                        indexPathForRow:KappDelgate.downloadIndx              // Use the new row
                                        inSection:0];
             EventCell * temp =(EventCell*)[eventTable cellForRowAtIndexPath:changedRow];
             
              [self addplayerInVisibleCell:temp Player:moviePlayer ContentUrl:fileUrl];
           

         }
     }];
    // Do any additional setup after loading the view.
    eventTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self getAllEvents];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:@"NewMessage" object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    //api for red icon
    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
    NSString* userId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
    NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id", nil];
    [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KRedIcon];
}
-(void)getAllEventSAfterLoad:(NSNotification *)notification
{
    [self getAllEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadVideoFromAppDelegate" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getAllEvents
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.view];
     
        [ServerManager getSharedInstance].Delegate=self;
       // NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id",[NSString stringWithFormat:@"%f",loctCoord.latitude],@"lattitude",[NSString stringWithFormat:@"%f",loctCoord.longitude],@"longitude", nil];
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"user_id", nil];//688312051269645//10153324067673651

       
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:kWhatHappning];
        
        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return eventList.count;
}


#pragma mark- selectEventTimeTitle -
-(void)selectEventTimeTitle:(NSString*)title SelectEventTime:(NSString*)timedate expiry_param:(int)expiry_param
{
    NSMutableDictionary * eventtimeDict=[[NSMutableDictionary alloc]init];
    
    NSTimeInterval interval;
    NSDate * selectedDate=[[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:timedate];
    [eventtimeDict setObject:selectedDate forKey:@"create_date"];
    
    NSDate * expireDate;
    switch (expiry_param)
    {
        case Now:
        {
            interval=3600*2;
            expireDate=[[ServerManager getSharedInstance]dateTimeInterval:interval setFormate:yyyymmddHHmmSS sinceDate:selectedDate];
            
            [eventtimeDict setObject:expireDate forKey:@"expire_date"];
            [eventtimeDict setObject:[NSNumber numberWithInt:Now] forKey:@"expiry_param"];
        }
            break;
        case Today:
        {
            interval=3600*24;
            expireDate=[[ServerManager getSharedInstance]dateTimeInterval:interval setFormate:yyyymmddHHmmSS sinceDate:selectedDate];
            
            [eventtimeDict setObject:expireDate forKey:@"expire_date"];
            [eventtimeDict setObject:[NSNumber numberWithInt:Today] forKey:@"expiry_param"];
        }
            break;
        case Thisweakend:
        {
            interval=3600*24*7;
            expireDate=[[ServerManager getSharedInstance]dateTimeInterval:interval setFormate:yyyymmddHHmmSS sinceDate:selectedDate];
            [eventtimeDict setObject:expireDate forKey:@"expire_date"];
            [eventtimeDict setObject:[NSNumber numberWithInt:Thisweakend] forKey:@"expiry_param"];
        }
            break;
        case Anytime:
        {
            
            [eventtimeDict setObject:[NSNumber numberWithInt:Anytime] forKey:@"expiry_param"];
        }
            break;
        case Other:
        {
            [eventtimeDict setObject:[NSNumber numberWithInt:Other] forKey:@"expiry_param"];
        }
            break;
            
        default:
            break;
    }
    
    
    //    NSDictionary * eventtimeDict=[NSDictionary dictionaryWithObjectsAndKeys:title,@"EventTimeName",timedate,@"enventTime",[NSNumber numberWithInt:expiry_param],@"expiry_param", nil];
    [NSUserDefaults setNSUserDefaultobject:eventtimeDict key:@"eventtimeDict"];
    
    NSLog(@"%@",[NSUserDefaults getNSUserDefaultObjectForKey:@"eventtimeDict"]);
    
    CategoryVC * categoryv=[self.storyboard instantiateViewControllerWithIdentifier:@"CategoryVC"];
    
    categoryv.currentTime=title;
    [self.navigationController pushViewController:categoryv animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell .selectionStyle=UITableViewCellSelectionStyleNone;
    [cell loadEventCellData:[eventList objectAtIndex:indexPath.row] andHeight:cell.frame.size.height];
    
   
    
    
   // [self currentPageindex:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //acitivityId=[NSString stringWithFormat:@"%@",[[eventList objectAtIndex:indexPath.row] valueForKey:@"activity_id"]];
    acitivityId=[NSString stringWithFormat:@"%@",[[eventList objectAtIndex:indexPath.row] valueForKey:@"id"]];//category_id
     toUserid=[[[eventList objectAtIndex:indexPath.row] valueForKey:@"user_id"] componentsJoinedByString:@","];
    activityName=[[eventList objectAtIndex:indexPath.row] valueForKey:@"category"];
    
    NSString * activity=[[eventList objectAtIndex:indexPath.row]  valueForKey:@"category"];

    NSMutableArray * usr_name=[NSMutableArray arrayWithArray:[[eventList objectAtIndex:indexPath.row] valueForKey:@"usr_name"]];
    
    NSString * paragraph=[NSString stringWithFormat:@"Would like to find %@ buddies?",[[eventList objectAtIndex:indexPath.row]  valueForKey:@"category"]];
    
    if (usr_name.count>0)
    {
        NSString* namestr=[usr_name componentsJoinedByString:@","];
          paragraph=[NSString stringWithFormat:@"Do you want to be %@ buddies with %@",activity,namestr];
    }
    to_IDAct=[[[eventList objectAtIndex:indexPath.row]  valueForKey:@"user_id"] firstObject];
   //    NSString * title;
    NSString * subtitle  =[NSString stringWithFormat:@"This will add %@ to my activites",activity];
    [[[UIAlertView alloc]initWithTitle:paragraph message:subtitle delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil]show];
}






#pragma mark- alertView Deegate-
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            if ([[ServerManager getSharedInstance ]checkNetwork]==YES)
            {
                [ServerManager getSharedInstance].Delegate=self;
                [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
               
                to_IDAct=@"1234";
//                NSMutableDictionary * params=[NSMutableDictionary dictionaryWithObjectsAndKeys:acitivityId,@"activity_id",to_IDAct,@"to_usrid",@"match",@"action",[[NSUserDefaults standardUserDefaults] valueForKey:@"my_id"],@"user_id", nil];//
                
                
                
                NSMutableDictionary *timedict=[NSMutableDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:@"eventtimeDict"]];
                NSDate * create_date=(NSDate*)[timedict valueForKey:@"create_date"];
                NSDate * expire_date=(NSDate*)[timedict valueForKey:@"expire_date"];
                
                NSLog(@"timedict create_date expire_date %@ %@ %@",timedict,create_date,expire_date);
                
                int expiryparam=[[timedict valueForKey:@"expiry_param"]intValue];
                if(!create_date)
                {
                    create_date=(NSDate*)@"1";
                }
                
                if(!expire_date)
                {
                    expire_date=(NSDate*)@"1";
                }

                
                NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:acitivityId,@"category_id",activityName,@"category_name",[[NSUserDefaults standardUserDefaults] valueForKey:@"my_id"],@"usr_id",[[NSUserDefaults standardUserDefaults]valueForKey:@"My_name"],@"usr_name",create_date,@"create_date",expire_date,@"expire_date",[NSNumber numberWithInt:expiryparam],@"expiry_param",  [[NSUserDefaults standardUserDefaults]valueForKey: @"City_LAT"],@"latitude",[[NSUserDefaults standardUserDefaults]valueForKey:@"City_LONG"],@"longitude",[[NSUserDefaults standardUserDefaults]valueForKey:@"Cityy"],@"place",nil];

                
                
                [[ServerManager getSharedInstance]postDataOnserver:params withrequesturl:KAddWhatHappendActivity];
 
            }
           
        }
            break;
            
        default:
            break;
    }
}


-(void)changeImage:(NSNotification *)notif
{
    [chatbtn setImage:[UIImage imageNamed:@"chat_hover"] forState:UIControlStateNormal];
}


- (IBAction)OnBack:(id)sender
{
     KappDelgate.downloadIndx=0;
     [KappDelgate popToCurrentViewController:self];
}

- (IBAction)OnChat:(id)sender
{
    [chatbtn setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
     [KappDelgate pushViewController:self NibIdentifier:@"FriendListVC"];
}


#pragma mark- scrollViewDidEndDragging-
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //NSLog(@"%@",eventTable.visibleCells);
    [self showVisibleCell];
    
}


#pragma mark-showVisibleCell-
-(void)showVisibleCell
{
    CGRect frame2 = eventTable.frame;
    NSIndexPath *indexPath ;
    
    for (EventCell *cell in eventTable.visibleCells)
    {

        CGRect selectedCellFrame = [cell.superview convertRect:cell.frame toView:self.view];
        
        if (CGRectContainsRect(frame2, selectedCellFrame))
        {
            indexPath = [eventTable indexPathForCell:cell];
            //NSLog(@"play");
            break;
        }
    }
    
    
    NSLog(@"%@",eventList);
    
    [self currentPageindex:indexPath];
}
#pragma mark-currentPageindex-
-(void)currentPageindex:(NSIndexPath*)current
{
    if (current!=nil)
    {
        if(eventList.count==0){
            return;
        }
        EventCell * temp =(EventCell*)[eventTable cellForRowAtIndexPath:current];
        
        
        if (temp!=nil)
        {
            
            NSMutableDictionary * jsondict=[NSMutableDictionary dictionaryWithDictionary:[eventList objectAtIndex:current.row]];
            
            int categoryid=[[jsondict valueForKey:@"id"] intValue];
            
            
            if ([KappDelgate.categoryidArr containsObject:[NSNumber numberWithInt:categoryid]])
            {
                NSString * video_name=[jsondict valueForKey:@"video_url"];
                video_name = [video_name stringByReplacingOccurrencesOfString:@"http://buddyappnew.herokuapp.com/files/activities/video/"
                                                               withString:@""];

                NSString * videoPath=[[DBManager getSharedInstance]getFilePath:video_name];
                
                moviePlayer=[self player];
                if (![videoPath isEqual:@"No found"])
                {
                    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",videoPath]];
                    [self addplayerInVisibleCell:temp Player:moviePlayer ContentUrl:fileUrl];
                    
                }
                
            }
            else
            {
                if ([[ServerManager getSharedInstance]checkNetwork]==YES)
                {
                  KappDelgate.downloadIndx=(int)current.row;
                 [KappDelgate dowloadStreamVideo:jsondict fileCount:(int)eventList.count andtotalCount:(int)eventList.count];
                }
            }
        
        
    }

    }
}

#pragma mark- Deleage Method 0f Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    NSLog(@"RESPONCE==%@",responseDict);
    [[ServerManager getSharedInstance]hideHud];
    
    if ([serviceurl isEqual:kWhatHappning])
    {
        KappDelgate.categoryidArr=[KappDelgate getAllCategoryId];
        int success=[[responseDict valueForKey:@"status"] intValue];
        switch (success) {
            case 1:
            {
                if(([responseDict valueForKey:@"data"]==[NSNull class])||([[responseDict valueForKey:@"data"] isEqual:@"null"])||([[responseDict valueForKey:@"data"] isEqual:@"(null)"])||([[responseDict valueForKey:@"data"] isEqual:@"<null>"])||([[responseDict valueForKey:@"data"] isEqual:@"nil"])||([[responseDict valueForKey:@"data"] isEqual:@""])||([[responseDict valueForKey:@"data"] isEqual:@"<nil>"]))
                {
                    [ServerManager showAlertView:@"Message" withmessage:@"No data found"];
                }
                
                else{
                    [eventList removeAllObjects];
                    NSMutableArray * jsonarr=[NSMutableArray arrayWithArray:[responseDict valueForKey:@"data"]];
                    if (jsonarr.count>0)
                    {
                        
                        for (int ind=0; ind<[jsonarr count]; ind++)
                        {
                            NSMutableDictionary * jsondict=[NSMutableDictionary dictionaryWithDictionary:[jsonarr objectAtIndex:ind]];
                            
                            int categoryid=[[jsondict valueForKey:@"id"] intValue];
                            
                            
                            if ([KappDelgate.categoryidArr containsObject:[NSNumber numberWithInt:categoryid]])
                            {
                                
                                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(id == %d)", categoryid];
                                NSArray * filterarr = [eventVideoList filteredArrayUsingPredicate:resultPredicate];
                                if (filterarr .count>0)
                                {
                                    NSString * video_name=[[filterarr objectAtIndex:0] valueForKey:@"video_url"] ;
                                    [jsondict setObject:video_name forKey:@"video_url"];
                                    
                                    
                                    [eventList addObject:jsondict];
                                }
                                
                                
                            }
                            
                            else
                            {
                                [eventList addObject:jsondict];
                            }
                        }
                        
                        
                        
                    }
                    if (eventList.count>0)
                    {
                        [eventTable reloadData];
                        //[self showVisibleCell];
                        
                        NSIndexPath *changedRow = [NSIndexPath
                                                   indexPathForRow:0              // Use the new row
                                                   inSection:0];
                        [self currentPageindex:changedRow];
                    }
                }
                

            }
                break;
                
            default:
                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"message"]];
                break;
        }
        
    }
    
    else if ([serviceurl isEqual:KRedIcon])
    {
        [[ServerManager getSharedInstance]hideHud];
        if ([[responseDict valueForKey:@"message_status"] isEqualToString:@"unread"])
        {
            [chatbtn setImage:[UIImage imageNamed:@"chat_hover"] forState:UIControlStateNormal];
        }
        else{
            [chatbtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        }
    }

    
    else if ([serviceurl isEqual:KaddActivity])
    {
        int success=[[responseDict valueForKey:@"success"] intValue];
        switch (success) {
            case 1:
            {
                [ServerManager showAlertView:@"Congratulate!" withmessage:[responseDict valueForKey:@"message"]];
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
    
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Message" withmessage:failureError.localizedDescription];
}

-(MPMoviePlayerController*)player
{
    
    if (moviePlayer==nil)
    {
         moviePlayer=[[MPMoviePlayerController alloc]init];
    }
    return moviePlayer;
    
    
}

-(void)addplayerInVisibleCell:(EventCell*)cell Player:(MPMoviePlayerController*)player ContentUrl:(NSURL*)contenturl
{
    [player stop];

    
    
    if (IS_IPHONE_6)
    {
        player.view.frame=CGRectMake(0, cell.jkplayerView.frame.origin.y, cell.jkplayerView.frame.size.width, cell.jkplayerView.frame.size.height+41);
    }
    else if (IS_IPHONE_6P)
    {
         player.view.frame=CGRectMake(0, cell.jkplayerView.frame.origin.y, cell.jkplayerView.frame.size.width, cell.jkplayerView.frame.size.height+41);
    }
    else{
        player.view.frame=cell.jkplayerView.frame;
    }
    
   
    //[cell insertSubview:player.view belowSubview:superview];
    [cell.jkplayerView addSubview:player.view];
    
    player.scalingMode = MPMovieScalingModeAspectFill;
    player.fullscreen=NO;
    player.controlStyle=MPMovieControlStyleNone;
    player.contentURL=contenturl;
    player.repeatMode=MPMovieRepeatModeOne;
    player.movieSourceType = MPMovieSourceTypeFile;
    [player setShouldAutoplay:YES];
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:player
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
    
    
    [player prepareToPlay];
    [player play];
    
    
    

}

#pragma mark-movieFinishedCallback-
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *_moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:_moviePlayer];
        
        
        
        
        [_moviePlayer stop];
        
        
        
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DBInsertStmt object:nil];
}


-(void)afterDownloadReload
{
    
    NSMutableArray * jsonarr=[NSMutableArray arrayWithArray:[KappDelgate readAllCategory]];
    if (jsonarr.count>0)
    {
        KappDelgate.categoryidArr=[KappDelgate getAllCategoryId];
        NSLog(@"%@ %@",KappDelgate.categoryidArr,eventList);
        if (KappDelgate.categoryidArr.count>0 && [eventList count]>0)
        {
            int ind=(int)KappDelgate.downloadIndx;
            NSLog(@"%d",ind);
            NSMutableDictionary * jsondict;
            if ([eventList count]>ind) {
                jsondict =[NSMutableDictionary dictionaryWithDictionary:[eventList objectAtIndex:ind]];
            }
            else{
                
                jsondict =[NSMutableDictionary dictionaryWithDictionary:[eventList lastObject]];
            }
            

            int categoryid=[[jsondict valueForKey:@"id"] intValue];
            // int categoryid=[[jsondict valueForKey:@"id"] intValue];
            
            if ([KappDelgate.categoryidArr containsObject:[NSNumber numberWithInt:categoryid]] && categoryid!=0)
            {
                
                int categoryid=[[jsondict valueForKey:@"id"] intValue];
                
                NSString * video_name=[jsondict valueForKey:@"video_url"] ;
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(id == %d)", categoryid];
                NSArray * filterarr = [eventList filteredArrayUsingPredicate:resultPredicate];
                if (filterarr .count>0)
                {
                    NSMutableDictionary * predDict=[filterarr objectAtIndex:0];
                    
                    [predDict setObject:video_name forKey:@"video_url"];
                    
                    [eventList replaceObjectAtIndex:ind withObject:[filterarr objectAtIndex:0]];
                    NSIndexPath *changedRow = [NSIndexPath
                                               indexPathForRow:0              // Use the new row
                                               inSection:0];
                    [self currentPageindex:changedRow];
                    
                }
                
                
            }
            
        }
        
                if (eventList.count>0)
                {
                    [eventTable reloadData];
                    //[jsonarray removeAllObjects];
        
                }
        
    }
    
}

#pragma mark- tappedOnMenu -
- (IBAction)tappedOnMenu:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
    
}
@end
