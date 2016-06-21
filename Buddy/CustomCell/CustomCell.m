 //
//  CustomCell.m
//  BuddySystem
//
//  Created by Jitendra on 16/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "CustomCell.h"
#import "JKClassManager.h"
@implementation CustomCell
@synthesize btnUserimage;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadFriendCellData:(NSDictionary *)dict ShowSearchBarController:(BOOL)animation
{
    
    
    btnUserimage.layer.cornerRadius = btnUserimage.frame.size.width / 2;
    btnUserimage.clipsToBounds = YES;
    btnUserimage. layer.borderColor = [UIColor whiteColor].CGColor;
    NSURL * imageurl=[NSURL URLWithString:[dict valueForKey:@"profile_pic"]];
    [btnUserimage sd_setImageWithURL:imageurl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];
    int usermode=[[dict valueForKey:@"online_status"] intValue];
    switch (usermode)
    {
            
        case 1:
        {
            [visibleSate setImage:[UIImage imageNamed:@"green"]];
        }
            break;
            
        default:
            [visibleSate setImage:[UIImage imageNamed:@"red"]];
            break;
    }
    
    NSString * name=[NSString stringWithFormat:@"%@",[dict valueForKey:@"usr_name"]];
    
    lbl_title.text=name;
//    lbl_title.backgroundColor=[UIColor greenColor];
    NSString * description;
    if (animation==YES)
    {
        description=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"common_activity"]componentsJoinedByString:@","]];
        

    }
    else
    {
       // description=[NSString stringWithFormat:@"%@",[[[dict valueForKey:@"common_activity"] valueForKey:@"activity_name"] componentsJoinedByString:@","]];
         description=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"common_activity"] valueForKey:@"Activity"]];
    }
    
    
    lbl_description.text=description;
    
}

-(void)loadLocationSearchData:(NSDictionary *)dict
{
  //  NSString	*name = [geoname objectForKey:kILGeoNamesNameKey];

    lbl_address.text=[NSString stringWithFormat:@"%@",[dict objectForKey:kILGeoNamesNameKey]];
}
@end
