//
//  CustomCell.h
//  BuddySystem
//
//  Created by Jitendra on 16/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UIButton *btnUserimage;
    IBOutlet UILabel *lbl_title;
    IBOutlet UILabel *lbl_description;
    
    IBOutlet UIImageView *visibleSate;
    UIImageView *dotImage;
    // location
    
    IBOutlet UILabel *lbl_address;
    
    
}
@property(strong,nonatomic)IBOutlet UIButton *UnblockBtn;
@property(strong,nonatomic)IBOutlet UIButton *btnUserimage;
-(void)loadFriendCellData:(NSDictionary*)dict ShowSearchBarController:(BOOL)animation;
-(void)loadLocationSearchData:(NSDictionary*)dict;
@end
