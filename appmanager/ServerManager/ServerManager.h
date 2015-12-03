//
//  ServerManager.h
//  Hello
//
//  Created by webAstral on 11/3/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Constants.h"
#import "MPNotificationView.h"
#import <MediaPlayer/MediaPlayer.h>
#import<AVFoundation/AVFoundation.h>
#import "JKClassManager.h"
#import "DBManagerDelegate.h"
UIKIT_EXTERN NSString *const imageFile;
UIKIT_EXTERN NSString *const videoFile;
UIKIT_EXTERN NSString *const audioFile;

typedef void(^ServerManagerDownloadImageCompletionWithFinishedBlock)(UIImage *image,BOOL finished);

// Custom fontname
typedef enum : NSUInteger
{
    OpenSansBold=0,
    OpenSansBoldItalic,
    OpenSansCondBold,
    OpenSansCondLight,
    OpenSansCondLightItalic,
    OpenSansItalic,
    OpenSansLight,
    OpenSansLightItalic,
    OpenSansRegular,
    OpenSansSemibold,
    OpenSansSemiboldItalic,
    
} customFontTag;

typedef enum : NSUInteger {
    imageTypeDwn,
    videoTypeDwn,
    audioTypeDwn,
    ZipTypeDwn,
    pdfTypeDwn,
    docTypeDwn,
    textTypeDwn,
} suggestedFilename;


typedef enum : NSUInteger {
    ddmmyyyy=0,
    yyyymmdd,
    EEEddMMMyyyy,
    ddmmyyyyHHmmSS,
    yyyymmddHHmmSS,
     EEEddMMMyyyyHHmmSS,
    hhmmss,
    
} dateFormater;
//@class ServerManager;
//
//@protocol ServerManagerDelegate <NSObject>
//
//@optional
//-(void)serverReponse:(NSDictionary*)responseDict withrequestName:(NSString*)serviceurl;
//-(void)failureRsponseError:(NSError*)failureError;
//
//-(void)downloadFile:(NSURL*)fileUrl withrequestName:(NSURL*)serviceurl;
//
//@optional
//- (void)servermanager:(ServerManager *)manager didTapOnMenuOption:(NSString*)title;
//
//@end
@interface ServerManager : NSObject<UIAlertViewDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
{
    MBProgressHUD * HUD;
    id<ServerManagerDelegate>Delegate;
    AVAudioPlayer*  audioPlayer;
    UIImage * thumbImg;
    NSInteger downloadFileType;
    NSURL * downloadReqestPath;
}


@property(strong,nonatomic)id<ServerManagerDelegate>Delegate;
@property(assign,nonatomic)  NSInteger downloadFileType;
@property BOOL internetActive;
+(ServerManager*)getSharedInstance;
-(NSString*)jsonRepresentForm:(id)object;
-(id)jsonArrayFromjsonstring:(NSString*)object;
+(void)showAlertView:(NSString*)title withmessage:(NSString*)message ;
-(UIImage*)chatAvstarImage:(NSURL*)imageurl;
/*  Methods of MBProgressHUD */
-(void)showactivityHub:(NSString*)message addWithView:(UIView*)myView;
-(void)showProgressBarWithView:(UIView *)myView MBProgressHUDMode:(int)mode;
-(void)reciveProgressData:(float)progress lable:(NSString*)txtlabel;
-(void)hideHud;
-(BOOL)checkNetwork;
-(UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSInteger)ageFromBirthday:(NSDate *)birthdate ;
+ (NSString *)GetUUID;
// date
- (NSDate *)localDateStringForISODateTimeString:(NSString *) anISOString;
-(NSDate*)dateTimeInterval:(NSTimeInterval)secsToBeAdded setFormate:(int)formate sinceDate:(NSDate *)date;
-(id)setCustomeDateFormateWithUTCTimeZone:(int)formate withtime:(id)timedate;
-(NSString *)getUTCFormateDate:(NSDate *)localDate;
-(NSDate *)dateFromDouble:(double) interval;
//
-(NSURL*)Fb_profileImageFile:(NSString*)user_id;
-(UIImage *)fetchTheImage:(NSURL *)urlname;
//genrateThumbnil-
-(void)genrateThumbnil:(NSURL*)filepath  thumbnilSize:(CGSize)maxSize success:(void (^)(UIImage* thumbnil))success failure:(void (^)( NSError *error))failure;
-(void)shownotificationbar:(NSDictionary *)notifidict;
-(NSString*)mediaFileName;
//******* Service Methods*********//
-(NSString*)createServerPath:(NSString*)requestPath;

-(void)postDataOnserver:(NSDictionary*)postDict withrequesturl:(NSString*)postUrl;
-(void)FetchDatafromServer:(NSString*)UrlString withAppendString:(NSString*)appendString;
-(void)postDatawithMediaFile:(NSDictionary *)postDict MediaFile:(NSMutableArray*)mediaarray setMediaKey:(NSString*)MediaKey  withPostUrl:(NSString *)postUrl mediaType:(NSString*)type is_multiple:(BOOL)ismultiple;
-(void)downloadMediaFile:(NSURL*)medialpath typefile:(NSInteger)filetype success:(void (^)(NSURL* filePath))success failure:(void (^)( NSError *error))failure;

// * Plish read write method-

-(void)writeDataInPlist:(NSDictionary*)myDict;
-(NSDictionary*)readDatafromPlist;

-(CGSize)gettextsize:(NSString*)text font:(UIFont*)textfont constrainedToSize:(CGSize)constrainedsize;

// MD5 String

-(NSString*)getVideoPath_name:(NSString*)filename;
-(NSString*)genrateMD5String;

-(void)getImageFromServerPath:(NSURL *)imageURL completed:(ServerManagerDownloadImageCompletionWithFinishedBlock)completedBlock;

-(void)customFontFamilyname:(NSInteger)customFontTag  fontSize:(CGFloat)fontSize success:(void (^)(UIFont* font))success;

-(void)locationsearchByAddress:(NSString*)address Success:(void(^)(NSDictionary * responsedic))success failure:(void(^)(NSError *error))failure;
//


-(UIImageView*)videothumnilview;

#ifdef __IPHONE_8_0
-(void)UIVisualEffect:(UIVisualEffectView*)VisualControl;
#endif

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha ;
+(void)changeTextColorOfSearchBarButton:(UIColor*)color;

@end
