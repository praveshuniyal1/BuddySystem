//
//  JKAlertView.m
//  UIAlertViewBlocks
//
//  Created by Jitendra on 20/02/15.
//  Copyright (c) 2015 Ryan Maxwell. All rights reserved.
//

#import "JKAlertView.h"

@implementation JKAlertView
@synthesize placeholderText;
#pragma mark -
#pragma mark - Singleton

+ (JKAlertView *)shared
{
    static JKAlertView *jkalertView = nil;
    
    @synchronized (self){
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            jkalertView = [[JKAlertView alloc] init];
        });
    }
    
    return jkalertView;
}

#pragma mark- JkAlertViewForDoubleInput-
+(void)showAlertLoginInputWithMessage:(NSString*)message title:(NSString*)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles ComplitionHandlerDoubleInputViewBlock:(JkAlertViewForDoubleInputCallback)doubleInputCallback
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
        [[JKAlertView shared]showAlertLoginInputWithMessage:message title:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles ComplitionHandlerDoubleInputViewBlock:doubleInputCallback];
    }];
    
}
#pragma mark- JkAlertViewForSingleInput-
+(void)showAlertSingleInputWithMessage:(NSString*)message title:(NSString*)title style:(UIAlertViewStyle)style cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles ComplitionHandlerSingleInputViewBlock:(JkAlertViewForSingleInputCallback)singleInputCallback
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
        [[JKAlertView shared]showAlertSingleInputWithMessage:message title:title style:style cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles ComplitionHandlerSingleInputViewBlock:singleInputCallback];
    }];
    
}
#pragma mark- JkAlertViewMessage-
+(void)showalertWithMessage:(NSString*)message title:(NSString*)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertComplitionHandler:(JkAlertViewCallback)callBack
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
         [[JKAlertView shared]showalertWithMessage:message title:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles alertComplitionHandler:callBack];
    }];
   
}

-(void)showAlertLoginInputWithMessage:(NSString*)message title:(NSString*)title  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles ComplitionHandlerDoubleInputViewBlock:(JkAlertViewForDoubleInputCallback)doubleInputCallback
{
    
    
    [UIAlertView showWithTitle:title message:message style:UIAlertViewStyleLoginAndPasswordInput cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
          doubleInputCallback(alertView,[[alertView textFieldAtIndex:0] text],[[alertView textFieldAtIndex:1] text],buttonIndex);
//         if (buttonIndex == alertView.firstOtherButtonIndex)
//         {
//             NSLog(@"Username: %@", [[alertView textFieldAtIndex:0] text]);
//             NSLog(@"Password: %@", [[alertView textFieldAtIndex:1] text]);
//            
//             
//         } else if (buttonIndex == alertView.cancelButtonIndex)
//         {
//             NSLog(@"Cancelled.");
//         }
         
     }];

}
-(void)showAlertSingleInputWithMessage:(NSString*)message title:(NSString*)title  style:(UIAlertViewStyle)style cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles ComplitionHandlerSingleInputViewBlock:(JkAlertViewForSingleInputCallback)singleInputCallback
{
   UIAlertView *alertView=   [UIAlertView showWithTitle:title message:message style:style cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         
        singleInputCallback(alertView,[[alertView textFieldAtIndex:0] text],buttonIndex);
         
     }];
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = placeholderText;
}
-(void)showalertWithMessage:(NSString*)message title:(NSString*)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertComplitionHandler:(JkAlertViewCallback)callBack
{
    [UIAlertView showWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        callBack(alertView,buttonIndex);
    }];
}

+(void)setplaceholderText:(NSString *)placeholderText
{
    [[JKAlertView shared]setplaceholderText:placeholderText];
}
-(void)setplaceholderText:(NSString*)_placeholderText
{
    placeholderText=[_placeholderText copy];
}
@end
