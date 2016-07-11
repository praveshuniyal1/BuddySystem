//
//  JkDateTimePicker.h
//  Injury Lawyer
//
//  Created by Webastral on 06/12/14.
//  Copyright (c) 2014 Pardeep Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManagerDelegate.h"
#import "ServerManager.h"
//@class JkDateTimePicker;
//
//@protocol JkDateTimePickerDelegate <NSObject>
//
//-(void)jkdatetimepicker:(JkDateTimePicker*)jkdatetimepicker didselectdatetime:(NSString*)selectdatetime currentMode:(NSString*)datetimemode;
//-(void)jkdatetimepicker:(JkDateTimePicker*)jkdatetimepicker hide:(BOOL)animation;
//
//@end

UIKIT_EXTERN NSString *const DateMode;
UIKIT_EXTERN NSString *const TimeMode;
UIKIT_EXTERN NSString *const DateTimeMode;
@interface JkDateTimePicker : UIView
{
    NSDate * currentDate;
    NSDateFormatter * dateformate;
    
    
    NSString * selectdatetime;
    
    id<JkDateTimePickerDelegate>Delegate;
    
    @public
    IBOutlet UIDatePicker *datepicker;

    
   
}
@property(strong,nonatomic)id<JkDateTimePickerDelegate>Delegate;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (assign, nonatomic) BOOL showToolBar;
- (IBAction)DidSelectDateTime:(id)sender;
@property(strong,nonatomic)NSString *pickerMode;
- (id)initWithFrame:(CGRect)frame pickerMode:(NSString*)JKDatePickerMode;
- (id)initTimepickerFrame:(CGRect)frame pickerMode:(NSString*)JKDatePickerMode;
- (id)initDateTimepickerFrame:(CGRect)frame pickerMode:(NSString*)JKDatePickerMode;
-(void)showToolBar:(BOOL)show;
- (IBAction)TappedOnToolBarBtn:(id)sender;

@end
