//
//  UIFacebookBrowser.h
//  BuddySystem
//
//  Created by Jitendra on 10/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface UIFacebookBrowser : UIViewController
{
    
    IBOutlet UIActivityIndicatorView *loadHud;
    IBOutlet UIWebView *facebookBrowser;
}

@property(strong,nonatomic)NSURL * fblink;
- (IBAction)OnCancel:(id)sender;


@end
