//
//  SCFacebook.m
//  SCFacebook
//
//  Created by Lucas Correa on 23/11/11.
//  Copyright (c) 2014 Siriuscode Solutions. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SCFacebook.h"


@interface SCFacebook()

+ (SCFacebook *)shared;

@end



@implementation SCFacebook


#pragma mark -
#pragma mark - Singleton

+ (SCFacebook *)shared
{
    static SCFacebook *scFacebook = nil;
    
    @synchronized (self){
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            scFacebook = [[SCFacebook alloc] init];
        });
    }
    
    return scFacebook;
}




#pragma mark -
#pragma mark - Private Methods

- (void)initWithPermissions:(NSArray *)permissions
{
    self.permissions = permissions;
}

- (BOOL)isSessionValid
{
    if (!FBSession.activeSession.isOpen){
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                FBSession.activeSession = session;
            }];
        }
    }
    
    return FBSession.activeSession.isOpen;
}

- (void)loginCallBack:(SCFacebookCallback)callBack
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:self.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             
             
             if (error)
             {
                 //        //NSLog(@"Error");
                 NSString *alertText;
                 NSString *alertTitle;
                 // If the error requires people using an app to make an action outside of the app in order to recover
                 if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
                     alertTitle = @"Something went wrong";
                     alertText = [FBErrorUtility userMessageForError:error];
                     
                 } else {
                     
                     // If the user cancelled login, do nothing
                     if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                         //                //NSLog(@"User cancelled login");
                         
                         // Handle session closures that happen outside of the app
                     } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                         alertTitle = @"Session Error";
                         alertText = @"Your current session is no longer valid. Please log in again.";
                         
                         
                         // Here we will handle all other errors with a generic error message.
                         // We recommend you check our Handling Errors guide for more information
                         // https://developers.facebook.com/docs/ios/errors/
                     } else {
                         //Get more error information from the error
                         NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                         
                         // Show the user an error message
                         alertTitle = @"Something went wrong";
                         alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                     }
                 }
                 // Clear this token
                 [FBSession.activeSession closeAndClearTokenInformation];
                 // Show the user the logged-out UI
                 callBack(NO, alertText);
                 
             }
             else
             {
                 
                 
                 if (status == FBSessionStateOpen)
                 {
                     
                     FBRequest *fbRequest = [FBRequest requestForMe];
                     [fbRequest setSession:session];
                     
                     [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
                      {
                          if (!error)
                          {
                              NSMutableDictionary *userInfo = nil;
                              if( [result isKindOfClass:[NSDictionary class]] )
                              {
                                  userInfo = (NSMutableDictionary *)result;
                                  if( [userInfo count] > 0 )
                                  {
                                      [userInfo setObject:session.accessTokenData.accessToken forKey:@"accessToken"];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:session.accessTokenData.accessToken forKey:@"accessToken"];
                                      
                                  }
                              }
                              if(callBack)
                              {
                                  
                                  callBack(!error, userInfo);
                                  
                              }
                          }
                          else
                          {
                              callBack(NO, error);
                             
                              
                          }
                          
                      }];
                 }
                 else if(status == FBSessionStateClosedLoginFailed||status==FBSessionStateClosed)
                 {
                     
                     if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogout"]==YES)
                     {
                         [[[UIAlertView alloc]initWithTitle:@"Log Out Complete" message:@"Press the login with facebook button to continue" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                     }
                     else{
                         [[[UIAlertView alloc]initWithTitle:@"Deletion Complete" message:@"You have successfully deleted your account. You can login with Facebook to create a new account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                     }
  
                     
//                     callBack(NO, @"Successully L");
                 }
             }
         }];
        
        
    }
}

