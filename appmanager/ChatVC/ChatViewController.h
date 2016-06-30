//
//  ViewController.h
//  ChatMessageTableViewController
//
//  Created by Yongchao on 21/11/13.
//  Copyright (c) 2013 Yongchao. All rights reserved.
//

#import "JSQMessages.h"
#import "ServerManager.h"
#import "AsyncImageView.h"

@class JKModelData;
@interface ChatViewController : JSQMessagesViewController<ServerManagerDelegate,PopoverViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,JSQMessagesCollectionViewCellDelegate,JSQMessagesCollectionViewDataSource,JSQMessagesCollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    
    UIImagePickerController * imagePicker;
    NSString * fileType;
    UIImage * pickedImage;
    IBOutlet UIToolbar *menuToolbar;
    BOOL viewHide;
    PopoverView * attachmentPopView;
    NSURL * incomeimage_file;
    NSURL * Outgoingimage_file;
    
    UIImage *outgoingimage;
    UIImage *incomingimage;
    NSMutableArray *Get_chat_array;
    
    NSTimer *timerRecive;
    IBOutlet UIView *headerView;
    
     PopoverView *menuPopview;
    
    IBOutlet UIView *menuContentView;
    IBOutlet UITableView *MenuTable;

    
    
}
@property(strong,nonatomic)NSDictionary * selectFreindInfoDict;
@property (strong, nonatomic) JKModelData *jkmodelData;


@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property(strong,nonatomic)NSString *friendId;
@property(strong,nonatomic)NSString *toUserId;



- (IBAction)ClickOnToolBarButtons:(id)sender;
- (IBAction)OnCancel:(id)sender;


@end
