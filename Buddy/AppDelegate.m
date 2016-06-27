//
//  AppDelegate.m
//  BuddySystem#0	0x000000010cd1e81c in -[AppDelegate application:didFinishLaunchingWithOptions:] at /Users/WebAstral/Desktop/BuddySystem/Buddy/AppDelegate.m:25

//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate
{
    BOOL isDownloadBG;
    NSTimer *idleTimer;
    NSTimeInterval *maxIdleTime;
    UIImageView *imgView;
    
}
@synthesize reciveDict,navigation,remoteNotifdict,menupopview,playerview,contentFileUrl,fromView,loginnavigation,downloadIndx,categoryidArr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO: Move this to where you establish a user session
    
   [Fabric with:@[[Crashlytics class]]];
     [self logUser];
    
    maxIdleTime=30;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    [application setStatusBarHidden:YES];

     categoryidArr=[NSMutableArray new];
   

    [[LocationManager locationInstance]getcurrentLocation];
    [[DBManager getSharedInstance]createDB];
    [self registerForRemoteNotifications];
    
    if (launchOptions != nil)
    {
        //opened from a push notification when the app is closed
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            //opened from a push notification when the app is closed
            NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (userInfo != nil)
            {
//                remoteNotifdict=[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]valueForKey:@"message"];
                 remoteNotifdict=[userInfo valueForKey:@"aps"];
                int success=[[remoteNotifdict valueForKey:@"success"] intValue];
                
                switch (success)
                {
                    case 1:
                    {
                        
                        
                        int notification_type =[[[remoteNotifdict valueForKey:@"alert"] valueForKey:@"notification_type"] intValue];
                        switch (notification_type)
                        {
                            case 1:
                            {
                                // match notification
                                
                                
                            }
                                break;
                            case 2:
                            {
                                // Chat notification
                                
                                [self getnotificationdatalaunchOptions:[remoteNotifdict valueForKey:@"alert"]];
                                
                                
                            }
                                break;
                                
                        }
                        
                    }
                        break;
                        
                        
                }

                NSLog(@"userInfo->%@",[userInfo objectForKey:@"aps"]);
                
            }
        }
        
    }
    
    else{
        //opened app without a push notification.
    }
    
    
   
    //Init SCFacebook
    [SCFacebook initWithPermissions:@[@"email",@"publish_actions",@"publish_stream",@"user_friends",@"user_posts"]];
    
   
    
    [FBLoginView class];
    [FBProfilePictureView class];
    [FBFriendPickerViewController class];
    [self detectSIMULATOR];
   

    
    BOOL isActivelogin=[SCFacebook isSessionValid];
    if (isActivelogin==YES)
    {
        [self showHomeView];
    }
    else
    {
         [self loginView];
    }

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    
    
    return YES;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"amit.verma@trigma.in"];
    [CrashlyticsKit setUserName:@"Test User"];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}





#pragma mark-LoginView-
-(void)loginView
{
    UIStoryboard * mainStoryboard=[self mainstoryboard];
    
    loginnavigation=[mainStoryboard instantiateViewControllerWithIdentifier:@"fbLoginNavigation"];
    [self hideNavigationbar:YES];
   
    [self.window setRootViewController:loginnavigation];
    // [FBManager sharedInstance].Delegate=self;
    // [[FBManager sharedInstance]checkfbLoginState];
    
}

-(void)hideNavigationbar:(BOOL)isHide
{
    if (isHide==YES)
    {
        navigation.navigationBarHidden=YES;
        loginnavigation.navigationBarHidden=YES;
    }
    else
    {
        navigation.navigationBarHidden=NO;
        loginnavigation.navigationBarHidden=YES;
    }
}

