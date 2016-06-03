//
//  EventCell.m
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "EventCell.h"
#import "AsyncImageView.h"

@implementation EventCell
@synthesize jkplayerView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadEventCellData:(NSDictionary *)dict andHeight:(float)height
{
    

    NSLog(@"%@",dict);
    NSString * activity=[dict valueForKey:@"category"];//category
    
    if (IS_IPHONE_6) {
        self.videoThumbView.frame=CGRectMake(self.superview.frame.origin.x, self.superview.frame.origin.y+41, self.superview.frame.size.width, height-38);
    }
    else if (IS_IPHONE_6P)
    {
       self.videoThumbView.frame=CGRectMake(self.superview.frame.origin.x, self.superview.frame.origin.y+41, self.superview.frame.size.width, height-70);
    }
   
    
    NSURL *youtube_tumbnails=[NSURL URLWithString:[dict valueForKey:@"youtube_thumbnails"]];//youtube_thumbnails
    
    [self.videoThumbView sd_setImageWithURL:youtube_tumbnails];
    
    for(UIView *view in usrimageScroll.subviews)
    {
        [view removeFromSuperview];
    }
    
    if([[dict valueForKey:@"profile_image"] isKindOfClass:[NSArray class]]||[[dict valueForKey:@"profile_image"] isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray * profile_pic=[NSMutableArray new];
        profile_pic=[dict valueForKey:@"profile_image"];
        
        if (profile_pic.count>2)
        {
             profile_pic=[NSMutableArray new];
            for (int i=0; i<2; i++)
            {
                [profile_pic addObject:[[dict valueForKey:@"profile_image"] objectAtIndex:i]];
            }
        }
        else{
            
        }
        
        
        
        int x=2;
        int contenx=0;
        for (int ind=0;ind<[profile_pic count];ind++)
        {
            NSURL * imageurl=[NSURL URLWithString:[profile_pic objectAtIndex:ind]];
            if (![imageurl isKindOfClass:[NSNull class]])
            {
                imageview=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 50, 50)];
                [imageview sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"user"]];
                [usrimageScroll addSubview:imageview];
                x=x+54;
                
                if(usrimageScroll.frame.size.width>x)
                {
                    contenx=x+2;
                }
                else  if(usrimageScroll.frame.size.width<x)
                {
                    contenx=(x*profile_pic.count)+usrimageScroll.frame.size.width;
                }
            }
        }
        [usrimageScroll setContentSize:CGSizeMake(x, usrimageScroll.frame.size.height)];
    }
    //int status=[[dict valueForKey:@"status"]intValue];
    int status = [[dict valueForKey:@"expire_post"]intValue];
    UIColor * color;
    switch (status)
    {
        case 0:
        {
            color=[UIColor darkGrayColor];
        }
            break;
        case 1:
        {
            color=[ServerManager colorWithR:167 G:48 B:62 A:1];
        }
            break;
    }
    NSString * paragraph;
    if([[dict valueForKey:@"name"] isKindOfClass:[NSArray class]]||[[dict valueForKey:@"name"] isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray * usr_name=[NSMutableArray arrayWithArray:[dict valueForKey:@"name"]];
        
        int timeValue=[[dict valueForKey:@"expiry_param"]intValue];
        NSString *strTime;
        NSString *strOther;
        
        switch (timeValue)
        {
            case 0:
            {
                strTime=@"Now";
            }
                break;
            case 1:
            {
                strTime=@"today";
            }
                break;
            case 2:
            {
                /*
                NSString *myDateString = [dict valueForKey:@"date_time"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *date = [dateFormatter dateFromString:myDateString];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
                
                NSInteger weekday = [components weekday];
                NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
                strTime=weekdayName;
                 */
                
                strTime=@"this weekend";

                
            }
                break;
            case 3:
            {
                strTime=@"anytime";
            }
                break;
            case 4:
            {
                NSString *myDateString = [dict valueForKey:@"date_time"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *date = [dateFormatter dateFromString:myDateString];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
                
                NSInteger weekday = [components weekday];
                NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
                strTime=weekdayName;
                
                strOther=@"Other";
                //strTime=@"Other";
            }
                break;
        }

        
        if (usr_name.count>0)
        {
            NSString* name=[usr_name componentsJoinedByString:@","];
            if (usr_name.count==1)
            {
                NSString *isExpire = [dict valueForKey:@"expire_post"];
                if ([strTime isEqualToString:@"Now"])
                {
                    if ([isExpire isEqualToString:@"1"])
                    {
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies right now .",name,activity];
                    }else{
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies.",name,activity];
                    }
                  
                    
                }
                else if ([strOther isEqualToString:@"Other"])
                {
                    if ([isExpire isEqualToString:@"1"])
                    {
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies on %@.",name,activity,strTime];
                    }
                    else{
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies.",name,activity];
                    }
                    strOther=@"";
                }

                
                else{
                    if ([isExpire isEqualToString:@"1"])
                    {
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies %@.",name,activity,strTime];
                    }
                    else{
                        paragraph=[NSString stringWithFormat:@"%@ is looking for %@ buddies.",name,activity];
                    }
                    
                }
                
            }
            else
            {
                
                NSString* name=[NSString stringWithFormat:@"%@&%@",[usr_name objectAtIndex:0],[usr_name objectAtIndex:1]];
                
                 NSString *isExpire = [dict valueForKey:@"expire_post"];
                if ([strTime isEqualToString:@"Now"])
                {
                    if ([isExpire isEqualToString:@"1"])
                    {
                        //changes according to client requirement.
                        //paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies right Now.",name,activity];
                         paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies.",name,activity];
                    }
                    else{
                         paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies.",name,activity];
                    }
                   
                }
                else
                {
                    if ([isExpire isEqualToString:@"1"])
                    {
                        //paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies. on %@",name,activity,strTime];
                        paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies.",name,activity];
                    }
                    else{
                        paragraph=[NSString stringWithFormat:@"%@ are now %@ buddies.",name,activity];
                    }
                    
                }
                
            }
        }
    }
    
    paragraph=[paragraph stringByReplacingOccurrencesOfString:[[NSUserDefaults standardUserDefaults] valueForKey:@"My_name"] withString:@"You"];
    NSMutableAttributedString * string;
    NSRange range = [paragraph rangeOfString:activity];
    
    [[ServerManager getSharedInstance]customFontFamilyname:OpenSansSemibold fontSize:12 success:^(UIFont *font)
     {
         description.font=font;
     }];
    if([paragraph length]>0)
    {
    string = [[NSMutableAttributedString alloc] initWithString:paragraph];
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location,range.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(range.location,range.length)];
    
    description.attributedText=string;
    }
    else
    {
        string=[[NSMutableAttributedString alloc] initWithString:@"No value"];
       description.attributedText=string;
    }
    
}
@end
