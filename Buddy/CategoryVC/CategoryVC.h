//
//  CategoryVC.h
//  BuddySystem
//
//  Created by Jitendra on 19/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
#import "FBWallPostVC.h"
@class CategoryVC;

@protocol CategoryVCDelegate <NSObject>

-(void)categoryview:(CategoryVC*)categoryview fromPopToView:(BOOL)animation;

@end
@interface CategoryVC : UIViewController<ServerManagerDelegate>
{
    BOOL pageControlBeingUsed;
    IBOutlet UIImageView *ThumbView;
    IBOutlet UIButton *Headerbtn;
    IBOutlet UIPageControl *pagecontrol;
    IBOutlet UICollectionView *categoryCollection;
    IBOutlet UICollectionViewFlowLayout *flowLaout;
    JKPlayer  * playerview;
    NSMutableArray * categoryList;
    IBOutlet UIView *contentView;
   
    IBOutlet UIButton *chatBtn;
    NSMutableArray * jsonarray;
    int CountoFpages;
}
@property(strong,nonatomic)id<CategoryVCDelegate>delegate;
@property(strong,nonatomic)NSString * currentTime;
@property(strong,nonatomic)NSURL *downloadedURl;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnChat:(id)sender;
- (IBAction)tappedOnMenu:(id)sender;

@end
