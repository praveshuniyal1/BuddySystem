//
//  LocationSearchVC.h
//  BuddySystem
//
//  Created by Jitendra on 20/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClassManager.h"
//@class LocationSearchVC;
#import "DBManagerDelegate.h"
//@protocol LocationSearchDelegate <NSObject>
//
//-(void)locationView:(LocationSearchVC*)locationView didselectlocation:(NSDictionary*)locationdict;
//
//
//@end
@interface LocationSearchVC : UITableViewController
{
    
    IBOutlet UISearchBar *searchText;
    NSMutableArray * resultList;
}

//@property(strong,nonatomic)id<LocationSearchDelegate>Delegate;
- (IBAction)OnDone:(id)sender;

@end
