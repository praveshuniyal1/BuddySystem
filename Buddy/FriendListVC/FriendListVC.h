//
//  FriendListVC.h
//  BuddySystem
//
//  Created by Jitendra on 14/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
#import "ServerManager.h"
#import "JKModelData.h"
@interface FriendListVC : UIViewController<ServerManagerDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>
{
    IBOutlet UIView *topbarView;
    
    IBOutlet UITableView * contactTable;
    IBOutlet UISearchBar *searchtext;
    NSMutableArray * searchResults;
    NSIndexPath *didindexPath;
    NSMutableArray * contactList;
    NSString * usrId;
    NSString * name;
    
}
@property(strong,nonatomic)UIRefreshControl*refreshControl;
- (IBAction)OnBack:(id)sender;
@end