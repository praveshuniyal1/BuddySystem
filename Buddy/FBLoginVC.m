//
//  ViewController.m
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "FBLoginVC.h"

@interface FBLoginVC ()

@end

@implementation FBLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self fbloginSession];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self bgplayer];
}
-(void)fbloginSession
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        BOOL isActivelogin=[SCFacebook isSessionValid];
        if (isActivelogin==YES)
        {
            [[ServerManager getSharedInstance]showactivityHub:@"loading.." addWithView:self.navigationController.view];
            [self fetchfbUserInfo];
        }
        else
        {
            [[ServerManager getSharedInstance]hideHud];
        }
    }
}
-(void)bgplayer
{
    
    // Background work
    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[[ServerManager getSharedInstance]getVideoPath_name:@"login"]]];
    
    
        [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
   
   
    
}

#pragma mark-fetchfbUserInfo-
-(void)fetchfbUserInfo
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        [FBManager sharedInstance].Delegate=self;
        [[FBManager sharedInstance]userLoggedInwithUserInfo:@"birthday,bio,gender,id,name,email,likes,link"];
    }
    
}

#pragma mark- Delegate method's FBManager-


-(void)fbLoginUserInfo:(NSDictionary *)basicInfo
{
    
    [self user_info:basicInfo];
}

#pragma mark-user_info-
-(void)user_info:(NSDictionary*)user
{
    
    NSLog(@"ssadasd %@",user);
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       
       NSString * gender=[NSString stringWithFormat:@"%@",[user objectForKey:@"gender"]];
       NSString * user_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
       NSString * username=[NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
       [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"My_name"];
       NSString * email_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"email"]];
       
       NSString *taglink=[NSString stringWithFormat:@"http://facebook.com/%@",user_id];
       [[NSUserDefaults standardUserDefaults]setObject:taglink forKey:@"tagLink"];
      
       //[[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"link"] forKey:@"tagLink"];
       
       [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"name"] forKey:@"UserName"];
       [[NSUserDefaults standardUserDefaults]synchronize];
       
      // NSString * bio=[NSString stringWithFormat:@"%@",[user objectForKey:@"bio"]];
       NSString * profileLink=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",user_id];
    
       
       [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"userID"];
      
       
       
       NSURL * profilepicurl=[[ServerManager getSharedInstance]Fb_profileImageFile:user_id];
        // UIImage * profileimage =[[ServerManager getSharedInstance]fetchTheImage:profilepicurl];
       [[ServerManager getSharedInstance]getImageFromServerPath:profilepicurl completed:^(UIImage *image, BOOL finished)
       {
           
           profileimage=[image copy];
           NSData * imagedata=UIImagePNGRepresentation(image);
           NSDictionary * userinfo=[NSDictionary dictionaryWithObjectsAndKeys:user_id,@"id",username,@"name",imagedata,@"imagedata",profileLink,@"profileLink", nil];
           
           [NSUserDefaults setNSUserDefaultValue:userinfo key:kLoginUserInfo];
           
           
           
           // Convert date object into desired format
          
           
           if ([gender isEqual:@"male"])
           {
               genderType=1;
           }
           else
           {
               genderType=0;
           }
           
           [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUpdate"];
           [[NSUserDefaults standardUserDefaults]synchronize];
           
           CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
           
          
           NSString * deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
           if (deviceToken.length==0)
           {
               deviceToken=@"123456";
           }
           
           userinfoDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:user_id,@"usr_id",username,@"usr_name",[NSNumber numberWithInteger:genderType],@"gender",email_id,@"usr_email",[NSNumber numberWithDouble:loctCoord.latitude],@"latitude",[NSNumber numberWithDouble:loctCoord.longitude],@"longitude",[NSNumber numberWithInt:1],@"online",profileLink,@"profile_link",deviceToken,@"token_id",nil];
           
           BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
           if (is_net==YES)
           {
               if ([[FBSession activeSession] isOpen])
               {
                   [FBManager sharedInstance].Delegate=self;
                   [[FBManager sharedInstance]getForMyFriendsList];
               }
           }
       }];
    });
}



