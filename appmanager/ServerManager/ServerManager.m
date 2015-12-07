//
//  ServerManager.m
//  Hello
//
//  Created by webAstral on 11/3/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager
@synthesize Delegate,downloadFileType;
NSString *const imageFile=@"image";
NSString *const videoFile=@"video";
NSString *const audioFile=@"audio";
static ServerManager *sharedInstance = nil;

+(ServerManager*)getSharedInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!sharedInstance)
        {
            sharedInstance = [[self alloc] init];
        }
        //allochiamo la sharedInstance
        
    });
    return sharedInstance;
}
#pragma mark- Custom AlerView-
+(void)showAlertView:(NSString *)title withmessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    
    
}

#pragma mark- All Methods Of MbProgressHud-

-(void)showactivityHub:(NSString *)message addWithView:(UIView *)myView
{
    // hud=[MBBarProgressView];
    
    HUD = [MBProgressHUD showHUDAddedTo:myView animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"";
    HUD.dimBackground=YES;
    // [HUD show:YES];
   	//HUD.delegate = self;
	
    
	
    
}

#pragma mark-showProgressBarWithView-
-(void)showProgressBarWithView:(UIView *)myView MBProgressHUDMode:(int)mode
{
    HUD = [MBProgressHUD showHUDAddedTo:myView animated:YES];
	//[myView addSubview:HUD];
    HUD.dimBackground=YES;
    [HUD show:YES];
    
	// Set determinate bar mode
    switch (mode)
    {
        case HorizontalBarMode:
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            break;
        case RingBarMode:
            HUD.mode = MBProgressHUDModeAnnularDeterminate;
            break;
        case piechartBarMode:
            HUD.mode = MBProgressHUDModeDeterminate;
            break;
            
        default:
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            break;
    }
	HUD.delegate = self;
    
	// myProgressTask uses the HUD instance to update progress
    
}

#pragma mark- reciveProgressData-
-(void)reciveProgressData:(float)progress lable:(NSString*)txtlabel
{
    
    //float uploadActualPercentage = progress * 100;
    if(progress==1.0 ||progress>=0.99)
    {
        HUD.hidden=YES;
    }
    HUD.progress = progress;
    //HUD.labelText=[NSString stringWithFormat:@"%.2f %@",uploadActualPercentage,txtlabel];
    
    
}
#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

-(void)hideHud
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    
}

-(void)shownotificationbar:(NSDictionary *)notifidict
{
    
    int content_type=[[notifidict valueForKey:@"notification_type"] intValue];
    
    switch (content_type)
    {
        case 1:
        {
            // match
            NSOperationQueue * myQueue=[NSOperationQueue new];
            [myQueue addOperationWithBlock:^{
            
                NSString * content=[notifidict valueForKey:@"message"];
                NSString * name=[notifidict valueForKey:@"usr_name"];
                NSString * usr_id=[notifidict valueForKey:@"usr_id"];
                NSURL * imageurl=[self Fb_profileImageFile:usr_id];
                UIImageView * profileimagv=[self videothumnilview];
            
                [profileimagv sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"user"]];
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
                    [self play];
            
                    [MPNotificationView notifyWithText:name
                                                detail:content
                                                 image:profileimagv.image
                                           andDuration:5.0];

                }];
            
            }];
            
            }
            break;
        case 2:
        {
            // chat
//            NSOperationQueue * myQueue=[NSOperationQueue new];
//            [myQueue addOperationWithBlock:^{
//                
//                NSString * content=[notifidict valueForKey:@"message"];
//                NSString * name=[notifidict valueForKey:@"usr_name"];
//                NSString * usr_id=[notifidict valueForKey:@"usr_id"];
//                NSURL * imageurl=[self Fb_profileImageFile:usr_id];
//               // UIImageView * profileimagv=[self videothumnilview];
////                [profileimagv sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"user"]];
//                UIImage * usrimage=[self fetchTheImage:imageurl];
//                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
//                    [self play];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessage" object:nil];
//                    [MPNotificationView notifyWithText:name
//                                                detail:content
//                                                 image:usrimage
//                                           andDuration:5.0];
            
//                }];
//                
//            }];

        }
            break;
            
            
    }
    
    
    
}

#pragma mark- play-
-(void)play
{
    
    NSURL * url=[[NSBundle mainBundle]URLForResource:@"abc" withExtension:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 1.0f;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [audioPlayer play];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(stop) userInfo:nil repeats:NO];
}

