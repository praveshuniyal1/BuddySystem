//
//  JKMenuView.h
//  BuddySystem
//
//  Created by Jitendra on 15/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"
extern NSString *const KGModalWillShowNotification;
extern NSString *const KGModalDidShowNotification;
extern NSString *const KGModalWillHideNotification;
extern NSString *const KGModalDidHideNotification;

extern CGFloat const kFadeInAnimationDuration ;
extern CGFloat const kTransformPart1AnimationDuration ;
extern CGFloat const kTransformPart2AnimationDuration ;

@class JKMenuView;

@protocol JKMenuPopDelegate <NSObject>

-(void)hidejkpopmenu:(BOOL)animation fromview:(UIView*)fromView;
-(void)presentSettingController:(BOOL)anination;
-(void)jkmenu:(JKMenuView*)jkmenu didselectitem:(NSInteger)itemindex;

@end
@interface JKMenuView : UIView
{
    IBOutlet UIView *btnBgView;
    
    IBOutlet UIView *contentView;
}

@property(strong,nonatomic)IBOutlet UIView *btnBgView;

@property(strong,nonatomic)id<JKMenuPopDelegate>Delegate;
- (IBAction)TappedOnClose:(id)sender;
- (IBAction)TappedOnSetting:(id)sender;
- (IBAction)SelectMenu:(id)sender;
-(void)removeZoomanimation;

@end
