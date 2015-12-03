//
//  GetegoryCell.h
//  BuddySystem
//
//  Created by Jitendra on 19/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface CategoryCell : UICollectionViewCell
{
     IBOutlet UIButton *categoryTitlebtn;
    
    IBOutlet UIVisualEffectView *visualEffectView;
    // fbpostwall
    
    IBOutlet AsyncImageView * fbfriendimage;
    
    // suggest activity
    
    IBOutlet UILabel * lbl_title;
    
    IBOutlet UIButton *btnDelete;
    
}

@property (strong, nonatomic) IBOutlet UIButton *letsdoThisbtn;

@property (strong, nonatomic) IBOutlet UIButton * btnDelete;
-(void)loadCategoryListData:(NSDictionary*)dict;
-(void)loadFBWallPostCellData:(NSDictionary*)dict;

-(void)loadSuggestActivityData:(NSDictionary*)dict;
@end