#pragma mark-stop-
-(void)stop
{
    [audioPlayer stop];
    audioPlayer=nil;
}
#pragma mark-genrateMD5String

-(NSString*)genrateMD5String
{
    //return [[NSString alloc] generateMD5:@"a8712e5a4065b3da0752242c8a602464"];
    return @"715b0d6e4bf4256d03de2cf055068412";
}
#pragma mark-
-(BOOL)checkNetwork
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        _internetActive=NO;
        NSLog(@"There IS NO internet connection");
        
        
        [[[UIAlertView alloc] initWithTitle:@"Error!!"  message:@"There is no internet connection" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        
    }
    else
    {
        _internetActive=YES;
        NSLog(@"There IS internet connection");
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    }
    return _internetActive;}
#pragma mark- Fetch Image From server-
-(UIImage *)fetchTheImage:(NSURL *)urlname
{
    NSLog(@"\n\nfetchTheImage userid=%@",urlname);
    
    
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //   NSString *documentsDirectory = [paths objectAtIndex:0];
    //   NSString *workSpacePath=[name stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:urlname]];
    
    return image;
    
}
#pragma mark- image crop Action-
-(UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSString*)createServerPath:(NSString *)requestPath
{
    return [NSString stringWithFormat:@"%@%@",KBaseUrl,requestPath];
}
//*********** All Methods of Web service *********//

#pragma mark- Text_PostDataOnserver-
-(void)postDataOnserver:(NSDictionary *)postDict withrequesturl:(NSString *)postUrl
{
    NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:postDict];
    
//    NSString *userToken =[self genrateMD5String];
//    [dict setValue:userToken forKey:@"key"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:KBaseUrl]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:postUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
         NSLog(@"JSON response: %@", response);
         [Delegate serverReponse:response withrequestName:postUrl];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [Delegate failureRsponseError:error];
     }];
}
-(void)postDataOnserverLocation:(NSDictionary *)postDict withrequesturl:(NSString *)postUrl
{
    NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:postDict];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:KBaseUrl]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:postUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
         NSLog(@"JSON response: %@", response);
         [Delegate serverReponse:response withrequestName:postUrl];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [Delegate failureRsponseError:error];
     }];

}

#pragma mark- postDatawithMediaFile-
-(void)postDatawithMediaFile:(NSDictionary *)postDict MediaFile:(NSMutableArray*)mediaarray setMediaKey:(NSString*)MediaKey  withPostUrl:(NSString *)postUrl mediaType:(NSString*)type is_multiple:(BOOL)ismultiple
{
    
    NSString *userToken =[self genrateMD5String];
    NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:postDict];
    
    
    [dict setValue:userToken forKey:@"key"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation =  [manager POST:[self createServerPath:postUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                          {
                                              
                                              
                                              if ([type isEqual:imageFile])
                                              {
                                                  
                                                  if (ismultiple==NO)
                                                  {
                                                      UIImage *img=[mediaarray objectAtIndex:0];
                                                      NSData * my_imageData=UIImagePNGRepresentation(img);
                                                      NSString * file_name=[NSString stringWithFormat:@"image_%@.png",[self mediaFileName]];
                                                      [formData appendPartWithFileData:my_imageData name:MediaKey fileName:file_name mimeType:@"image/png"];
                                                  }
                                                  else
                                                  {
                                                      
                                                      for(UIImage *img in mediaarray)
                                                      {
                                                          NSData * my_imageData=UIImagePNGRepresentation(img);
                                                          NSString * file_name=[NSString stringWithFormat:@"image_%@.png",[self mediaFileName]];
                                                          [formData appendPartWithFileData:my_imageData name:MediaKey fileName:file_name mimeType:@"image/png"];
                                                      }
                                                  }
                                                  
                                                  
                                              }
                                              else if ([type isEqual:videoFile])
                                              {
                                                  if (ismultiple==NO)
                                                  {
                                                      
                                                      NSString *videoFile=[mediaarray objectAtIndex:0];
                                                      NSString * file_name=[NSString stringWithFormat:@"video_%@.mov",[self mediaFileName]];
                                                      NSData * my_imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoFile]];
                                                      [formData appendPartWithFileData: my_imageData name:MediaKey fileName:file_name mimeType:@"video/quicktime"];
                                                  }
                                                  else
                                                  {
                                                      
                                                      for(NSString *videoFile in mediaarray)
                                                      {
                                                          NSString * file_name=[NSString stringWithFormat:@"video_%@.mov",[self mediaFileName]];
                                                          NSData * my_imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoFile]];
                                                          [formData appendPartWithFileData: my_imageData name:MediaKey fileName:file_name mimeType:@"video/quicktime"];
                                                      }
                                                      
                                                  }
                                                  
                                              }
                                              else if ([type isEqual:audioFile])
                                              {
                                                  if (ismultiple==NO)
                                                  {
                                                      NSString *videoFile=[mediaarray objectAtIndex:0];
                                                      NSString * file_name=[NSString stringWithFormat:@"audio_%@.mp3",[self mediaFileName]];
                                                      NSData * my_imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoFile]];
                                                      [formData appendPartWithFileData: my_imageData name:MediaKey fileName:file_name mimeType:@"audio/mp3"];
                                                  }
                                                  else
                                                  {
                                                      
                                                      for(NSString *videoFile in mediaarray)
                                                      {
                                                          NSString * file_name=[NSString stringWithFormat:@"audio_%@.mp3",[self mediaFileName]];
                                                          NSData * my_imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoFile]];
                                                          [formData appendPartWithFileData: my_imageData name:MediaKey fileName:file_name mimeType:@"audio/mp3"];
                                                      }
                                                  }
                                                  
                                                  
                                              }
                                              
                                              
                                              
                                              
                                          } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                          {
                                              NSLog(@"Success %@", responseObject);
                                              NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                              NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
                                              [Delegate serverReponse:response withrequestName:postUrl];
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                          {
                                              NSLog(@"Error: %@", error.description);
                                              NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
                                              
                                              
                                              // Enter what happens here if failure happens
                                              [Delegate failureRsponseError:error];
                                          }];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
         //float uploadActualPercentage = uploadPercentge * 100;
         [self reciveProgressData:uploadPercentge lable:@"uploading.."];
     }];
    
    
    [operation start];
    
}

