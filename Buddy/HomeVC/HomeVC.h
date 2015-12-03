//
//  HomeVC.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"

@interface HomeVC : UIViewController<ServerManagerDelegate,JkDateTimePickerDelegate,PopoverViewDelegate>
{
    JKPlayer  * playerview;
   
    
    IBOutletCollection(UIButton) NSArray * timesbtn;
    IBOutlet UIButton *chatbtn;
    IBOutlet UIView *contentView;
   
    JkDateTimePicker * jkClaenderView;
    PopoverView* pv;
    UIImage * thumbnileimage;
   
    IBOutletCollection(UIVisualEffectView) NSArray *visibleEffectView;
    
    

}


- (IBAction)TappedOnTime:(id)sender;

- (IBAction)tappedOnMenu:(id)sender;

- (IBAction)tappedOnChat:(id)sender;

@end
