//
//  UIFacebookBrowser.m
//  BuddySystem
//
//  Created by Jitendra on 10/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "UIFacebookBrowser.h"

@interface UIFacebookBrowser ()

@end

@implementation UIFacebookBrowser
@synthesize fblink;
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
    
    if ([[ServerManager getSharedInstance]checkNetwork]==YES)
    {
        NSURLRequest * request=[[NSURLRequest alloc]initWithURL:fblink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [facebookBrowser loadRequest:request];
    }
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showLoading:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ServerManager showAlertView:@"Message" withmessage:error.localizedDescription];
}

-(void)showLoading:(BOOL)animation
{
    if (animation==YES)
    {
        
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[self.view layer] addAnimation:animation forKey:@"Fade"];
        loadHud.alpha=1.0f;
        [loadHud startAnimating];
        [CATransaction commit];
    }
    else
    {
        
        [CATransaction begin];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [[self.view layer] addAnimation:animation forKey:@"Fade"];
        [loadHud stopAnimating];
        loadHud.alpha=0.0f;
        
        [loadHud setHidesWhenStopped:YES];
        [CATransaction commit];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)OnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
