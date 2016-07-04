//
//  Constant.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#ifndef BuddySystem_Constants_h
#define BuddySystem_Constants_h

#define KappDelgate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define iPadPro ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [UIScreen mainScreen].bounds.size.height == 1366)



//expiry_param= Now=0 , Today=1 , This weakend=3 ,Anytime=4 ,Other=5
typedef enum : NSUInteger
{
    Now=0,
    Today,
    Thisweakend,
    Anytime,
    Other,
   
    
} expiry_param;

#define HorizontalBarMode  0
#define RingBarMode        1
#define piechartBarMode    2






//#define KBaseUrl               @"http://dev414.trigma.us/Buddy/webs/"

#define KBaseUrl             @"http://buddyappnew.herokuapp.com/webs/"

#define Ksignup                @"registeruser?"
//#define Ksignup                 @"registeruser.php?"


#define KCloseAccount          @"delete_user?"
#define KLogout                @"online?"




// Chat


//<<<<<<< HEAD
#define KRecivemsg               @"message_recieve?"
//#define KsendMessage             @"message.php?"


#define KsendMessage             @"chatting?"

// WHAT happning

#define kWhatHappning             @"activity_timeline?"
#define KAddWhatHappendActivity              @"match?"
#define KaddActivity              @"adminer?"
#define KUnblockUser              @"unblockuser?"
#define KReadUnread               @"read_unread?"

// do somthings


#define KeventCategory            @"get_category"



#define KSaveUsrActivity         @"add_user_activity"

//#define KUserFriendlist          @"friendlist.php?"
#define KUserFriendlist          @"online_friends?"

#define KSearch                  @"activitysearch?"

#define KfriendProfile           @"friend_profile?"
//My Activity

#define kMyActivity              @"my_activity"


#define kdeleteActivity          @"delete_user_activity"
#define ksuggestActivity         @"suggested_activity"

#define kaccessToken             @"access_token"
#define KUpdateUserLocation      @"updateUserCity?"
#define KupdateFrindList         @"updatefriendlist?"

#define KRedIcon                 @"red_icon?"


//http://112.196.28.157/bestbuddies/access_token.php?key=715b0d6e4bf4256d03de2cf055068412&usr_id=762360043882488
#endif
