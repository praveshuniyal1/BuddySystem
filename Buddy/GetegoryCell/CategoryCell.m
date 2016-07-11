//
//  GetegoryCell.m
//  BuddySystem
//
//  Created by Jitendra on 19/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize letsdoThisbtn,btnDelete;

-(void)loadCategoryListData:(NSDictionary*)dict
{
    [[ServerManager getSharedInstance]UIVisualEffect:visualEffectView];
    NSString * title=[dict valueForKey:@"category"];
    [categoryTitlebtn setTitle:title forState:UIControlStateNormal];
    
}
-(void)loadFBWallPostCellData:(NSDictionary *)dict
{
    
    fbfriendimage.layer.cornerRadius=fbfriendimage.frame.size.width/2;
    [fbfriendimage.layer setBorderWidth:1];
    [fbfriendimage.layer setBorderColor:[UIColor whiteColor].CGColor];
    [fbfriendimage.layer setMasksToBounds:YES];
   // NSURL * fileurl=[[ServerManager getSharedInstance]Fb_profileImageFile:[dict valueForKey:@"id"]];
     NSURL * fileurl=[[ServerManager getSharedInstance]Fb_profileImageFile:[dict valueForKey:@"fb_id"]];
    
    fbfriendimage.imageURL=fileurl;
    
    
}
-(void)loadSuggestActivityData:(NSDictionary *)dict
{
    self.layer.cornerRadius=7;
    self.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.layer.borderWidth=1;
    UIFont  *descFont=lbl_title.font;
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        descFont=[UIFont systemFontOfSize:20];
//    }
//    else
//    {
//        descFont=[UIFont systemFontOfSize:15];
//    }

    NSString * activity=[dict valueForKey:@"activity"];
    if([activity isEqual:[NSNull null]])
    {
        activity=@"No Activity";
    }
    CGSize descpSize= [[ServerManager getSharedInstance]gettextsize:activity font:descFont constrainedToSize:CGSizeMake(lbl_title.frame.size.width, 1000)];
    lbl_title.text=activity;
    

        lbl_title.frame=CGRectMake(lbl_title.frame.origin.x, lbl_title.frame.origin.y, descpSize.width+10, lbl_title.frame.size.height);
        
        btnDelete.frame=CGRectMake(lbl_title.frame.origin.x+descpSize.width+5, btnDelete.frame.origin.y, btnDelete.frame.size.width, btnDelete.frame.size.height);
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, btnDelete.frame.size.width+lbl_title.frame.size.width+5, self.frame.size.height);

    
    
}
@end