- (void)logoutCallBack:(SCFacebookCallback)callBack
{
    if (FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        
    }
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *allCookies = [cookies cookies];
    
    for(NSHTTPCookie *cookie in allCookies) {
        if([[cookie domain] rangeOfString:@"facebook.com"].location != NSNotFound)
        {
            [cookies deleteCookie:cookie];
        }
    }
    
   
//    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://m.facebook.com/"]];
//    
//    for (NSHTTPCookie* cookie in facebookCookies) {
//        [cookies deleteCookie:cookie];
//    }
    
    
    callBack(YES, @"Logout successfully");
}

- (void)getUserFields:(NSString *)fields callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me" params:@{@"fields" : fields} callBack:callBack];
}
-(void)getFreindInfoFields:(NSString *)fields friendId:(NSString*)friendId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:friendId params:@{@"fields" : fields} callBack:callBack];
}


- (void)getUserFriendsCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        callBack(!error, result[@"data"]);
    }];
}

- (void)feedPostWithLinkPath:(NSString *)url caption:(NSString *)caption message:(NSString *)message photo:(UIImage *)photo video:(NSData *)videoData callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //Need to provide POST parameters to the Facebook SDK for the specific post type
    NSString *graphPath = @"me/feed";
    
    switch (self.postType) {
        case FBPostTypeLink:
        {
            [params setObject:url forKey:@"link"];
            [params setObject:caption forKey:@"description"];
            break;
        }
        case FBPostTypeStatus:
        {
            [params setObject:message forKey:@"message"];
            break;
        }
        case FBPostTypePhoto:
        {
            graphPath = @"me/photos";
            [params setObject:UIImagePNGRepresentation(photo) forKey:@"source"];
            [params setObject:caption forKey:@"message"];
            break;
        }
        case FBPostTypeVideo:
        {
            graphPath = @"me/videos";
            [params setObject:videoData forKey:@"video.mp4"];
            [params setObject:caption forKey:@"title"];
            [params setObject:message forKey:@"description"];
            break;
        }
            
        default:
            break;
    }
    
    [self graphFacebookForMethodPOST:graphPath params:params callBack:callBack];
}

- (void)myFeedCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodPOST:@"me/feed" params:nil callBack:callBack];
}

- (void)inviteFriendsWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:message
                                                    title:nil
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Error launching the dialog or sending the request.
                                                          callBack(NO, @"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User clicked the "x" icon
                                                              callBack(NO, @"User canceled request.");
                                                          } else {
                                                              callBack(YES, @"Send invite");
                                                          }
                                                      }
                                                  }];
}
-(void)postFeedOnFriendsWall:(NSDictionary*)parameters callBackSuccess:(void(^) (BOOL sucess, NSString * message))success failure:(void(^)(NSError  *error ))failure

{
    if (![self isSessionValid])
    {
        return;
    }
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:parameters handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
     {
         if (error==nil)
         {
             
             // Case A: Error launching the dialog or sending request.
             // //NSLog(@"Error sending request.");
             switch (result)
             {
                 case FBWebDialogResultDialogCompleted:
                 {
                     success(YES,@"Message sucessfully send.");
                 }
                     break;
                     
                 default:
                    success(YES,@"User canceled request.");
                     break;
             }
             
         } else
         {
             failure(error);
             
         }
     }];

}
-(void)inviteFriendsWithMessage:(NSString *)message subject:(NSString*)title SpecficUsers:(NSDictionary*)parameters callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:message
                                                    title:title
                                               parameters:parameters
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Error launching the dialog or sending the request.
                                                          callBack(NO, @"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User clicked the "x" icon
                                                              callBack(NO, @"User canceled request.");
                                                          } else {
                                                              callBack(YES, @"Send invite");
                                                          }
                                                      }
                                                  }];
}

- (void)getPagesCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me/accounts" params:nil callBack:callBack];
}

