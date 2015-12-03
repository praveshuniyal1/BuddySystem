//
//  JKMenuView.m
//  BuddySystem
//
//  Created by Jitendra on 15/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "JKMenuView.h"
CGFloat const kFadeInAnimationDuration = 0.3;
CGFloat const kTransformPart1AnimationDuration = 0.2;
CGFloat const kTransformPart2AnimationDuration = 0.1;
static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear
};
static float aninationTime=0.8;
static int curveIndex=2;
@implementation JKMenuView
@synthesize Delegate,btnBgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString* nibIdentifier;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            nibIdentifier=@"JKMenuView_ipad";
        }
        else
        {
            nibIdentifier=@"JKMenuView";
        }
        self=[[[NSBundle mainBundle]loadNibNamed:nibIdentifier owner:self options:nil] objectAtIndex:0];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    contentView.frame=rect;
    // Drawing code
    contentView.alpha=0.0f;
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [[contentView layer] addAnimation:animation forKey:@"Fade"];
    contentView.alpha=1.0f;
    
    [CATransaction commit];
    [self addSubviewWithZoomInAnimation:btnBgView duration:aninationTime option:curveValues[curveIndex]];

    
}




- (IBAction)TappedOnClose:(id)sender
{
    
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [[contentView layer] addAnimation:animation forKey:@"Fade"];
   
    contentView.alpha=0.0f;
    [CATransaction commit];
    [btnBgView removeWithZoomOutAnimation:aninationTime option:curveValues[curveIndex]];
    [Delegate hidejkpopmenu:YES fromview:self.superview];
}

- (IBAction)TappedOnSetting:(id)sender
{
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [[contentView layer] addAnimation:animation forKey:@"Fade"];
    
    contentView.alpha=0.0f;
    [CATransaction commit];
    [self removeZoomanimation];
    [Delegate presentSettingController:YES];
    //[KappDelgate didSelectJKMenu:@"Settings"];
}

- (IBAction)SelectMenu:(id)sender
{
    switch ([sender tag])
    {
        case 100:
        {
            //Do somthing
            [self removeZoomanimation];
            [Delegate jkmenu:self didselectitem:0];
            //[KappDelgate didSelectJKMenu:@"doSomething"];
        }
            break;
        case 101:
        {
            //WhatHappning
            [self removeZoomanimation];
            [Delegate jkmenu:self didselectitem:1];
           // [KappDelgate didSelectJKMenu:@"WhatHappning"];
        }
            break;
        case 102:
        {
            //MyActivities
            [self removeZoomanimation];
             [Delegate jkmenu:self didselectitem:2];
           // [ KappDelgate didSelectJKMenu:@"MyActivities"];
        }
            break;
            
        default:
            break;
    }
}

-(void)removeZoomanimation
{
    [btnBgView removeWithZoomOutAnimation:aninationTime option:curveValues[curveIndex]];
}
@end
