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
@synthesize btnUserimage,UnblockBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadFriendCellData:(NSDictionary *)dict ShowSearchBarController:(BOOL)animation
{
    
    CGFloat width=[self widthOfString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"usr_name"]] withFont:[UIFont systemFontOfSize:20]];
    lbl_title.frame=CGRectMake(83, 9, width+10, 26);
    
 if (!dotImage)
 {
    dotImage=[[UIImageView alloc]init];
 }
    else
    {
        [dotImage removeFromSuperview];
        dotImage = nil;
    }
    if([[dict valueForKey:@"message_status"] isEqualToString:@"read"])
    {
      dotImage.image=nil;
    }
    else{
       
        dotImage.frame=CGRectMake(83+width+15, 15, 17, 17);
        [self.contentView addSubview:dotImage];
          dotImage.image=[UIImage imageNamed:@"red"];
    }
    
    if (animation==YES)
    {
        UnblockBtn.hidden=YES;
    }
    else
    {
        if ([[dict valueForKey:@"block_user"] isEqualToString:@"unblocked"])
        {
            UnblockBtn.hidden=YES;
        }
        else{
            UnblockBtn.hidden=NO;
        }
    }
    
   
    
    
    
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
    visibleSate.hidden=YES;
    
    NSString * name=[NSString stringWithFormat:@"%@",[dict valueForKey:@"usr_name"]];
    
    lbl_title.text=name;
//    lbl_title.backgroundColor=[UIColor greenColor];
    NSString * description;
    if (animation==YES)
    {
        description=[NSString stringWithFormat:@"%@",[dict valueForKey:@"Activity"]];
       // description=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"common_activity"] valueForKey:@"Activity"]];

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

//get width of name label
- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}


@end