#pragma mark- FBManager Delegate Method For Fetch UserFriendList-
-(void)fbUserFreindList:(NSMutableArray *)userFriendList
{
    //[[NSUserDefaults standardUserDefaults]setObject:userFriendList forKey:kFriendList];
     NSLog(@"friends==%@",userFriendList);
    NSString *jsonString;
    if (userFriendList.count>0)
    {
        [NSUserDefaults setNSUserDefaultobject:userFriendList key:kFriendList];

        
        if (userFriendList.count>=10) {
            
           // userFriendList = [userFriendList subarrayWithRange:NSMakeRange(0, 10)];
             jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:userFriendList];
            [userinfoDict setObject:jsonString forKey:@"friend_list"];
        }
        else{
            jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:userFriendList];
            [userinfoDict setObject:jsonString forKey:@"friend_list"];
        }
        
    }
    else if (userFriendList.count==0)
    {
        
        [NSUserDefaults setNSUserDefaultobject:@"null" key:kFriendList];
        userFriendList=[[NSMutableArray alloc]initWithObjects:@"null", nil];
        jsonString = [[ServerManager getSharedInstance]jsonRepresentForm:userFriendList];
        NSLog(@"%@",jsonString);
         [userinfoDict setObject:@"null" forKey:@"friend_list"];
    }
   
    NSLog(@"jsonData as string:\n%@", jsonString);
    
   [userinfoDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"] forKey:@"access_token"];
    

    [self signUpwithFB:userinfoDict profileimage:profileimage];
}

#pragma mark-signUpwithFB-
-(void)signUpwithFB:(NSDictionary*)userinfo profileimage:(UIImage*)image
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        NSMutableArray * mediaray=[NSMutableArray arrayWithObject:image];
        [ServerManager getSharedInstance].Delegate=self;
        [[ServerManager getSharedInstance]postDatawithMediaFile:userinfo MediaFile:mediaray setMediaKey:@"profile_pic" withPostUrl:Ksignup mediaType:imageFile is_multiple:NO];
    }
}


#pragma mark- Delegate Method of Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [[ServerManager getSharedInstance]hideHud];
    
    if ([serviceurl isEqual:Ksignup])
    {
        NSInteger status=[[responseDict valueForKeyPath:@"status"] integerValue];
        
        switch (status) {
            case 0:
                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"msg"]];
                break;
            case 1:
                //[playerview stopCurrentVideo];
                
                [KappDelgate showHomeView];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TappedOnLogin:(id)sender
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        BOOL isActivelogin=[SCFacebook isSessionValid];
        if (isActivelogin==YES)
        {
            [[ServerManager getSharedInstance]showactivityHub:@"loading.." addWithView:self.navigationController.view];
            [self fetchfbUserInfo];
        }
        else
        {
            [[ServerManager getSharedInstance]showactivityHub:@"loading.." addWithView:self.navigationController.view];
            [self login];
        }
        
    }
}
- (void)login
{
    
    
    

   

    [SCFacebook loginCallBack:^(BOOL success, id result)
     {
         BOOL isActivelogin=[SCFacebook isSessionValid];
         
         if (success)
         {
             if (isActivelogin==YES)
             {
                 [self fetchfbUserInfo];
             }
         }
         else
         {
             
             if([result isKindOfClass:[NSError class]])
             {
                 NSError * erorr=result;
                 //Alert(@"Alert", [result description]);
                 Alert(@"Message", erorr.localizedDescription);
             }
             else if([result isKindOfClass:[NSString class]])
             {
                 NSString * erorr=(NSString*)result;
                 //Alert(@"Alert", [result description]);
                 Alert(@"Message",erorr);
             }
             [[ServerManager getSharedInstance]hideHud];
         }
     }];
    
}

@end
