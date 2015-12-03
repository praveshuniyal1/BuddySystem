//
//  FBManager.h
//  Hello
//
//  Created by webAstral on 11/10/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ServerManager.h"
#import "SCFacebook.h"
@class FBManager ;
typedef void(^FBManagerCompletion)(BOOL success, id result);
@protocol FBLoginManagerDelegate <NSObject>

@optional
-(void)fbLoginUserInfo:(NSDictionary*)basicInfo;
-(void)fbUserFreindList:(NSMutableArray*)userFriendList;
-(void)fbSessionActive:(BOOL)_isActive;
-(void)getfbUserallPhotos:(NSMutableArray*)albumList;
-(void)getFBGraphApiResponse:(NSDictionary*)jsondict serverpath:(NSString*)serverpath;
-(void)FbLogout;
-(void)failedgraphApiResponse:(NSError*)error;
@end
UIKIT_EXTERN NSString *const FBPhotoalbum;
UIKIT_EXTERN NSString *const FBgetAlbumId;
UIKIT_EXTERN NSString *const FBgetPhotosAlbum;

@interface FBManager : NSObject
{
     id<FBLoginManagerDelegate>Delegate;
}
@property(strong,nonatomic) id<FBLoginManagerDelegate>Delegate;

+(FBManager*)sharedInstance;
-(void)getForMyFriendsList;
- (void)userLoggedInwithUserInfo:(NSString*)fieldnames;




//SCFacebook--

- (void)logout;
-(void)getAlbums;
-(void)getAlbumId:(NSString*)albumid;
-(void)getPhotosofAlbum:(NSString*)myalbumid;
-(BOOL)fbSessionMangerActive;
-(void)getFreindInfofrindID:(NSString*)freind_id fieldsname:(NSString*)fields typeapi:(NSString*)methodname;
-(void)getFreindAlbum:(NSString*)freindId;
-(void)publishYourWallLink:(NSString*)linkPath caption:(NSString *)caption Completion:(FBManagerCompletion)Completion;
-(void)publishYourWallMessage:(NSString *)postmsg  Completion:(FBManagerCompletion)Completion;
-(void)publicPostWithPhoto:(UIImage *)postimage caption:(NSString *)caption Completion:(FBManagerCompletion)Completion;
-(void)publicPostWithVideo:(NSData *)videoData withTitle:(NSString*)title description:(NSString *)description Completion:(FBManagerCompletion)Completion;
@end
