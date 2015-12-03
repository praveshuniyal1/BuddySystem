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
@interface ChatViewController : JSQMessagesViewController<ServerManagerDelegate,PopoverViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,JSQMessagesCollectionViewCellDelegate,JSQMessagesCollectionViewDataSource,JSQMessagesCollectionViewDelegateFlowLayout>
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
}
@property(strong,nonatomic)NSDictionary * selectFreindInfoDict;
@property (strong, nonatomic) JKModelData *jkmodelData;

- (IBAction)ClickOnToolBarButtons:(id)sender;
- (IBAction)OnCancel:(id)sender;


@end
