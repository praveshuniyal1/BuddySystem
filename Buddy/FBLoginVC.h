//
//  ViewController.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface FBLoginVC : UIViewController<FBLoginManagerDelegate,ServerManagerDelegate>
{
    NSInteger genderType;
    NSMutableDictionary * userinfoDict;
    
    IBOutlet UIImageView *thumbview;
    JKPlayer  * playerview;
    UIImage * profileimage;
    IBOutlet UIView *contentView;
    UIImage * thumbnileimage;
    
}
- (IBAction)TappedOnLogin:(id)sender;
@end
