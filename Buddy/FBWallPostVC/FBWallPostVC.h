//
//  FBWallPostVC.h
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
#import "LocationSearchVC.h"
#import "ShareVC.h"
#import "ILGeoNamesSearchController.h"
#import "DBManagerDelegate.h"

@interface FBWallPostVC : UIViewController<FBFriendPickerDelegate,ServerManagerDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate,ILGeoNamesSearchControllerNewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UIButton *timeCatbtn;
    IBOutlet UITextField *catTitletext;
    IBOutlet UICollectionView *friendCollectionView;
    IBOutlet UICollectionViewFlowLayout *flowLayout;
    IBOutlet UIView *contentView;
    IBOutlet UITextView *descriptiontxt;
    NSDictionary * userinfoDict;
    NSMutableArray * friendlist;
    JKPlayer  * playerview;
    FBFriendPickerViewController *friendPickerViewController;
    NSMutableData *webData;
    UIPopoverController* popOver;
    
    NSString * myWall;
    BOOL FirstTime;
    NSMutableArray *stringResponse;
    
    
    IBOutlet UIView *activityView;
}
@property (nonatomic,strong)FBRequestConnection *requestConnection;
@property(strong,nonatomic)NSString * address;
@property(strong,nonatomic)NSMutableDictionary * SelectCatDict;
- (IBAction)OnBack:(id)sender;
- (IBAction)TappedOnGotIt:(id)sender;
- (IBAction)TappedOnChangeLocation:(id)sender;
- (IBAction)TappedOnPostFbWall:(id)sender;
- (IBAction)TappedOnInfo:(id)sender;


@end