#pragma mark-FetchDataFromServer-
-(void)FetchDatafromServer:(NSString *)UrlString withAppendString:(NSString *)appendString
{
//    NSString *userToken =[self genrateMD5String];
//    
//    //    NSDictionary * postDit=[NSDictionary dictionaryWithObjectsAndKeys:userToken,@"key", nil];
//    
//    NSString * getUrlStr;
//    if (appendString.length>0)
//    {
//        
//        getUrlStr=[NSString stringWithFormat:@"%@%@&key=%@",UrlString,appendString,userToken];
//    }
//    else
//    {
//        getUrlStr=[NSString stringWithFormat:@"%@&key=%@",UrlString,userToken];
//        // getUrlStr=[self createServerPath:UrlString];
//    }
    NSString *serverpath=[self createServerPath:UrlString];
    
    //     NSString *serverurlstr=[NSString stringWithFormat:@"%@%@",[self createServerPath:UrlString],getUrlStr];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation =  [manager GET:serverpath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        [Delegate serverReponse:response withrequestName:UrlString];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        // Enter what happens here if failure happens
        [Delegate failureRsponseError:error];
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
         //float uploadActualPercentage = uploadPercentge * 100;
         [self reciveProgressData:uploadPercentge lable:@"uploading.."];
     }];
    [operation start];
    
}

#pragma mark-downloadMediaFile-
-(void)downloadMediaFile:(NSURL*)medialpath typefile:(NSInteger)filetype success:(void (^)(NSURL* filePath))success failure:(void (^)( NSError *error))failure
{
    downloadFileType=filetype;
    downloadReqestPath=medialpath;
    // NSURL * url = [NSURL URLWithString:medialpath];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSProgress *progress;
    NSURLRequest *request = [NSURLRequest requestWithURL:medialpath];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                              } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              
                                              {
                                                  if (error!=nil)
                                                  {
                                                      failure(error);
                                                  }
                                                  else
                                                  {
                                                      success(filePath);
                                                      // [Delegate downloadFile:filePath withrequestName:downloadReqestPath];
                                                      NSLog(@"File downloaded to: %@", filePath);
                                                  }
                                                  
                                              }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         
         float progress = totalBytesRead*1.0/totalBytesExpectedToRead;
         [self reciveProgressData:progress lable:@"downloading.."];
         
         
     }];
    [downloadTask resume];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"Progress… %lld", totalBytesWritten);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