-(void)showHomeView
{
    UIStoryboard * mainStoryboard=[self mainstoryboard];
    
    navigation=[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeNavigation"];
    [self hideNavigationbar:YES];
    
    [self.window setRootViewController:navigation];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness: 1.0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness: 1.0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness: 1.0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourselector:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
     [FBAppCall handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness: 1.0];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)yourselector:(id)sender
{
    [[UIScreen mainScreen] setBrightness: 1.0];
}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//}

#pragma mark- Push notification methods-
-(void)registerForRemoteNotifications
{
    
   
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
   

}



-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokens = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokens = [deviceTokens stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"registered device token %@", deviceTokens);
    [[NSUserDefaults standardUserDefaults]setValue:deviceTokens forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"String %@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    BOOL isActivelogin=[SCFacebook isSessionValid];
    if (isActivelogin==YES)
    {
        reciveDict=[userInfo valueForKey:@"aps"];
        int notification_type =[[reciveDict valueForKey:@"notification_type"] intValue];
        

        switch (notification_type)
        {
          case 1:
          {
          [[[UIAlertView alloc]initWithTitle:@"Message" message:[reciveDict  valueForKey:@"alert"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
          }
          break;
          case 2:
          {
                    // Chat notification
                    
                   
                    
                    if ( state == UIApplicationStateInactive)
                    {
                        //Do checking here.
                        
                        [self getNotificationResponse:reciveDict activeState:YES];
                        
                        
                        
                    }
                    else
                    {
                        [self getNotificationResponse:reciveDict  activeState:NO];
                    }

                }
                break;
                    
                    
                
            }
            
        
    }
    
    
   
    
}

#pragma mark-detectSIMULATOR-
-(void)detectSIMULATOR
{
#if TARGET_IPHONE_SIMULATOR
    
    [[NSUserDefaults standardUserDefaults]setValue:@"9b41601839f9155e349e0cf49fb0d5d9ca375716a45069cd9dd796daccbdcb34" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //Simulator
    
#else
    
    // Device
    
#endif
    
}
#pragma getNotificationResponse-
-(void)getNotificationResponse:(NSDictionary*)userInfo activeState:(BOOL)isactive
{
    
    [[ServerManager getSharedInstance]shownotificationbar:userInfo];
}
-(void)getnotificationdatalaunchOptions:(NSDictionary*)userInfo
{
    
    [[ServerManager getSharedInstance]shownotificationbar:userInfo];
   // int typeNotif=[[userInfo valueForKey:@"type"] intValue];
    
    
}
- (UIControl *) findBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UINavigationBar *toolbar = self.navigation.navigationBar;
    UIControl *button = nil;
    for (UIView *subview in toolbar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            for (id target in [(UIControl *)subview allTargets]) {
                if (target == barButtonItem) {
                    button = (UIControl *)subview;
                    break;
                }
            }
            if (button != nil) break;
        }
    }
    
    return button;
}



#pragma mark-showCustomPopView-
-(void)showCustomPopView:(UIView*)containerView andAnimated:(BOOL)animated
{
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
       
        
        if(animated)
        {
            containerView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
               containerView.alpha = 1;
                
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                [self.window addSubview:containerView];
            } completion:^(BOOL finished)
            {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2)
                 {
                    containerView.layer.shouldRasterize = NO;
                    
                }];
            }];
        }
    });

}




#pragma mark-showJKPopupMenuInView -

-(void)showJKPopupMenuInView:(UIView*)superView animation:(BOOL)animation
{
    if (animation==YES)
    {
        self.fromView=superView;
        menupopview=[[JKMenuView alloc]init];
        menupopview.Delegate=self;
        menupopview.alpha=0.0;
        menupopview.frame=superView.bounds;
        
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[superView layer] addAnimation:animation forKey:@"Fade"];
        //[superView addSubviewWithZoomInAnimation:menupopview duration:1.0 option:UIViewAnimationOptionCurveLinear];

        [superView addSubview:menupopview];
        menupopview.alpha=1.0f;
              [CATransaction commit];
    }
    else if (animation==NO)
    {
        
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[superView layer] addAnimation:animation forKey:@"Fade"];
        //[menupopview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveLinear];
         menupopview.alpha=0.0;
        [menupopview removeFromSuperview];
        
        [CATransaction commit];
        
    }
    

    
}

