//
//  JkDateTimePicker.m
//  Injury Lawyer
//
//  Created by Webastral on 06/12/14.
//  Copyright (c) 2014 Pardeep Batra. All rights reserved.
//

#import "JkDateTimePicker.h"
NSString *const DateMode=@"UIDatePickerModeDate";
NSString *const TimeMode=@"UIDatePickerModeTime";
NSString *const DateTimeMode=@"UIDatePickerModeDateAndTime";
@implementation JkDateTimePicker
@synthesize Delegate,pickerMode,showToolBar;
- (id)initWithFrame:(CGRect)frame pickerMode:(NSString*)JKDatePickerMode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self=[[[NSBundle mainBundle]loadNibNamed:@"JkDateTimePicker" owner:self options:nil] objectAtIndex:0];
        
        if ([JKDatePickerMode isEqual:DateMode])
        {
            datepicker.datePickerMode=UIDatePickerModeDate;
                    }
//        else if ([JKDatePickerMode isEqual:TimeMode])
//        {
//            datepicker.datePickerMode=UIDatePickerModeTime;
//
//        }
        
    }
    return self;
}
- (id)initDateTimepickerFrame:(CGRect)frame pickerMode:(NSString*)JKDatePickerMode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self=[[[NSBundle mainBundle]loadNibNamed:@"JkDateTimePicker" owner:self options:nil] objectAtIndex:0];
        
        if ([JKDatePickerMode isEqual:DateTimeMode])
        {
            datepicker.datePickerMode=UIDatePickerModeDateAndTime;
            
        }
        
    }
    return self;
}


-(id)initTimepickerFrame:(CGRect)frame pickerMode:(NSString *)JKDatePickerMode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self=[[[NSBundle mainBundle]loadNibNamed:@"JkDateTimePicker" owner:self options:nil] objectAtIndex:0];
        
        if ([JKDatePickerMode isEqual:TimeMode])
        {
            datepicker.datePickerMode=UIDatePickerModeTime;
            
        }
        
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    datepicker.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if ([pickerMode isEqual:DateMode])
    {
        [self selectdate];
    }
    else  if ([pickerMode isEqual:TimeMode])
    {
        [self selectTime];
        
    }
    else  if ([pickerMode isEqual:DateTimeMode])

    {
       // [self selectdatetimeboth];

    }
   
}


- (IBAction)DidSelectDateTime:(id)sender
{
//    if ([pickerMode isEqual:DateMode])
//    {
//        [self selectdate];
//    }
//    else  if ([pickerMode isEqual:TimeMode])
//    {
//        [self selectTime];
//        
//    }
//    else if ([pickerMode isEqual:DateTimeMode])
//    {
//        [self selectdatetimeboth];
//    }
    

}

-(void)selectdate
{
    
        // Convert string to date object
        currentDate=datepicker.date;
        
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        //[dateFormat setDateFormat:@"d LLLL yyyy"];
//    
//        [dateFormat setDateFormat:@"dd-MM-yyyy"];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectdatetime=[[ServerManager getSharedInstance] setCustomeDateFormateWithUTCTimeZone:yyyymmdd withtime:currentDate];
       if (showToolBar==false)
        [Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:DateMode];
    
        
    
}



-(void)selectdatetimeboth
{
    
    // Convert string to date object
    
    //currentDate=datepicker.date;
    
    NSString *dateString=[self getPastDateFromString:datepicker.date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    currentDate = [dateFormat dateFromString:dateString];

    

    selectdatetime=[[ServerManager getSharedInstance] setCustomeDateFormateWithUTCTimeZone:yyyymmddHHmmSS withtime:currentDate];
    // if (showToolBar==false)
    [Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:@"Done"];
    
    
}
-(NSString *)getPastDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(void)selectTime
{
  
        currentDate=datepicker.date;
      
        selectdatetime=[[ServerManager getSharedInstance] setCustomeDateFormateWithUTCTimeZone:hhmmss withtime:currentDate];;
        if (showToolBar==false)
         [Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:TimeMode];
   
}
- (IBAction)TappedOnToolBarBtn:(id)sender
{
    switch ([sender tag]) {
        case 101:
        {
            //done
            if ([pickerMode isEqual:TimeMode])
            {
                [self selectTime];
                //[Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:TimeMode];
            }
            else if ([pickerMode isEqual:DateTimeMode])
            {
                [self selectdatetimeboth];
                //[Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:DateTimeMode];
            }
            else if ([pickerMode isEqual:DateMode])
            {
                [self selectdate];
                //[Delegate jkdatetimepicker:self didselectdatetime:selectdatetime currentMode:DateMode];
            }
        
            
        }
            break;
            
        default:
            //cancel
            [Delegate jkdatetimepicker:self hide:YES];
            break;
    }
}
-(void)showToolBar:(BOOL)show
{
    if (showToolBar==false)
    {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-self.toolbar.frame.size.height);
        self.toolbar.frame=CGRectMake(0, 0, 0, 0);
        
    }
    else
    {
         self.toolbar.frame=CGRectMake(self.frame.origin.x,datepicker.frame.size.height+datepicker.frame.origin.y, self.frame.size.width, 44);
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+self.toolbar.frame.size.height);
       
        
    }
    
}


@end
