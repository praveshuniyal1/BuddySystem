//
//  FBManager.m
//  Hello
//
//  Created by webAstral on 11/10/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import "FBManager.h"

NSString *const FBPhotoalbum=@"getAlbums";
NSString *const FBgetAlbumId=@"getAlbumId";
NSString *const FBgetPhotosAlbum=@"getPhotosofAlbum";

@implementation FBManager
@synthesize Delegate;
static FBManager *sharedInstance = nil;

+(FBManager*)sharedInstance
{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!sharedInstance)
        {
            sharedInstance = [[self alloc] init];
        }
        //allochiamo la sharedInstance
        
    });
    return sharedInstance;
}


-(BOOL)fbSessionMangerActive{
    
    return [SCFacebook isSessionValid];
    
}


// Show the user the logged-in UI
- (void)userLoggedInwithUserInfo:(NSString*)fieldnames
{
   // NSString * fields=@"id, name, email, birthday, about, picture,gender";
    if ([SCFacebook isSessionValid]==YES)
    {
        [SCFacebook getUserFields:fieldnames callBack:^(BOOL success, id result) {
            if (success)
            {
                NSLog(@"result %@", result);
                [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"id"] forKey:@"my_id"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [Delegate fbLoginUserInfo:result];
                
                
            }else{
                
                [[ServerManager getSharedInstance]hideHud];
                NSError *erorr=result;
               // Alert(@"Erorr!", [result description]);
                Alert(@"Erorr!", erorr.localizedDescription);

            }
        }];
    }

    
}
#pragma pram- logout-
- (void)logout
{
    [SCFacebook logoutCallBack:^(BOOL success, id result)
    {
        if (success)
        {
            [Delegate FbLogout];
           
        }
    }];
}

#pragma mark-getAlbums-
-(void)getAlbums
{
    [SCFacebook getAlbumsCallBack:^(BOOL success, id result)
    {
        if (success)
        {
             //[Delegate getfbUserallPhotos:result];
            [Delegate getFBGraphApiResponse:result serverpath:FBPhotoalbum];
        }
        else
        {
             [[ServerManager getSharedInstance]hideHud];
            Alert(@"Alert", [result description]);
        }
        
    }];
}
#pragma mark-getAlbumId-
-(void)getAlbumId:(NSString*)albumid
{
    [SCFacebook getAlbumById:albumid callBack:^(BOOL success, id result) {
      
        if (success)
        {
            //[Delegate getfbUserallPhotos:result];
            [Delegate getFBGraphApiResponse:result serverpath:FBgetAlbumId];
        }
        else
        {
             [[ServerManager getSharedInstance]hideHud];
            Alert(@"Alert", [result description]);
        }
    }];
}
#pragma mark-getPhotosofAlbum-
-(void)getPhotosofAlbum:(NSString*)myalbumid
{
    [SCFacebook getPhotosAlbumById:myalbumid callBack:^(BOOL success, id result) {
      
        if (success)
        {
            // [Delegate getfbUserallPhotos:result];
             [Delegate getFBGraphApiResponse:result serverpath:FBgetPhotosAlbum];
        }
        else
        {
             [[ServerManager getSharedInstance]hideHud];
            Alert(@"Alert", [result description]);
        }
    }];
}

-(void)getFreindAlbum:(NSString*)freindId
{
    [SCFacebook getfreindAlbums:freindId CallBack:^(BOOL success, id result) {
        if (success)
        {
            // [Delegate getfbUserallPhotos:result];
            [Delegate getFBGraphApiResponse:result serverpath:FBPhotoalbum];
        }
        else
        {
            [[ServerManager getSharedInstance]hideHud];
            Alert(@"Alert", [result description]);
        }
    }];
}
#pragma mark-getForMyFriendsList-
-(void)getForMyFriendsList
{
    
    if ([[FBSession activeSession] isOpen])
    {
        [SCFacebook getUserFriendsCallBack:^(BOOL success, id result) {
           
            if (success)
            {
                [Delegate fbUserFreindList:result];
            }else
            {
                [[ServerManager getSharedInstance]hideHud];
                Alert(@"Alert", [result description]);
            }
        }];    }
    
    
}



-(void)getFreindInfofrindID:(NSString*)freind_id fieldsname:(NSString*)fields typeapi:(NSString*)methodname
{
    
    // NSString * fields=@"id, name, email, birthday, about, picture,gender";
    if ([SCFacebook isSessionValid]==YES)
    {
        [SCFacebook getFreindInfoFields:fields friendId:freind_id callBack:^(BOOL success, id result)
        {
            if (success)
            {
                NSLog(@"%@", result);
                [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"id"] forKey:@"my_id"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [Delegate getFBGraphApiResponse:result serverpath:methodname];
                
                
            }else{
                
                [[ServerManager getSharedInstance]hideHud];
                NSError *erorr=result;
                // Alert(@"Erorr!", [result description]);
                Alert(@"Erorr!", erorr.localizedDescription);
                
            }
        }];
    }
}

-(void)publishYourWallLink:(NSString*)linkPath caption:(NSString *)caption Completion:(FBManagerCompletion)Completion

{
    [SCFacebook feedPostWithLinkPath:linkPath caption:caption callBack:^(BOOL success, id result)
     {
       
         Completion(success,result);
    }];
}

-(void)publishYourWallMessage:(NSString *)postmsg  Completion:(FBManagerCompletion)Completion
{
    [SCFacebook feedPostWithMessage:postmsg callBack:^(BOOL success, id result)
    {
        Completion(success,result);
    }];
}

-(void)publicPostWithPhoto:(UIImage *)postimage caption:(NSString *)caption Completion:(FBManagerCompletion)Completion

{
    [SCFacebook feedPostWithPhoto:postimage caption:@"" callBack:^(BOOL success, id result) {
        
        Completion(success,result);
    }];
}
-(void)publicPostWithVideo:(NSData *)videoData withTitle:(NSString*)title description:(NSString *)description Completion:(FBManagerCompletion)Completion
{
    [SCFacebook feedPostWithVideo:videoData title:title description:description callBack:^(BOOL success, id result) {
        
        Completion(success,result);
    }];
}
@end