#pragma mark-Delegate methods of JKMenu-
-(void)jkmenu:(JKMenuView *)jkmenu didselectitem:(NSInteger)itemindex
{
    
    UIStoryboard * mainStoryboard=[self mainstoryboard];
    
    switch (itemindex)
    {
        case 0:
        {
            //Do somthing
           [self hidJKPop];
            if (![navigation.visibleViewController isKindOfClass:[HomeVC class]])
            {
                if ([navigation.visibleViewController isKindOfClass:[UserProfileVC class]])
                    
                {
                    [navigation.visibleViewController dismissViewControllerAnimated:NO completion:nil];
                }
                for (UIViewController * mycontroller in navigation.viewControllers)
                {
                    if ([mycontroller isKindOfClass:[HomeVC class]])
                    {
                        [self.navigation popToRootViewControllerAnimated:YES];
                        [self hidJKPop];
                        break;
                    }
                   
                }
            }
            
            
        }
            break;
        case 1:
        {
            //WhatHappning
            [self hidJKPop];
            if (![navigation.visibleViewController isKindOfClass:[WhatHappendVC class]])
            
            {
                if ([navigation.visibleViewController isKindOfClass:[UserProfileVC class]])
                    
                {
                   [navigation.visibleViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                WhatHappendVC * happningview=[mainStoryboard instantiateViewControllerWithIdentifier:@"WhatHappendVC"];
            
            [navigation pushViewController:happningview animated:YES];
            }
            
            

        }
            break;
        case 2:
        {
            //MyActivities
            [self hidJKPop];

            if (![navigation.visibleViewController isKindOfClass:[MyActivityVC class]])
        
            {
                
                if ([navigation.visibleViewController isKindOfClass:[UserProfileVC class]])
                    
                {
                    [navigation.visibleViewController dismissViewControllerAnimated:NO completion:nil];
                }
                MyActivityVC * myactivityview=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyActivityVC"];
                [navigation pushViewController:myactivityview animated:YES];
                

                
            }
            
        }
            break;
    }
}
// Other method-

-(void)presentSettingController:(BOOL)anination
{
    if (anination==YES)
    {
        
        [self hidJKPop];
        UIStoryboard * mainStoryboard=[self mainstoryboard];
        UINavigationController * settingnav=[mainStoryboard instantiateViewControllerWithIdentifier:@"SettingNavig"];
        if ([navigation.visibleViewController isKindOfClass:[settingnav class]])
            return;
        else
        {
            
        }
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            settingnav.modalPresentationStyle=UIModalPresentationFormSheet;
            //[navigation presentViewController:settingnav animated:YES completion:nil];
        }
        
            [navigation presentViewController:settingnav animated:YES completion:nil];
        
        
    }
}
-(void)hidejkpopmenu:(BOOL)animation fromview:(UIView *)_fromView
{
    if (animation==YES)
    {
        self.fromView=_fromView;
        [self hidJKPop];
    }
}

-(void)hidJKPop
{
    [menupopview removeZoomanimation];
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [[fromView layer] addAnimation:animation forKey:@"Fade"];
    
    menupopview.alpha=0.0;
    [menupopview removeFromSuperview];
    
    [CATransaction commit];
}

#pragma mark-dismissViewController-
-(void)dismissViewController:(UIViewController*)presentcontroller
{
   
    [presentcontroller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- addPlayerInCurrentViewController -
-(void)addPlayerInCurrentViewController:(UIView*)currentview bringView:(UIView*)conetnview  MovieUrl:(NSURL*)fileurl
{
    // Background work
  //  fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[[ServerManager getSharedInstance]getVideoPath_name:@"login"]]];
    contentFileUrl=[fileurl copy];
    thumbnileimage=[UIImage imageNamed:@"D.png"];
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        
        
        [[ServerManager getSharedInstance]genrateThumbnil:contentFileUrl  thumbnilSize:currentview.frame.size  success:^(UIImage *thumbnil)
         {
             
             
             thumbnileimage=thumbnil;
         } failure:^(NSError *error) {
             
         }];
        
    }];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Main thread work (UI usually)
        UIImageView * imageview=[[ServerManager getSharedInstance]videothumnilview];
        imageview.frame=currentview.bounds;
        [currentview addSubview:imageview];
        if (thumbnileimage!=nil)
        {
            imageview.image=thumbnileimage;
        }
        if(playerview!=nil)
        {
            //[playerview initilizePlayer];
            
            [playerview removeFromSuperview];
        }
        playerview=[[JKPlayer alloc]initWithjkplayerFrame:currentview.frame withcontentUrl:contentFileUrl];
        playerview.frame=currentview.bounds;
        playerview.contenturl=contentFileUrl;
        [currentview addSubview:playerview];
        //conetnview.backgroundColor=[UIColor clearColor];
        [currentview bringSubviewToFront:conetnview];
        
        [imageview removeFromSuperview];
    }];
    

}