#pragma mark -###################### Download Task

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *docsDirURL;
    
    switch (downloadFileType)
    {
        case imageTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"image_%@.png",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            // NSData *imagedata=[NSData dataWithContentsOfURL:docsDirURL];
            
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
        }
            break;
        case audioTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"audio_%@.mp3",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
            
            
        }
            break;
        case videoTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"video_%@.mov",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
            
        }
            break;
        case ZipTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"outputZip_%@.zip",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
            
            
        }
            break;
        case docTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"out_%@.doc",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
            
        }
        case pdfTypeDwn:
        {
            NSString * file_name=[NSString stringWithFormat:@"out_%@.pdf",[self mediaFileName]];
            docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:file_name]];
            [Delegate downloadFile:docsDirURL withrequestName:downloadReqestPath];
            
        }
        default:
            break;
    }
    
    if ([fileManager moveItemAtURL:location
                             toURL:docsDirURL
                             error: &err])
    {
        NSLog(@"File is saved to =%@",docsDir);
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(),^ {
        [self reciveProgressData:totalBytesWritten lable:@"downloading.."];
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
}

#pragma mark-locationsearchByAddress-

-(void)locationsearchByAddress:(NSString*)address  Success:(void(^)(NSDictionary * responsedic))success failure:(void(^)(NSError *error))failure

{
    //http://maps.googleapis.com/maps/api/geocode/json?address=YOURADDRESS&sensor=tru
    //[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=tru",address]
    NSURL *URL = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
         success(response);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:op];
}


//--------------------- End Server Method-----------------

#pragma mark-imagefilename-
-(NSString*)imageFileName
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"MddyyHHmmss"];
    
    NSString *dateInStringFormated=[dateformatter stringFromDate:[NSDate date]];
    
    dateInStringFormated = [dateInStringFormated stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[self randomNumberZeroToTwo]]];
    return [NSString stringWithFormat:@"image_%@.png",dateInStringFormated] ;
}
-(NSInteger) randomNumberZeroToTwo {
    NSInteger randomNumber = (NSInteger) arc4random_uniform(3); // picks between 0 and n-1 where n is 3 in this case, so it will return a result between 0
    return randomNumber;
    
}
-(NSString*)mediaFileName
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"MddyyHHmmss"];
    
    NSString *dateInStringFormated=[dateformatter stringFromDate:[NSDate date]];
    
    dateInStringFormated = [dateInStringFormated stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[self randomNumberZeroToTwo]]];
    return [NSString stringWithFormat:@"%@",dateInStringFormated] ;
}

#pragma mark-ageFromBirthday-
- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}


#pragma mark-GetUUID-
+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
- (NSDate *)localDateStringForISODateTimeString:(NSString *) anISOString

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *date = [dateFormatter dateFromString:anISOString];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
}

-(NSURL*)Fb_profileImageFile:(NSString*)user_id
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",user_id]];
}


#pragma mark-writeDataInPlist-
-(void)writeDataInPlist:(NSDictionary*)myDict
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"appSettings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"appSettings"  ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    [myDict writeToFile:plistPath atomically: YES];
    
}
-(NSDictionary*)readDatafromPlist
{
    NSDictionary *dictRoot;
    NSString *error = nil;
	NSPropertyListFormat format;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"appSettings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: plistPath])
    {
        // Read plist from bundle and get Root Dictionary out of it
        // dictRoot = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSData *plistXML = [ [NSFileManager defaultManager] contentsAtPath: plistPath];
        dictRoot = (NSDictionary *) [NSPropertyListSerialization propertyListFromData: plistXML
                                                                     mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                                               format: &format
                                                                     errorDescription: &error];
        if (error != nil) {
            NSLog(@"Error while reading plist: %@", error);
        }
        
        
        
    }
    else
    {
        //         NSString *bundle = [[NSBundle mainBundle] pathForResource:@"appSettings"  ofType:@"plist"];
        //         dictRoot = [NSDictionary dictionaryWithContentsOfFile:bundle];
    }
    // Now a loop through Array to fetch single Item from catList which is Dictionary
    return dictRoot;
    
    
}

#pragma mark- getUTCFormateDate-
-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}