- (void)getPageById:(NSString *)pageId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!pageId) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodGET:pageId params:nil callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/feed", page] params:@{@"message": message} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/photos", page] params:@{@"message": message, @"source" : UIImagePNGRepresentation(photo)} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/feed", page] params:@{@"message": message, @"link" : url} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/videos", page]
                                    params:@{@"title" : title,
                                             @"description" : description,
                                             @"video.mp4" : videoData} callBack:callBack];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [SCFacebook getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/feed",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message, @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [SCFacebook getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/videos",dicPageAdmin[@"id"]]
                                                               parameters:@{@"title" : title,
                                                                            @"description" : description,
                                                                            @"video.mp4" : videoData,
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [SCFacebook getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/feed",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message,
                                                                            @"link" : url,
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [SCFacebook getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/photos",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message,
                                                                            @"source" : UIImagePNGRepresentation(photo),
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)getAlbumsCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me/albums" params:nil callBack:callBack];
}
-(void)getfreindAlbums:(NSString*)friendId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    NSString * serverpath=[NSString stringWithFormat:@"%@/albums",friendId];
    [self graphFacebookForMethodGET:serverpath params:nil callBack:callBack];
}
- (void)getAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodGET:albumId params:nil callBack:callBack];
}

- (void)getPhotosAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodGET:[NSString stringWithFormat:@"%@/photos", albumId] params:nil callBack:callBack];
}

- (void)createAlbumName:(NSString *)name message:(NSString *)message privacy:(FBAlbumPrivacyType)privacy callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!name && !message) {
        callBack(NO, @"Name and message required");
        return;
    }
    
    NSString *privacyString = @"";
    
    switch (privacy) {
        case FBAlbumPrivacyEveryone:
            privacyString = @"EVERYONE";
            break;
        case FBAlbumPrivacyAllFriends:
            privacyString = @"ALL_FRIENDS";
            break;
        case FBAlbumPrivacyFriendsOfFriends:
            privacyString = @"FRIENDS_OF_FRIENDS";
            break;
        case FBAlbumPrivacySelf:
            privacyString = @"SELF";
            break;
        default:
            break;
    }
    
    [SCFacebook graphFacebookForMethodPOST:@"me/albums" params:@{@"name" : name,
                                                                 @"message" : message,
                                                                 @"value" : privacyString} callBack:callBack];
}

- (void)feedPostForAlbumId:(NSString *)albumId photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [SCFacebook graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/photos", albumId] params:@{@"source": UIImagePNGRepresentation(photo)} callBack:callBack];
}

- (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    // Post custom object
    [FBRequestConnection startForPostOpenGraphObject:openGraphObject completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // get the object ID for the Open Graph object that is now stored in the Object API
            NSString *objectId = [result objectForKey:@"id"];
            
            // create an Open Graph action
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:objectId forKey:objectName];
            
            // create action referencing user owned object
            [FBRequestConnection startForPostWithGraphPath:path graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(error) {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                    callBack(NO, [NSString stringWithFormat:@"Encountered an error posting to Open Graph: %@", error.description]);
                } else {
                    callBack(YES, [NSString stringWithFormat:@"OG story posted, story id: %@", result[@"id"]]);
                }
            }];
            
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            callBack(NO, [NSString stringWithFormat:@"Encountered an error posting to Open Graph: %@", error.description]);
        }
    }];
}

- (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName withImage:(UIImage *)image callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    // stage an image
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // for og:image we assign the uri of the image that we just staged
            //            object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            
            openGraphObject.image = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            
            [self sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName callBack:callBack];
        }
    }];
}

- (void)graphFacebookForMethodPOST:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [FBRequestConnection startWithGraphPath:method parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            callBack(NO, error);
        } else {
            NSLog(@"%@", result);
            callBack(YES, result);
        }
    }];
}

- (void)graphFacebookForMethodGET:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [FBRequestConnection startWithGraphPath:method parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            callBack(NO, error);
        } else {
            NSLog(@"%@", result);
            callBack(YES, result);
        }
    }];
}
#pragma mark -
#pragma mark - Public Methods

+ (void)initWithPermissions:(NSArray *)permissions
{
    [[SCFacebook shared] initWithPermissions:permissions];
}