#pragma stopBackGroundVideo
-(void)stopBackGroundVideo
{
    [playerview stopCurrentVideo];
}
-(void)playBackGroundVideo
{
    [playerview playCurrentVideo];
}
-(void)getScreenShoots
{

    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    imgView.image=[self screenshot];
    [self.window addSubview:imgView];

}
-(void)removeScreenShoots
{
    [imgView removeFromSuperview];
    
}

- (UIImage *) screenshot {
    
    CGSize size = CGSizeMake(320, 568);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rec = CGRectMake(0, 0,320, 568);
    [self.window drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark- pushViewControllerNibIdentifier -
-(void)pushViewController:(UIViewController*)viewController  NibIdentifier:(NSString*)identifier
{
    UIStoryboard * mainStoryboard=[self mainstoryboard];
   
    if ([identifier isEqual:@"FriendListVC"])
    {
        
        if (![navigation.visibleViewController isKindOfClass:[FriendListVC class]])
        {
            FriendListVC * friendview=[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendListVC"];
            
            // [viewController.navigationController pushViewController:friendview animated:YES];
            [navigation pushViewController:friendview animated:YES];
        }
        else
        {
            
        }
        
        
    }
    
   
}
#pragma mark-popToCurrentViewController-
-(void)popToCurrentViewController:(UIViewController*)viewController
{
    //[viewController.navigationController popViewControllerAnimated:YES];
    
    
    if ([navigation.visibleViewController isKindOfClass:[WhatHappendVC class]]||[viewController isKindOfClass:[FriendListVC class]]||[viewController isKindOfClass:[ChatViewController class]]||[viewController isKindOfClass:[UserProfileVC class]])
    {
        NSLog(@"no play");
    }
    else
    {
        if (playerview!=nil)
        {
            
            [playerview playnewVideoWithUrl:contentFileUrl];
        }
 
    }
    [navigation popViewControllerAnimated:YES];
    
    
}


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




//************************** Start Method of Downloading activities Category video************//



#pragma mark- dowloadStreamVideo -
-(void)dowloadStreamVideo:(NSDictionary*)requestdict andNext:(NSDictionary*)nextDic andfurtherNexr:(NSDictionary *)secondDic fileCount:(int)jsonCount andtotalCount:(int)totalCount
{
    [[ServerManager getSharedInstance]showProgressBarWithView:self.window MBProgressHUDMode:HorizontalBarMode];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL*  video_url=[NSURL URLWithString:[requestdict valueForKey:@"video_url"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:video_url];
    NSLog(@"Request=%@",request);
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  // [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                  
                                                  if (!error)
                                                  {
                                                      
                                                      filename=[response suggestedFilename];
                                                      NSLog(@"File downloaded to: %@", filePath);
                                                      
                                                      int cateId=[[requestdict valueForKey:@"id"] intValue];
                                                      NSURL*  youtube_link=[NSURL URLWithString:@"No Url"];
                                                      if([requestdict valueForKey:@"youtube_link"]!=[NSNull null])
                                                      {
                                                          youtube_link=[NSURL URLWithString:[requestdict valueForKey:@"youtube_link"] ];
                                                      }
                                                      NSString * thumbnails=[requestdict valueForKey:@"youtube_thumbnails"] ;
                                                      NSString * category=[requestdict valueForKey:@"category"] ;
                                                      
                                                      NSString *videoUrlPath=[NSString stringWithFormat:@"http://buddyappnew.herokuapp.com/files/activities/video/%@",filename];
                                                      
                                                      NSMutableDictionary * inserdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cateId],@"id",category,@"category",thumbnails,@"thumbnails",youtube_link,@"youtube_link",videoUrlPath,@"video_url", nil];
                                                      
                                                      isDownloadBG=NO;
                                                      
                                                      //thumb image
                                                      
                                                      
                                                   /*
                                                      AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrlPath] options:nil];
                                                      AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                                                      generator.appliesPreferredTrackTransform=TRUE;
                                                      
                                                      CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
                                                      
                                                      AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                                                          if (result != AVAssetImageGeneratorSucceeded) {
                                                              NSLog(@"couldn't generate thumbnail, error:%@", error);
                                                          }
                                                          
                                                                 UIImage*  thumbimage=[UIImage imageWithCGImage:im] ;
                                                                    [self storeThumbNamilImage:thumbimage and:inserdict];//
                                                                    [self inserCategoryDataInDb:inserdict];
                                                                    [self dowloadStreamVideo:nextDic andFurtherNext:secondDic fileCount:jsonCount andtotalCount:(int)totalCount];
                                                      };
                                                      
                                                      CGSize maxSize = CGSizeMake(640, 400);
                                                      generator.maximumSize = maxSize;
                                                      [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                                                      
                                                      
                                                      */
                                                      
                                                      
                                                      
                                                      
                                                      
//                                                      [self storeThumbNamilImage:thumbnileimage and:inserdict];//
//                                                      
                                                      [self inserCategoryDataInDb:inserdict];
                                                      
                                                       [self dowloadStreamVideo:nextDic andFurtherNext:secondDic fileCount:jsonCount andtotalCount:(int)totalCount];
                                                     
                                                      
                                                  }
                                                  else
                                                  {
                                                      
                                                      NSLog(@"error=%@",error.description);
                                                      [ServerManager showAlertView:@"Message" withmessage:error.localizedDescription];
                                                      [[ServerManager getSharedInstance]hideHud];
                                                      
                                                  }
                                              }];
    
    
    
    [downloadTask resume];
    
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {
         NSLog(@"Progress… %lld", totalBytesWritten);
         float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
         //float uploadActualPercentage = uploadPercentge * 100;
         [[ServerManager getSharedInstance] reciveProgressData:uploadPercentge lable:@"dowloading.."];
     }];
    
    
    [manager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        
        NSLog(@"Progress… Resume-- %lld", expectedTotalBytes);
    }];
 
}