-(id)setCustomeDateFormateWithUTCTimeZone:(int)formate withtime:(id)timedate
{
    NSString * dateformate;
    switch (formate) {
        case ddmmyyyy:
            dateformate=@"dd-MM-yyyy";
            break;
        case yyyymmdd:
            dateformate=@"yyyy-MM-dd";
            break;
        case EEEddMMMyyyy:
            dateformate=@"EEE, dd MMM yyyy";
            break;
            case ddmmyyyyHHmmSS:
             dateformate=@"dd-MM-yyyy HH:mm:ss";
            break;
            case yyyymmddHHmmSS:
             dateformate=@"yyyy-MM-dd HH:mm:ss";
            break;
            case EEEddMMMyyyyHHmmSS:
             dateformate=@"EEE, dd MMM yyyy HH:mm:ss";
            break;
        case hhmmss:
            dateformate=@"HH:mm:ss";
            break;
            
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateformate];
    if ([timedate isKindOfClass:[NSDate class]])
    {
        NSString *dateString = [dateFormatter stringFromDate:(NSDate*)timedate];
        
        return dateString;
    }
    else
    {
        NSDate *date = [dateFormatter dateFromString:(NSString*)timedate];
      //  return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
        return date;
    }
}

-(NSDate *)dateFromDouble:(double)interval
{
    return [NSDate dateWithTimeIntervalSince1970: interval];
}

-(NSDate*)dateTimeInterval:(NSTimeInterval)secsToBeAdded setFormate:(int)formate sinceDate:(NSDate *)date
{
    NSString * dateformate;
    switch (formate) {
        case ddmmyyyy:
            dateformate=@"dd-MM-yyyy";
            break;
        case yyyymmdd:
            dateformate=@"yyyy-MM-dd";
            break;
        case EEEddMMMyyyy:
            dateformate=@"EEE, dd MMM yyyy";
            break;
        case ddmmyyyyHHmmSS:
            dateformate=@"dd-MM-yyyy HH:mm:ss";
            break;
        case yyyymmddHHmmSS:
            dateformate=@"yyyy-MM-dd HH:mm:ss";
            break;
        case EEEddMMMyyyyHHmmSS:
            dateformate=@"EEE, dd MMM yyyy HH:mm:ss";
            break;
        case hhmmss:
            dateformate=@"HH:mm:ss";
            break;
            
        default:
            break;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateformate];
     return [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secsToBeAdded sinceDate:date]]];
    //return [NSDate dateWithTimeInterval:secsToBeAdded sinceDate:date];
}
-(CGSize)gettextsize:(NSString*)text font:(UIFont*)textfont constrainedToSize:(CGSize)constrainedsize
{
    // CGSize textViewSize;
    
    
    //#ifdef __IPHONE_7_0
    //
    //
    //    CGRect textRect = [text boundingRectWithSize:constrainedsize
    //                                         options:NSStringDrawingUsesLineFragmentOrigin
    //                                      attributes:@{NSFontAttributeName:textfont}
    //                                         context:nil];
    //
    //    textViewSize = textRect.size;
    //
    //
    //#else
    //
    //   textViewSize = [text sizeWithFont:textfont constrainedToSize:constrainedsize lineBreakMode:NSLineBreakByTruncatingTail];
    //#endif
    
    CGRect stringRect = [text  boundingRectWithSize:CGSizeMake(1000, CGFLOAT_MAX)
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:@{ NSFontAttributeName :textfont }
                                              context:nil];
//    CGSize textViewSize = [text sizeWithFont:textfont constrainedToSize:constrainedsize lineBreakMode:NSLineBreakByTruncatingTail];
    
    
    
    
    return stringRect.size;
}





-(NSString*)jsonRepresentForm:(id)object
{
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:object options:NSJSONReadingMutableLeaves error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(id)jsonArrayFromjsonstring:(NSString*)object
{
    if (object.length!=0&&![object isEqual:@"()"])
    {
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        return [NSJSONSerialization JSONObjectWithData:jsonData2 options:kNilOptions error:nil];
    }
    else
    {
        return nil ;
    }
    //NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData2 options:kNilOptions error:nil];
    
}


-(UIImage*)chatAvstarImage:(NSURL*)imageurl
{
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        
        // Background work
        NSData *imagedata=[NSData dataWithContentsOfURL:imageurl];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // Main thread work (UI usually)
            if (imagedata!=nil)
            {
                
                
                thumbImg=[UIImage imageWithData:imagedata];
            }
        }];
    }];
    
    return thumbImg;
    
}
#pragma mark-genrateThumbnil-
-(void)genrateThumbnil:(NSURL*)filepath  thumbnilSize:(CGSize)maxSize success:(void (^)(UIImage* thumbnil))success failure:(void (^)( NSError *error))failure

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:filepath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.maximumSize = maxSize;
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 30);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    if (thumb!=nil) {
        success(thumb);
    }
    else
    {
        failure(error);
    }
    CGImageRelease(image);
    
    /*
     //This is what you will load lazily
     AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:filepath options:nil];
     AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
     generator.appliesPreferredTrackTransform=TRUE;
     
     CMTime thumbTime = CMTimeMakeWithSeconds(1,60);
     
     AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
     {
     if (error!=nil)
     {
     failure(error);
     
     }
     else
     {
     if (result != AVAssetImageGeneratorSucceeded)
     {
     
     NSLog(@"couldn't generate thumbnail, error:%@", error);
     }
     // TODO Do something with the image
     else
     
     
     success([UIImage imageWithCGImage:im]);
     }
     };
     
     
     generator.maximumSize = maxSize;
     [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
     
     */
    
    
}
#pragma mark-getVideoPath_name-
-(NSString*)getVideoPath_name:(NSString*)filename;
{
    
    NSString* videoPath =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Videos.bundle/%@",filename] ofType:@"mp4"];
    
    
    NSLog(@"%@",videoPath);
    
    
    return videoPath;
}

