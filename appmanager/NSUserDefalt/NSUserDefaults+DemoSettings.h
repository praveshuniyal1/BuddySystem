//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const kFriendList;
UIKIT_EXTERN NSString *const kLoginUserInfo;

@interface NSUserDefaults (DemoSettings)

+(void)setNSUserDefaultobject:(id)object key:(NSString*)key;
+(void)setNSUserDefaultValue:(id)value key:(NSString*)key;
+(id)getNSUserDefaultValueForKey:(NSString*)key;
+(id)getNSUserDefaultObjectForKey:(NSString*)key;
+(void)setNSUserDefaultBoolValue:(BOOL)object key:(NSString*)key;
+(BOOL)GetUserDefaultBoolValueOfKey:(NSString*)key;
+(void)removeNSUserDefaultObjectForKey:(NSString*)key;

@end
