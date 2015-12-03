//
//  ShareVC.h
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface ShareVC : UIViewController
{
    IBOutlet UIButton *timeCatbtn;
    
    IBOutlet UITextView *descriptiontext;
    IBOutlet UIButton *whatHappenbtn;
    IBOutlet UITextView *cattext;
    IBOutlet UIButton *sharebtn;
    
    JKPlayer  * playerview;
    IBOutlet UIView *contentView;
    
    
}
@property(strong,nonatomic)UINavigationController * navigation;

@property (nonatomic, strong) UIPopoverController *activityPopoverController;
@property(strong,nonatomic)NSMutableDictionary * shareDict;
- (IBAction)OnBack:(id)sender;
- (IBAction)TappedOnShare:(id)sender;
- (IBAction)TappedOnMenu:(id)sender;
- (IBAction)TappedOnHappend:(id)sender;

@end
