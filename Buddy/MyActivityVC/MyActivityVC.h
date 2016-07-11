//
//  MyActivityVC.h
//  BuddySystem
//
//  Created by Jitendra on 06/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface MyActivityVC : UIViewController<ServerManagerDelegate,UIAlertViewDelegate>
{
    IBOutlet     UIScrollView *objScrollView;
    UIAlertView * suggestalert;
    UIAlertView * Deletealert;
    
    IBOutlet UIView *contentView;
    
     IBOutlet UICollectionViewFlowLayout *flowLayout;
    
    
    NSMutableArray * activityList;
    NSString * suggestActivityid;
    NSString * suggestActivityName;
    
    IBOutlet UIButton *chatBtn;

}

- (IBAction)OnBack:(id)sender;

- (IBAction)OnChat:(id)sender;

- (IBAction)TappedOnSuggest:(id)sender;
- (IBAction)TappedOnMenu:(id)sender;


@end
