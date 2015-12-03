//
//  EventCell.h
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
@interface EventCell : UITableViewCell
{
    
     UIImageView *imageview;
    
    IBOutlet UIScrollView *usrimageScroll;
    IBOutlet UITextView *description;
    
}
@property (strong, nonatomic) IBOutlet UIView *jkplayerView;
@property (strong, nonatomic) IBOutlet UIImageView *videoThumbView;
-(void)loadEventCellData:(NSDictionary*)dict;
@end
