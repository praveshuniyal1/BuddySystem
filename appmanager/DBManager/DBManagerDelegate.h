//
//  DBManagerDelegate.h
//  BuddySystem
//
//  Created by Jitendra on 11/03/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@protocol DBManagerDelegate <NSObject>
@optional

-(void)database:(DBManager*)database success:(BOOL)_issuccess withSatement:(NSString*)statement;

@end


#import <Foundation/Foundation.h>
@class ILGeoNamesSearchController;
@protocol ILGeoNamesSearchControllerNewDelegate <NSObject>
@optional

-(void)locationView:(ILGeoNamesSearchController*)locationView didselectlocation:(NSDictionary*)locationdict;

@end

#import <Foundation/Foundation.h>
@class ServerManager;

@protocol ServerManagerDelegate <NSObject>

@optional
-(void)serverReponse:(NSDictionary*)responseDict withrequestName:(NSString*)serviceurl;
-(void)failureRsponseError:(NSError*)failureError;

-(void)downloadFile:(NSURL*)fileUrl withrequestName:(NSURL*)serviceurl;

@optional
- (void)servermanager:(ServerManager *)manager didTapOnMenuOption:(NSString*)title;

@end


#import <Foundation/Foundation.h>
@class JkDateTimePicker;

@protocol JkDateTimePickerDelegate <NSObject>

-(void)jkdatetimepicker:(JkDateTimePicker*)jkdatetimepicker didselectdatetime:(NSString*)selectdatetime currentMode:(NSString*)datetimemode;
-(void)jkdatetimepicker:(JkDateTimePicker*)jkdatetimepicker hide:(BOOL)animation;

@end