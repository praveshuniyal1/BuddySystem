//
//  AppDelegate.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
#import "JKMenuView.h"
#import <FacebookSDK/FacebookSDK.h>

#import "DBManager.h"
@class JKPlayer;
@interface AppDelegate : UIResponder <UIApplicationDelegate,JKMenuPopDelegate,DBManagerDelegate>
{
   
    JKPlayer * playerview;
    UIImage * thumbnileimage;
   // JKMenuView * menupopview;
    
     NSString * filename;
    int downloadIndx;
  
}
@property (strong, nonatomic) FBSession *session;

@property(strong,nonatomic)NSMutableArray * categoryidArr;
@property(assign,nonatomic)int downloadIndx;
@property(strong,nonatomic) NSURL * contentFileUrl;
@property(strong,nonatomic)UIView * fromView;
@property(strong,nonatomic)  JKMenuView * menupopview;
 @property(strong,nonatomic) JKPlayer * playerview;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSDictionary* reciveDict;
@property(strong,nonatomic)NSDictionary*remoteNotifdict;
@property(strong,nonatomic)UINavigationController * navigation;
@property(strong,nonatomic)UINavigationController * loginnavigation;
-(void)getNotificationResponse:(NSDictionary*)userInfo activeState:(BOOL)isactive;
-(void)getnotificationdatalaunchOptions:(NSDictionary*)userInfo;
-(void)hideNavigationbar:(BOOL)isHide;
-(void)showHomeView;
-(void)loginView;
- (UIControl *) findBarButtonItem:(UIBarButtonItem *)barButtonItem;
-(void)stopBackGroundVideo;
-(void)playBackGroundVideo;
-(void)getScreenShoots;
-(void)removeScreenShoots;
// Other method-


-(void)dismissViewController:(UIViewController*)presentcontroller;
-(void)addPlayerInCurrentViewController:(UIView*)currentview bringView:(UIView*)conetnview MovieUrl:(NSURL*)fileurl;
//-(void)presentSelectedViewController:(UIViewController*)viewController NibIdentifier:(NSString*)identifier;
-(void)pushViewController:(UIViewController*)viewController  NibIdentifier:(NSString*)identifier;
-(void)popToCurrentViewController:(UIViewController*)viewController;
-(void)showJKPopupMenuInView:(UIView*)superView animation:(BOOL)animation;
-(void)dowloadStreamVideo:(NSDictionary*)requestdict andNext:(NSDictionary*)nextDic fileCount:(int)jsonCount;
-(void)dowloadStreamVideo:(NSDictionary*)requestdict andNext:(NSDictionary*)nextDic andfurtherNexr:(NSDictionary*)secondDic fileCount:(int)jsonCount andtotalCount:(int)totalCount;

-(void)dowloadStreamVideo:(NSDictionary*)requestdict  andFurtherNext:(NSDictionary*)secondDic fileCount:(int)jsonCount andtotalCount:(int)totalCount;
-(void)dowloadStreamVideo:(NSDictionary*)requestdict fileCount:(int)jsonCount andtotalCount:(int)totalCount;
-(NSMutableArray*)readAllCategory;

-(NSMutableArray*)getAllCategoryId;
-(void)edgesForExtendedLayout :(UIViewController*)viewcontroller;

@end
