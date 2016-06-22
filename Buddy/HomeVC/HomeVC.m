//
//  HomeVC.m
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

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
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (int i=0; i<=12; i++)
    {
        [arr addObject:@"a"];
    }
    
   
    
    for(UIVisualEffectView * effectview in visibleEffectView)
    {
        [[ServerManager getSharedInstance]UIVisualEffect:effectview];
    }    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:@"NewMessage" object:nil];
    
    [[ServerManager getSharedInstance]showactivityHub:@"loading.." addWithView:self.navigationController.view];
    [self getMineAppSFriends];
    
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSMutableArray *arr=[NSMutableArray new];
//    arr=[arr objectAtIndex:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code in background
        [[LocationManager locationInstance]getcurrentLocation];
    });
    
    
    [self bgplayer];
}


-(void) getMineAppSFriends
{
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              NSMutableDictionary *userinfoDict=[[NSMutableDictionary alloc]init];
                              
                              NSArray *friendList = [result objectForKey:@"data"];
                              NSLog(@"%@",friendList);
                              
                              
                                  NSString *jsonString;
                                  if (friendList.count>0)
                                  {
                                      [NSUserDefaults setNSUserDefaultobject:friendList key:kFriendList];
                                      
                                      
                                      if (friendList.count>=10) {
                                          
                                          // userFriendList = [userFriendList subarrayWithRange:NSMakeRange(0, 10)];
                                          jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:friendList];
                                          [userinfoDict setObject:jsonString forKey:@"friend_list"];
                                      }
                                      else{
                                          jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:friendList];
                                          [userinfoDict setObject:jsonString forKey:@"friend_list"];
                                      }
                                      
                                  }
                                  else if (friendList.count==0)
                                  {
                                      
                                      [NSUserDefaults setNSUserDefaultobject:@"null" key:kFriendList];
                                      friendList=[[NSMutableArray alloc]initWithObjects:@"null", nil];
                                      jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:friendList];
                                      NSLog(@"%@",jsonString);
                                      [userinfoDict setObject:@"null" forKey:@"friend_list"];
                                  }
                                  
                                  NSLog(@"jsonData as string:\n%@", jsonString);
                                  
                                  [userinfoDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] forKey:@"user_id"];
                                [userinfoDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"] forKey:@"access_token"];
                              
                                  [self signUpwithFB:userinfoDict];
                           
                              
                          }];
}



#pragma mark-signUpwithFB-
-(void)signUpwithFB:(NSDictionary*)userinfo
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        [ServerManager getSharedInstance].Delegate=self;
       
        [[ServerManager getSharedInstance]postDataOnserver:userinfo withrequesturl:KupdateFrindList];
        
    }
}

#pragma mark- delegate Method's of ServerManager-
-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    NSLog(@"Response tripathi -->> %@ and serviceURL------->>> %@",responseDict,serviceurl);
     [[ServerManager getSharedInstance]hideHud];
    if ([serviceurl isEqual:KSaveUsrActivity])
    {
        int success=[[responseDict valueForKey:@"success"]intValue];
    }
}
-(void)failureRsponseError:(NSError *)failureError
    {
        [[ServerManager getSharedInstance]hideHud];
        [ServerManager showAlertView:@"Error!!" withmessage:failureError.localizedDescription];
    }


#pragma other work
-(void)changeImage:(NSNotification *)notif
{

    [chatbtn setBackgroundImage:[UIImage imageNamed:@"chat_hover"] forState:UIControlStateNormal];
}

-(void)bgplayer
{
    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[[ServerManager getSharedInstance]getVideoPath_name:@"login"]]];
    [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
}


- (IBAction)TappedOnTime:(UIButton*)timebtn
{
//    NSDate *now = [NSDate date];
//    NSDate *startOfToday = nil;
//    NSDate *startOfThisWeek = nil;
//    NSDate *startOfThisMonth = nil;
//    NSDate *startOfThisYear = nil;
//    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startOfToday interval:NULL forDate:now];
//    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekday startDate:&startOfThisWeek interval:NULL forDate:now];
//    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startOfThisMonth interval:NULL forDate:now];
//    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitYear startDate:&startOfThisYear interval:NULL forDate:now];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterFullStyle];
//    [formatter setTimeStyle:NSDateFormatterFullStyle];
    
//    NSLog(@"%@", now);
//    NSLog(@"%@", [formatter stringFromDate:now]);
    
    NSString *dateString=[self getPastDateFromString:[NSDate date]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormat dateFromString:dateString];
    
  
    
    
    
    switch (timebtn.tag)
    {
        case 100:
        {
            // now
//            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:date];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"Now" SelectEventTime:time expiry_param:0];
        }
            break;
        case 101:
        {
            // today
//            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:date];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"Today" SelectEventTime:time expiry_param:1];
        }
            break;
        case 102:
        {
            // this weekend
//            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
             NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:date];
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"This Weekend" SelectEventTime:time expiry_param:2];
        }
             break;
        case 103:
        {
            // anytime
//            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
             NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:date];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"Any Time" SelectEventTime:time expiry_param:3];
        }
            break;
        case 104:
        {
            // other
            [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"expiry_param"];
           //UIControl *barButton =timebtn;
            UIVisualEffectView * visbleview=[visibleEffectView objectAtIndex:timebtn.tag-100];
            CGPoint point =visbleview.center;
           // [self showCalenderPop:point intView:timebtn];
           
            
            jkClaenderView=[[JkDateTimePicker alloc]initDateTimepickerFrame:CGRectMake(0, 0, 268, 221) pickerMode:DateTimeMode];
           
            jkClaenderView.Delegate=self;
            jkClaenderView.pickerMode=DateTimeMode;
            jkClaenderView.showToolBar=YES;
            [jkClaenderView showToolBar:YES];
           pv = [PopoverView showPopoverAtPoint:point inView:self.view withContentView:jkClaenderView delegate:self];
    
        }
            break;
          
            
        default:
            break;
    }
   
}

-(NSString *)getPastDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
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



#pragma mark- delegate Methods Of JkDateTimePicker-
-(void)jkdatetimepicker:(JkDateTimePicker *)jkdatetimepicker didselectdatetime:(NSString *)selectdatetime currentMode:(NSString *)datetimemode
{
    if ([datetimemode isEqual:@"Done"])
    {
       [pv dismiss:YES];
        if ([selectdatetime isKindOfClass:[NSNull class]])
        {
            return;
        }
        ///Changes done
        
        NSString *dateString = selectdatetime;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        // Convert date object into desired format
       // [dateFormatter setDateFormat:@"E MMM dd"];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        
        [[NSUserDefaults standardUserDefaults]setObject:newDateString forKey:@"OtherDate"];
        [self selectEventTimeTitle:@"Other" SelectEventTime:selectdatetime expiry_param:4];
    }
}

-(void)jkdatetimepicker:(JkDateTimePicker *)jkdatetimepicker hide:(BOOL)animation
{
    [pv dismiss:YES];
}
-(void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s item:%ld", __PRETTY_FUNCTION__, (long)index);
}
-(void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    pv = nil;
}

#pragma mark- tappedOnMenu -
- (IBAction)tappedOnMenu:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
   
}

#pragma mark- tappedOnChat -
- (IBAction)tappedOnChat:(id)sender
{
    [chatbtn setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
     [KappDelgate pushViewController:self NibIdentifier:@"FriendListVC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





@end