-(void)dowloadStreamVideo:(NSDictionary*)requestdict andFurtherNext:(NSDictionary *)secondDic fileCount:(int)jsonCount andtotalCount:(int)totalCount
{
    if (jsonCount==totalCount) {
        [[ServerManager getSharedInstance]showProgressBarWithView:self.window MBProgressHUDMode:HorizontalBarMode];
    }
    // [[ServerManager getSharedInstance]showProgressBarWithView:self.window MBProgressHUDMode:HorizontalBarMode];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL*  video_url=[NSURL URLWithString:[requestdict valueForKey:@"video_url"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:video_url];
    NSLog(@"Request=%@",request);
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  // [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                  
                                                  if (!error)
                                                  {
                                                      
                                                      filename=[response suggestedFilename];
                                                      NSLog(@"File downloaded to: %@", filePath);
                                                      
                                                      int cateId=[[requestdict valueForKey:@"id"] intValue];
                                                      NSURL*  youtube_link=[NSURL URLWithString:@"No Url"];
                                                      if([requestdict valueForKey:@"youtube_link"]!=[NSNull null])
                                                      {
                                                          youtube_link=[NSURL URLWithString:[requestdict valueForKey:@"youtube_link"] ];
                                                      }
                                                      NSString * thumbnails=[requestdict valueForKey:@"youtube_thumbnails"] ;
                                                      NSString * category=[requestdict valueForKey:@"category"] ;
                                                      
                                                       NSString *videoUrlPath=[NSString stringWithFormat:@"http://buddyappnew.herokuapp.com/files/activities/video/%@",filename];
                                                      
                                                      NSMutableDictionary * inserdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cateId],@"id",category,@"category",thumbnails,@"thumbnails",youtube_link,@"youtube_link",videoUrlPath,@"video_url", nil];
                                                      
                                                      isDownloadBG=YES;
                                                      
                                                      
                                                  /*
                                                      AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrlPath] options:nil];
                                                      AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                                                      generator.appliesPreferredTrackTransform=TRUE;
                                                      
                                                      CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
                                                      
                                                      AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                                                          if (result != AVAssetImageGeneratorSucceeded) {
                                                              NSLog(@"couldn't generate thumbnail, error:%@", error);
                                                          }
                                                          
                                                          UIImage*  thumbimage=[UIImage imageWithCGImage:im] ;
                                                          [self storeThumbNamilImage:thumbimage and:inserdict];//
                                                          [self inserCategoryDataInDb:inserdict];
                                                           [self dowloadStreamVideo:secondDic fileCount:jsonCount andtotalCount:(int)totalCount];
                                                      };
                                                      
                                                      CGSize maxSize = CGSizeMake(640, 400);
                                                      generator.maximumSize = maxSize;
                                                      [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                                                      
                                                      
                                                      
                                                      */
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      //thumb image
//                                                      [self storeThumbNamilImage:thumbnileimage and:inserdict];//
                                                      [self inserCategoryDataInDb:inserdict];
                                                       [self dowloadStreamVideo:secondDic fileCount:jsonCount andtotalCount:(int)totalCount];
                                                      
                                                      
                                                      
                                                  }
                                                  else
                                                  {
                                                      
                                                      NSLog(@"error=%@",error.description);
                                                      [ServerManager showAlertView:@"Message" withmessage:error.localizedDescription];
                                                      [[ServerManager getSharedInstance]hideHud];
                                                      
                                                  }
                                              }];
    
    
    
    [downloadTask resume];
    
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {
         NSLog(@"Progress… %lld", totalBytesWritten);
         float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
         //float uploadActualPercentage = uploadPercentge * 100;
         [[ServerManager getSharedInstance] reciveProgressData:uploadPercentge lable:@"dowloading.."];
     }];
    
    
    [manager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        
        NSLog(@"Progress… Resume-- %lld", expectedTotalBytes);
    }];
    
}