-(void)getImageFromServerPath:(NSURL *)imageURL completed:(ServerManagerDownloadImageCompletionWithFinishedBlock)completedBlock
{
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         
         if (error!=nil)
         {
             [[ServerManager getSharedInstance]hideHud];
             [ServerManager showAlertView:@"Error!!" withmessage:error.localizedDescription];
         }
         else
         {
             if (finished==YES)
             {
                 if (image)
                 {
                     
                     completedBlock(image,YES);
                 }
             }
         }
         
         
     }];
}
-(void)customFontFamilyname:(NSInteger)customFontTag fontSize:(CGFloat)fontSize  success:(void (^)(UIFont* font))success
{
    
    UIFont * customfont;
    switch (customFontTag)
    {
        case OpenSansBold:
        {
            customfont=[UIFont fontWithName:@"OpenSans-Bold" size:fontSize];
        }
            break;
        case OpenSansBoldItalic:
        {
            customfont=[UIFont fontWithName:@"OpenSans-BoldItalic" size:fontSize];
        }
            break;
        case OpenSansCondBold:
        {
            customfont=[UIFont fontWithName:@"OpenSans-CondBold_0" size:fontSize];
        }
            break;
        case OpenSansCondLight:
        {
            customfont=[UIFont fontWithName:@"OpenSans-CondLight_0" size:fontSize];
        }
            break;
        case OpenSansCondLightItalic:
        {
            customfont=[UIFont fontWithName:@"OpenSans-CondLightItalic_0" size:fontSize];
        }
            break;
        case OpenSansItalic:
        {
            
            customfont=[UIFont fontWithName:@"OpenSans-Italic" size:fontSize];
        }
            break;
        case OpenSansLight:
        {
            
            customfont=[UIFont fontWithName:@"OpenSans-Light" size:fontSize];
        }
            break;
        case OpenSansLightItalic:
        {
            customfont=[UIFont fontWithName:@"OpenSans-LightItalic" size:fontSize];
        }
            break;
        case OpenSansRegular:
        {
            customfont=[UIFont fontWithName:@"OpenSans-Regular" size:fontSize];
        }
            break;
        case OpenSansSemibold:
        {
            customfont=[UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
        }
            break;
        case OpenSansSemiboldItalic:
        {
            customfont=[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:fontSize];
        }
            break;
        default:
            customfont=[UIFont fontWithName:@"OpenSans-Regular" size:fontSize];
            
            break;
    }
    
    success(customfont);
}


-(UIImageView*)videothumnilview
{
    return [[UIImageView alloc]init];
}

#ifdef __IPHONE_8_0
-(void)UIVisualEffect:(UIVisualEffectView*)VisualControl
{
    
    
    CAShapeLayer *ovalLayer = [CAShapeLayer layer];
    
    CGMutablePathRef ovalPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(ovalPath, NULL, VisualControl.bounds);
    CGPathCloseSubpath(ovalPath);
    
    ovalLayer.path = ovalPath;
    // Configure the apperence of the circle
    // ovalLayer.fillColor = [UIColor clearColor].CGColor;
    ovalLayer.strokeColor = [UIColor whiteColor].CGColor;
    ovalLayer.lineWidth = 0.4;
    //ovalLayer.masksToBounds=YES;
    // Add to parent layer
    VisualControl.layer.mask = ovalLayer;
}
#endif

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
+(void)changeTextColorOfSearchBarButton:(UIColor*)color
{
   
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],NSShadowAttributeName,nil] forState:UIControlStateNormal];
}

@end
