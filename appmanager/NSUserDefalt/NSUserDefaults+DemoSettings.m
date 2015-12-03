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

#import "NSUserDefaults+DemoSettings.h"

 NSString * const kFriendList = @"friendsdata";
 NSString * const kLoginUserInfo = @"user_info";



@implementation NSUserDefaults (DemoSettings)

+(void)setNSUserDefaultBoolValue:(BOOL)object key:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]setBool:object forKey:key];
}

+(BOOL)GetUserDefaultBoolValueOfKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:key];
}
+(void)setNSUserDefaultobject:(id)object key:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
     [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)setNSUserDefaultValue:(id)value key:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(id)getNSUserDefaultValueForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:key];
    
}
+(id)getNSUserDefaultObjectForKey:(NSString*)key
{
    
   
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
}
+(void)removeNSUserDefaultObjectForKey:(NSString*)key
{
    return  [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

@end
