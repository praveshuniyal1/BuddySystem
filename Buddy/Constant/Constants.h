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






#define KBaseUrl               @"http://dev414.trigma.us/Buddy/webs/"

//#define KBaseUrl             @"http://112.196.28.157/bestbuddies/"

#define Ksignup                @"registeruser?"
//#define Ksignup                 @"registeruser.php?"


#define KCloseAccount          @"delete_user?"
#define KLogout                @"online?"




// Chat


#define KRecivemsg               @"get_message.php?"
#define KsendMessage             @"message.php?"

// WHAT happning

#define kWhatHappning             @"activity_timeline?"
#define KaddActivity              @"match?"

// do somthings


#define KeventCategory            @"get_category"



#define KSaveUsrActivity         @"add_user_activity"

//#define KUserFriendlist          @"friendlist.php?"
#define KUserFriendlist          @"online_friends?"

#define KSearch                  @"activitysearch.php?"

#define KfriendProfile           @"usr_timeline.php?"
//My Activity

#define kMyActivity              @"my_activity"


#define kdeleteActivity          @"delete_user_activity"
#define ksuggestActivity         @"suggested_activity"

#define kaccessToken             @"access_token"
#define KUpdateUserLocation      @"updateUserCity?"
#define KupdateFrindList         @"updatefriendlist?"


//http://112.196.28.157/bestbuddies/access_token.php?key=715b0d6e4bf4256d03de2cf055068412&usr_id=762360043882488
#endif
