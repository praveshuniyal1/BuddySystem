//
//  CustomApplication.m
//  buddy
//
//  Created by amit varma on 22/12/15.
//  Copyright © 2015 WebAstral. All rights reserved.
//

#import "CustomApplication.h"

@implementation CustomApplication
{
    NSTimer *idleTimer;
    NSTimeInterval *maxIdleTime;
}

- (void)sendEvent:(UIEvent *)event
{
    [[UIScreen mainScreen] setBrightness: 1.0];
    [super sendEvent:event];
    
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        // allTouches count only ever seems to be 1, so anyObject works here.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
            [self resetIdleTimer];
    }
}

- (void)resetIdleTimer
{
    if (idleTimer) {
        [idleTimer invalidate];
        
    }
    
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO] ;
}

- (void)idleTimerExceeded
{
    [[UIScreen mainScreen] setBrightness: 0.1];
    NSLog(@"idle time exceeded");
    
}


@end
