//
//  ShareVC.m
//  BuddySystem
//
//  Created by Jitendra on 28/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "ShareVC.h"
#import "WhatHappendVC.h"
@interface ShareVC ()

@end

@implementation ShareVC
@synthesize shareDict;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    sharebtn.layer.cornerRadius=7;
    sharebtn.layer.borderColor=[[UIColor whiteColor]CGColor];
    sharebtn.layer.borderWidth=2;
    
    //[self bgplayer];
    [[ServerManager getSharedInstance]customFontFamilyname:OpenSansSemibold fontSize:18 success:^(UIFont *font)
     {
         [timeCatbtn setTintColor:[UIColor whiteColor]];
         [timeCatbtn setTitle:[shareDict valueForKey:@"CatTime"] forState:UIControlStateNormal];
         timeCatbtn.titleLabel.font=font;
     }];
    
    [[ServerManager getSharedInstance]customFontFamilyname:OpenSansRegular fontSize:18 success:^(UIFont *font) {
       
        cattext.text=[NSString stringWithFormat:@"Ok we are now searching for %@ buddies.", [self.shareDict valueForKey:@"cat_name"]];
        cattext.textColor=[UIColor whiteColor];
        cattext.editable=NO;
        cattext.font=font;
        
    }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [self bgplayer];
}
-(void)bgplayer
{
    
    NSString * filename=[shareDict valueForKey:@"videoFile"];
    filename = [filename stringByReplacingOccurrencesOfString:@"http://dev414.trigma.us/Buddy/files/activities/video/"
                                                   withString:@""];
    
    NSString * videoPath=[[DBManager getSharedInstance]getFilePath:filename];
    if (![videoPath isEqual:@"No found"])
    {
        
        
        NSURL * fileUrl= [NSURL fileURLWithPath:videoPath];
        
        
        [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TappedOnShare:(id)sender
{

    NSURL * youtube_link=[NSURL URLWithString:[shareDict valueForKey:@"youtube_link"]];
    NSString * cat_name =[shareDict valueForKey:@"cat_name"];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[cattext.text,youtube_link,cat_name] applicationActivities:nil];
    //    // Exclude all activities except AirDrop.
    //    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
    //                                    UIActivityTypeMessage, UIActivityTypeMail];
    //    activityViewController.excludedActivityTypes = excludedActivities;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Show UIActivityViewController
        [self presentViewController:activityViewController animated:YES completion:NULL];
    } else {
        // Create pop up
        self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        // Store reference to superview (UIPopoverController) to allow dismissal
        // Show UIActivityViewController in popup
        [self.activityPopoverController presentPopoverFromRect:sharebtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    

}

- (IBAction)TappedOnMenu:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
}




- (IBAction)TappedOnHappend:(id)sender
{
    UIStoryboard * mainStoryboard=[self mainstoryboard];

    WhatHappendVC * happningview=[mainStoryboard instantiateViewControllerWithIdentifier:@"WhatHappendVC"];
    
    [self.navigationController pushViewController:happningview animated:YES];
    
    
}

#pragma mark-mainstoryboard-
-(UIStoryboard*)mainstoryboard
{
    UIStoryboard * mainStoryboard;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        mainStoryboard=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    else
    {
        mainStoryboard=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    return mainStoryboard;
}

@end