-(void)dowloadStreamVideo:(NSDictionary*)requestdict fileCount:(int)jsonCount andtotalCount:(int)totalCount
{
    if (jsonCount==totalCount) {
        [[ServerManager getSharedInstance]showProgressBarWithView:self.window MBProgressHUDMode:HorizontalBarMode];
    }
    
   // [[ServerManager getSharedInstance]showProgressBarWithView:self.window MBProgressHUDMode:HorizontalBarMode];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL*  video_url=[NSURL URLWithString:[requestdict valueForKey:@"video_url"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:video_url];
    NSLog(@"Request=%@",request);
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                 // [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                  
                                                  if (!error)
                                                  {
                                                      
                                                    filename=[response suggestedFilename];
                                                      NSLog(@"File downloaded to: %@", filePath);
                                                      
                                                      int cateId=[[requestdict valueForKey:@"id"] intValue];
                                                      NSURL*  youtube_link=[NSURL URLWithString:@"No Url"];
                                                      if([requestdict valueForKey:@"youtube_link"]!=[NSNull null])
                                                      {
                                                       youtube_link=[NSURL URLWithString:[requestdict valueForKey:@"youtube_link"] ];
                                                      }
                                                      NSString * thumbnails=[requestdict valueForKey:@"youtube_thumbnails"] ;
                                                      NSString * category=[requestdict valueForKey:@"category"] ;
                                                      
                                                      NSString *videoUrlPath=[NSString stringWithFormat:@"http://buddyappnew.herokuapp.com/files/activities/video/%@",filename];
                                                      
                                                      NSMutableDictionary * inserdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cateId],@"id",category,@"category",thumbnails,@"thumbnails",youtube_link,@"youtube_link",videoUrlPath,@"video_url", nil];
                                                      
                                                      isDownloadBG=YES;
                                                      
                                                   /*
                                                      AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrlPath] options:nil];
                                                      AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                                                      generator.appliesPreferredTrackTransform=TRUE;
                                                      
                                                      CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
                                                      
                                                      AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                                                          if (result != AVAssetImageGeneratorSucceeded) {
                                                              NSLog(@"couldn't generate thumbnail, error:%@", error);
                                                          }
                                                          
                                                          UIImage*  thumbimage=[UIImage imageWithCGImage:im] ;
                                                          [self storeThumbNamilImage:thumbimage and:inserdict];//
                                                          [self inserCategoryDataInDb:inserdict];
                                                      };
                                                      
                                                      CGSize maxSize = CGSizeMake(640, 400);
                                                      generator.maximumSize = maxSize;
                                                      [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                                                      */
                                                     
                                                      
                                                      //thumb image
                                                     // [self storeThumbNamilImage:thumbnileimage and:inserdict];//
                                                      [self inserCategoryDataInDb:inserdict];
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                  }
                                                  else
                                                  {
                                                      
                                                      NSLog(@"error=%@",error.description);
                                                      [ServerManager showAlertView:@"Message" withmessage:error.localizedDescription];
                                                      [[ServerManager getSharedInstance]hideHud];
                                                      
                                                  }
                                              }];
    
    
    
    [downloadTask resume];
    
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {
         NSLog(@"Progress… %lld", totalBytesWritten);
         float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
         //float uploadActualPercentage = uploadPercentge * 100;
         [[ServerManager getSharedInstance] reciveProgressData:uploadPercentge lable:@"dowloading.."];
     }];

    
        [manager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        
         NSLog(@"Progress… Resume-- %lld", expectedTotalBytes);
    }];
    
}