+(BOOL)isSessionValid
{
    return [[SCFacebook shared] isSessionValid];
}

+ (void)loginCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] loginCallBack:callBack];
}


+ (void)logoutCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] logoutCallBack:callBack];
}

+ (void)getUserFields:(NSString *)fields callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getUserFields:fields callBack:callBack];
}
+ (void)getFreindInfoFields:(NSString *)fields friendId:(NSString*)friendId callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared]getFreindInfoFields:fields friendId:friendId callBack:callBack];
}
+ (void)getUserFriendsCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getUserFriendsCallBack:callBack];
}

+ (void)feedPostWithLinkPath:(NSString *)url caption:(NSString *)caption callBack:(SCFacebookCallback)callBack
{
    [SCFacebook shared].postType = FBPostTypeLink;
    [[SCFacebook shared] feedPostWithLinkPath:url caption:caption message:nil photo:nil video:nil callBack:callBack];
}

+ (void)feedPostWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [SCFacebook shared].postType = FBPostTypeStatus;
    [[SCFacebook shared] feedPostWithLinkPath:nil caption:nil message:message photo:nil video:nil callBack:callBack];
}

+ (void)feedPostWithPhoto:(UIImage *)photo caption:(NSString *)caption callBack:(SCFacebookCallback)callBack
{
    [SCFacebook shared].postType = FBPostTypePhoto;
    [[SCFacebook shared] feedPostWithLinkPath:nil caption:caption message:nil photo:photo video:nil callBack:callBack];
}

+ (void)feedPostWithVideo:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [SCFacebook shared].postType = FBPostTypeVideo;
    [[SCFacebook shared] feedPostWithLinkPath:nil caption:title message:description photo:nil video:videoData callBack:callBack];
}

+ (void)myFeedCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] myFeedCallBack:callBack];
}

+ (void)inviteFriendsWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] inviteFriendsWithMessage:message callBack:callBack];
}
+(void)postFeedOnFriendsWall:(NSDictionary*)parameters callBackSuccess:(void(^) (BOOL sucess, NSString * message))success failure:(void(^)(NSError  *error ))failure
{
    [[SCFacebook shared] postFeedOnFriendsWall:parameters callBackSuccess:^(BOOL sucess, NSString *message)
    {
        success(sucess,message);
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
+ (void)getPagesCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getPagesCallBack:callBack];
}

+ (void)getPageById:(NSString *)pageId callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getPageById:pageId callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostForPage:page message:message callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostForPage:page message:message photo:photo callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostForPage:page message:message link:url callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostForPage:page video:videoData title:title description:description callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostAdminForPageName:page message:message callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostAdminForPageName:page video:videoData title:title description:description callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostAdminForPageName:page message:message link:url callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostAdminForPageName:page message:message photo:photo callBack:callBack];
}

+ (void)getAlbumsCallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getAlbumsCallBack:callBack];
}
+ (void)getfreindAlbums:(NSString *)albumId CallBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared]getfreindAlbums:albumId callBack:callBack];
}
+ (void)getAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getAlbumById:albumId callBack:callBack];
}

+ (void)getPhotosAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] getPhotosAlbumById:albumId callBack:callBack];
}

+ (void)createAlbumName:(NSString *)name message:(NSString *)message privacy:(FBAlbumPrivacyType)privacy callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] createAlbumName:name message:message privacy:privacy callBack:callBack];
}

+ (void)feedPostForAlbumId:(NSString *)albumId photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] feedPostForAlbumId:albumId photo:photo callBack:callBack];
}

+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName callBack:callBack];
}

+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName withImage:(UIImage *)image callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName withImage:image callBack:callBack];
}

+ (void)graphFacebookForMethodGET:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] graphFacebookForMethodGET:method params:params callBack:callBack];
}

+ (void)graphFacebookForMethodPOST:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [[SCFacebook shared] graphFacebookForMethodPOST:method params:params callBack:callBack];
}


@end
