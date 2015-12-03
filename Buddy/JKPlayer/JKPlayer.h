//
//  JKPlayer.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JKClassManager.h"
@interface JKPlayer : UIView
{
    
   
    IBOutlet UIView *bgplayerview;
    MPMoviePlayerController * moviewplayer;
}
@property (strong,nonatomic)NSURL * contenturl;
@property (strong,nonatomic)  MPMoviePlayerController * moviewplayer;
-(id)initWithjkplayerFrame:(CGRect)frame withcontentUrl:(NSURL*)fileurl;

-(void)playCurrentVideo;
-(void)stopCurrentVideo;
-(void)playnewVideoWithUrl:(NSURL*)fileurl;
-(void)initilizePlayer;
@end
