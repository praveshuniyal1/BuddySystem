//
//  JKPlayer.m
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "JKPlayer.h"

@implementation JKPlayer
@synthesize contenturl;
-(id)initWithjkplayerFrame:(CGRect)frame withcontentUrl:(NSURL *)fileurl
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self=[[[NSBundle mainBundle]loadNibNamed:@"JKPlayer" owner:self options:nil] objectAtIndex:0];
        self.contenturl=fileurl;
        bgplayerview.frame=self.bounds;
    }
    return self;
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
{
 // Drawing code
     [self initilizePlayer];
 }
-(void)initilizePlayer
{
    if (moviewplayer==nil)
    {
        moviewplayer=[[MPMoviePlayerController alloc]initWithContentURL:contenturl];
    }
    moviewplayer.view.frame=bgplayerview.bounds;
    [bgplayerview addSubview:moviewplayer.view];
    moviewplayer.scalingMode = MPMovieScalingModeAspectFill;
    moviewplayer.fullscreen=NO;
    moviewplayer.movieSourceType = MPMovieSourceTypeFile;
    moviewplayer.controlStyle=MPMovieControlStyleNone;
    moviewplayer.contentURL=contenturl;
    moviewplayer.repeatMode=MPMovieRepeatModeOne;
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviewplayer name:MPMoviePlayerPlaybackDidFinishNotification object:moviewplayer];
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(movieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:moviewplayer];
    [moviewplayer prepareToPlay];
    [moviewplayer play];
}


#pragma mark-movieFinishedCallback-
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        
       
        [moviewplayer stop];
        
        
        
    }
}

-(void)playCurrentVideo
{
    if (contenturl!=nil)
    {
        [moviewplayer stop];
        
         moviewplayer.contentURL=contenturl;
        [moviewplayer play];
        [moviewplayer setShouldAutoplay:YES];
    }
    
}

-(void)stopCurrentVideo
{
    if (contenturl!=nil)
    {
        [moviewplayer stop];
        //[moviewplayer pause];
        
       
    }
}

-(void)playnewVideoWithUrl:(NSURL *)fileurl
{
    contenturl=[fileurl copy];
    
    if([moviewplayer playbackState]==MPMoviePlaybackStatePlaying)
    {
        [moviewplayer pause];
    }
    
     moviewplayer.contentURL=contenturl;
    [moviewplayer play];
    [moviewplayer setShouldAutoplay:YES];
}


@end
