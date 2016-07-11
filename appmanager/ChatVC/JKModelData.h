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
#import <CoreLocation/CoreLocation.h>
#import "JKClassManager.h"
#import "JSQMessages.h"

/**
 *  This is for demo/testing purposes only. 
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */




@interface JKModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *MessagesIds;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;
@property (strong, nonatomic) NSString * kJSQSenderDisplayName ;
@property (strong, nonatomic) NSString * kJSQSenderId ;
@property (strong, nonatomic) NSString * kJSQReciverDisplayName ;
@property (strong, nonatomic) NSString * kJSQReciverId ;
@property (strong, nonatomic) UIImage * kJSQSenderAvatarImage ;
@property (strong, nonatomic) UIImage * kJSQReciverAvatarImage ;



+(JKModelData*)getSharedInstance;



- (void)setSenderid:(NSString *)senderid senderDisplayname:(NSString *)senderdidplayname senderimage:(UIImage*)sendimage receiverId:(NSString *)reciverid reciverDisplayname:(NSString *)reciverdisplayname reciverImage:(UIImage*)reciverimage;
-(void)insertChatConversesion:(NSDictionary*)chatDict;
-(void)readAllChatMessage;
-(NSMutableArray*)fetchMsgIds;
-(NSMutableArray*)readAllChat;
- (JSQMessage*)addTextMessage:(NSString*)txtMsg sendeId:(NSString*)senderid;
- (JSQMessage*)addPhotoMediaMessage:(UIImage*)image sendeId:(NSString*)senderid;
-(JSQMessage*)addlocationMediaMessageLat:(CLLocationDegrees)lat longi:(CLLocationDegrees)longit sendeid:(NSString*)senderId Completion :(JSQLocationMediaItemCompletionBlock)completion;
- (JSQMessage*)addVideoMediaMessage:(NSURL*)videoUrl sendeid:(NSString*)senderId;
-(void)updatemsgtablelastmessge:(NSInteger)messgeId;
-(void)deleteMessageOfSelectUser:(NSString*)selectuser;
@end
