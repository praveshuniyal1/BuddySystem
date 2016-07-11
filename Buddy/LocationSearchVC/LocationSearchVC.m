//
//  LocationSearchVC.m
//  BuddySystem
//
//  Created by Jitendra on 20/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "LocationSearchVC.h"

@interface LocationSearchVC ()

@end

@implementation LocationSearchVC
//@synthesize Delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    resultList=[NSMutableArray new];
    searchText.placeholder=@"Search for a city";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIColor * color=[ServerManager colorWithR:242 G:92 B:80 A:1];
    [ServerManager changeTextColorOfSearchBarButton:color];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  //
    [self loadCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCity
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
       
        CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
        if (loctCoord.longitude!=0&&loctCoord.latitude!=0)
        {
             [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.navigationController.view];
        
        NSString * lat=[NSString stringWithFormat:@"%f",loctCoord.latitude];
        NSString * lon=[NSString stringWithFormat:@"%f",loctCoord.longitude];
        NSString * add=[NSString stringWithFormat:@"%@,%@",lat,lon];
        NSString * searchpath=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&sensor=true",add];
    http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true
        
        [[ServerManager getSharedInstance]locationsearchByAddress:searchpath
                                                          Success:^(NSDictionary *responsedic)
         {
             if (responsedic!=nil)
             {
                 //NSLog(@"%@",responsedic);
                 
                 if (resultList.count>0)
                 {
                     [resultList removeAllObjects];
                 }
                 NSMutableArray * locarr=[NSMutableArray arrayWithArray:[responsedic valueForKey:@"results"]];
                 
                 for (int jk=0; jk<[locarr count]; jk++)
                 {
                     NSString * address=[[locarr objectAtIndex:jk]valueForKey:@"formatted_address"];
                     
                     NSDictionary * geometrydict=[[locarr objectAtIndex:jk]valueForKey:@"geometry"];
                     NSDictionary * locationdct=[geometrydict valueForKey:@"location"];
                     double lat=[[locationdct  valueForKey:@"lat"] doubleValue];
                     double lng=[[locationdct  valueForKey:@"lng"] doubleValue];
                     
                     NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:address,@"address",[NSNumber numberWithDouble:lat],@"latitute",[NSNumber numberWithDouble:lng],@"longitute", nil];
                     [resultList addObject:dict];
                     
                 }
                 if (resultList.count>0)
                 {
                     [self.tableView reloadData];
                     [[ServerManager getSharedInstance]hideHud];
                 }
                 
             }
             
             
         }
                                                          failure:^(NSError *error)
         {
             [[ServerManager getSharedInstance]hideHud];
             [ServerManager showAlertView:@"Error!!" withmessage:error.localizedDescription];
         }];
        }
    }
   
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return resultList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell loadLocationSearchData:[resultList objectAtIndex:indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
      //  [Delegate locationView:self didselectlocation:[resultList objectAtIndex:indexPath.row]];
        
    }];
}

#pragma mark- UIserView's Delegate methods-
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *searchWordProtection = [searchText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Length: %lu",(unsigned long)searchWordProtection.length);
    if (searchWordProtection.length != 0) {
        
         [self searchFor:searchWordProtection];
        
    } else {
        NSLog(@"The searcTextField is empty.");
    }
   
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *searchWordProtection = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Length: %lu",(unsigned long)searchWordProtection.length);
    if (searchWordProtection.length != 0)
    {
        
        [self searchFor:searchWordProtection];
        
    } else {
        NSLog(@"The searcTextField is empty.");
    }

}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchText resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[self searchFor:searchBar.text];
}
- (void)searchFor:(NSString *)searchTerm
{
    
    if (searchText.text.length>0)
    {
        BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
        if (is_net==YES)
        {
        NSString * searchpath=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",[searchTerm lowercaseString]];
        [[ServerManager getSharedInstance]locationsearchByAddress:searchpath
         Success:^(NSDictionary *responsedic)
         {
             if (responsedic!=nil)
             {
                 //NSLog(@"%@",responsedic);
                 
                 if (resultList.count>0)
                 {
                     [resultList removeAllObjects];
                 }
                 NSMutableArray * locarr=[NSMutableArray arrayWithArray:[responsedic valueForKey:@"results"]];
                 
                 for (int jk=0; jk<[locarr count]; jk++)
                 {
                     NSString * address=[[locarr objectAtIndex:jk]valueForKey:@"formatted_address"];
                     
                     NSDictionary * geometrydict=[[locarr objectAtIndex:jk]valueForKey:@"geometry"];
                      NSDictionary * locationdct=[geometrydict valueForKey:@"location"];
                     double lat=[[locationdct  valueForKey:@"lat"] doubleValue];
                     double lng=[[locationdct  valueForKey:@"lng"] doubleValue];
                     
                     NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:address,@"address",[NSNumber numberWithDouble:lat],@"latitute",[NSNumber numberWithDouble:lng],@"longitute", nil];
                     [resultList addObject:dict];
                    
                 }
                 if (resultList.count>0)
                 {
                     [self.tableView reloadData];
                 }

             }
             
             
         }
        failure:^(NSError *error)
         {
             [ServerManager showAlertView:@"Error!!" withmessage:error.localizedDescription];
        }];
        }
    }
}

#pragma mark-
- (IBAction)OnDone:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
