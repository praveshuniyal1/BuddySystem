//
//  UserProfileVC.h
//  BuddySystem
//
//  Created by Jitendra on 17/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface UserProfileVC : UIViewController<ServerManagerDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UIView *menuContentView;
    IBOutlet UIView *TopBarView;
    
    IBOutletCollection(UIImageView) NSArray *profilepick;
    
    IBOutlet UITextView *MessageText;
    IBOutlet UIToolbar *ToolBar;
    IBOutlet UILabel *username;
    IBOutlet UILabel *lbl_selectedoption;
    IBOutlet UITextView *lbl_event;
    IBOutlet UILabel *lbl_relation;
    NSString * friendId;
    PopoverView *menuPopview;

    IBOutlet UITableView *MenuTable;
}
@property(strong,nonatomic)NSMutableDictionary * userinfodict;
- (IBAction)TappedOnMapPoint:(id)sender;
- (IBAction)OnBack:(id)sender;

- (IBAction)OpenMenuVC:(id)sender;
- (IBAction)TappedOnMessage:(id)sender;

@end