#pragma store thumb image to document directory

-(void)storeThumbNamilImage:(UIImage*)selectedImage and:(NSDictionary*)dic
{
    CGRect rect = CGRectMake(0,0,640,560);
    UIGraphicsBeginImageContext( rect.size );
    [selectedImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *profile_image_data = UIImagePNGRepresentation(picture1);
    
    ///////////////////////////////////////Store image in document directory
    
    NSString *strImagePath=[NSString stringWithFormat:@"%@.png",[dic valueForKey:@"id"]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:strImagePath];
    [profile_image_data writeToFile:filePath atomically:YES];
    
    
   NSString* str_offline=[self documentsPathForFileName:strImagePath];
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:strImagePath] lastPathComponent]]];
    UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];

}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


#pragma mark- Save Category in DB-
-(void)inserCategoryDataInDb:(NSMutableDictionary*)dic
{
    NSLog(@"%@",dic);
    [DBManager getSharedInstance].Delegate=self;
    //  y(cat_id INTEGER PRIMARY KEY , category TEXT,thumbnails TEXT,youtube_link TEXT)
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Category (cat_id,category,thumbnails,youtube_link,video_url) VALUES (\"%d\", \"%@\", \"%@\", \"%@\", \"%@\")",[[dic valueForKey:@"id"] intValue], [dic valueForKey:@"category"], [dic valueForKey:@"thumbnails"],[dic valueForKey:@"youtube_link"],[dic valueForKey:@"video_url"],nil];
    
    [[DBManager getSharedInstance]insertQuery:insertSQL];
    
}

#pragma mark- DBManager Delegate-
-(void)database:(DBManager *)database success:(BOOL)_issuccess withSatement:(NSString *)statement
{
    
    if (_issuccess==YES)
    {
        if ([statement isEqual:DBInsertStmt])
        {
            [[ServerManager getSharedInstance]hideHud];
            categoryidArr=[self getAllCategoryId];
            NSString * videoPath=[[DBManager getSharedInstance]getFilePath:filename];
            
            if (![videoPath isEqual:@"No found"])
            {
                NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",videoPath]];
                if (isDownloadBG==NO)
                {
                     [[NSNotificationCenter defaultCenter]postNotificationName:DBInsertStmt object:fileUrl];
                }
               
                
            }
        }
       

    }
    
}

//************** Get Category Api---

-(NSMutableArray*)getAllCategoryId
{
    NSMutableArray * catIds=[NSMutableArray new];
    NSString *selectQuery=@"SELECT cat_id FROM Category";
    
    catIds=[[DBManager getSharedInstance]fetchAllIds:selectQuery];
    
    
    return catIds;
}

#pragma mark- Select Query-
-(NSMutableArray*)readAllCategory
{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Category order by cat_id ASC"];
    return [[DBManager getSharedInstance]FetchCategaryList:querySQL];
}

//********************  End *****************//

-(void)edgesForExtendedLayout :(UIViewController*)viewcontroller
{
float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

if (systemVersion >= 7.0)
{
    viewcontroller.edgesForExtendedLayout = UIRectEdgeNone;
}
}
@end
