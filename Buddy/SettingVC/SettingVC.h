//
//  SettingVC.h
//  BuddySystem
//
//  Created by Jitendra on 04/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface SettingVC : UITableViewController<ServerManagerDelegate,MFMailComposeViewControllerDelegate>

- (IBAction)done:(id)sender;
@end
