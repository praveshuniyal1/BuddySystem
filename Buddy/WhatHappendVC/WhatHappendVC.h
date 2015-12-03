//
//  WhatHappendVC.h
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"

@interface WhatHappendVC : UIViewController<ServerManagerDelegate>
{
    IBOutlet UITableView *eventTable;
    IBOutlet UIButton *chatbtn;
    NSMutableArray * eventVideoList;
    NSMutableArray * eventList;
    MPMoviePlayerController * moviePlayer;
    NSString * acitivityId;
    NSString* usrId;
    NSString* name;
    NSString * toUserid;
    NSString * category_id;
    
    IBOutlet UIView *viewIamges;
    
    NSString *to_IDAct;
    
}


- (IBAction)OnBack:(id)sender;
- (IBAction)OnChat:(id)sender;

@end
