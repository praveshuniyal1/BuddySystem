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
}

-(void)changeImage:(NSNotification *)notif
{

    [chatbtn setBackgroundImage:[UIImage imageNamed:@"chat_hover"] forState:UIControlStateNormal];
}

-(void)bgplayer
{
    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[[ServerManager getSharedInstance]getVideoPath_name:@"login"]]];
    [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[LocationManager locationInstance]getcurrentLocation];
    [super viewWillAppear:animated];
    [self bgplayer];
}
- (IBAction)TappedOnTime:(UIButton*)timebtn
{
    switch (timebtn.tag)
    {
        case 100:
        {
            // now
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"Now" SelectEventTime:time expiry_param:0];
        }
            break;
        case 101:
        {
            // today
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"Today" SelectEventTime:time expiry_param:1];
        }
            break;
        case 102:
        {
            // this weekend
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"expiry_param"];
            [self selectEventTimeTitle:@"This Weekend" SelectEventTime:time expiry_param:2];
        }
             break;
        case 103:
        {
            // anytime
            NSString * time=  [[ServerManager getSharedInstance]setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:[NSDate date]];
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
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"E MMM dd"];
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
