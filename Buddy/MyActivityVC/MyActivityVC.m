//
//  MyActivityVC.m
//  BuddySystem
//
//  Created by Jitendra on 06/02/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "MyActivityVC.h"

@interface MyActivityVC ()

@end

@implementation MyActivityVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [KappDelgate edgesForExtendedLayout:self];
    activityList=[NSMutableArray new];
   // [self bgplayer];
  
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
    [self suggestActivityList];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self bgplayer];
}

-(void)bgplayer
{
    // Background work
    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[[ServerManager getSharedInstance]getVideoPath_name:@"myActivitiesBackground"]]];
        [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
}


-(void)suggestActivityList
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    if (is_net==YES)
    {
        [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.view];
        NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
        NSString* usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
       
        [ServerManager getSharedInstance].Delegate=self;
        NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id", nil];
        [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:kMyActivity];
    }
}


- (IBAction)OnBack:(id)sender
{
    [KappDelgate popToCurrentViewController:self];
}

- (IBAction)OnChat:(id)sender
{
    [KappDelgate pushViewController:self NibIdentifier:@"FriendListVC"];
}

- (IBAction)TappedOnSuggest:(id)sender
{
    
    [JKAlertView setplaceholderText:@"activity.."];
    [JKAlertView showAlertSingleInputWithMessage:@"Type any activity you like & it's cool. we'll add it soon." title:@"Suggest Activity" style:UIAlertViewStylePlainTextInput cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Submit"] ComplitionHandlerSingleInputViewBlock:^(UIAlertView *alertView, NSString *Username, NSInteger buttonIndex)
    {
        
        switch (buttonIndex) {
            case 1:
            {
                BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
                if (is_net==YES)
                {
                    [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.view];
                    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
                    NSString* usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
                    NSString* name=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"name"]];
                    NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:usrId,@"usr_id",name,@"usr_name",Username,@"suggest_activity", nil];
                    [ServerManager getSharedInstance].Delegate=self;
                    [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:ksuggestActivity];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (IBAction)TappedOnMenu:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
}


#pragma mark - Data Source Method Of Collection View-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [activityList count];
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//     NSString * activity=[[activityList objectAtIndex:indexPath.item] valueForKey:@"activity"];
//    CGSize descpSize= [[ServerManager getSharedInstance]gettextsize:activity font:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(60, 1000)];
//    
//    CGRect rect=CGRectMake(60+descpSize.width+5, 3, 30, 30);
    
//    self.frame=CGRectMake(rect.origin.x, rect.origin.y, btnDelete.frame.size.width+lbl_title.frame.size.width+5, self.frame.size.height);
    
    return CGSizeMake(100, 40);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}



// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 return UIEdgeInsetsMake(5,5,0,0);  // top, left, bottom, right
//    return UIEdgeInsetsMake(17,20,4,20);  // top, left, bottom, right
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    
    CategoryCell *playingCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [playingCardCell loadSuggestActivityData:[activityList objectAtIndex:indexPath.row]];
    
    playingCardCell.btnDelete.tag=100+indexPath.row;
    [playingCardCell.btnDelete addTarget:self action:@selector(TappedOnDelete:) forControlEvents:UIControlEventTouchUpInside];
    return playingCardCell;
}

-(void)TappedOnDelete:(UIButton*)delete
{
    int ind=(int)delete.tag-100;
       suggestActivityid=[[activityList objectAtIndex:ind] valueForKey:@"id"];
       suggestActivityName=[[activityList objectAtIndex:ind]valueForKey:@"activity"];
    
    NSString * title=[NSString stringWithFormat:@"Are you sure you want to remove '%@' from your activities?",suggestActivityName];
    NSString * message=[NSString stringWithFormat:@"If yes, we will no longer match you with %@ buddies",suggestActivityName];
    
    [JKAlertView showalertWithMessage:message title:title cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] alertComplitionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 1:
            {
                BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
                if (is_net==YES)
                {
                    [[ServerManager getSharedInstance]showactivityHub:@"Please wait.." addWithView:self.view];
                    
                    // NSString * poststr=[NSString stringWithFormat:@"usr_id=%@&usr_name=%@",usrId,name];
                    [ServerManager getSharedInstance].Delegate=self;
                    NSDictionary * userinfoDict=[NSDictionary dictionaryWithDictionary:[NSUserDefaults getNSUserDefaultValueForKey:kLoginUserInfo]] ;
                    NSString*  usrId=[NSString stringWithFormat:@"%@",[userinfoDict objectForKey:@"id"]];
                    NSDictionary * postDict=[NSDictionary dictionaryWithObjectsAndKeys:suggestActivityid,@"id",usrId,@"usr_id", nil];
                    [[ServerManager getSharedInstance]postDataOnserver:postDict withrequesturl:kdeleteActivity];
                    
                    
                }
                
            }
                break;
                
            
        }

        
    }];
    
}


#pragma mark-Server Manager Delegate-

#pragma mark- Deleage Method 0f Server Manager-

-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    [[ServerManager getSharedInstance]hideHud];
    if ([serviceurl isEqual:kMyActivity])
    {
        int success=[[responseDict valueForKey:@"success"] intValue];
        activityList=[responseDict valueForKey:@"data"];

        switch (success) {
            case 1:
            {
                if (activityList.count>0)
                {
//                    [CollectionView reloadData];
                    [self setupScroll];
                    
                }
            }
                break;
            case 0:
            {
                if (activityList.count==0)
                {    
             //       [CollectionView reloadData];
                    [self setupScroll];
                    
                }
 
                
            }
            default:
                break;
        }
        
    }
    else if ([serviceurl isEqual:ksuggestActivity])
    {
        int success=[[responseDict valueForKey:@"success"] intValue];
        switch (success) {
            case 1:
            {
                
                [ServerManager showAlertView:@"Thanks for suggestion" withmessage:@"we'll get back to you soon"];

            }
                break;
                
            default:
                break;
        }
        
    }
    else if ([serviceurl isEqual:kdeleteActivity])
    {
        int success=[[responseDict valueForKey:@"success"] intValue];
        switch (success) {
            case 1:
            {
                [ServerManager showAlertView:@"Message" withmessage:[responseDict valueForKey:@"msg"]];
//                [CollectionView reloadData];
            [self suggestActivityList];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Message" withmessage:failureError.localizedDescription];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupScroll
{
    for(UIView *views in [objScrollView subviews])
    {
        [views removeFromSuperview];
    }
    
    int xSize=5,ySize=5;
    for(int items=0;items<[activityList count];items++)
    {
        UIView *tagView=[[UIView alloc]initWithFrame:CGRectMake(xSize, ySize, 70, 40)];
        tagView.backgroundColor=[UIColor grayColor];
        tagView.layer.cornerRadius=7;
        tagView.layer.borderColor=[[UIColor whiteColor]CGColor];
        tagView.layer.borderWidth=1;
//        UIFont  *descFont=lbl_title.font;
        NSString * activity=[activityList[items] valueForKey:@"activity"];
        if([activity isEqual:[NSNull null]])
        {
            activity=@"No Activity";
        }
        CGSize descpSize= [[ServerManager getSharedInstance]gettextsize:activity font:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(60, 1000)];

        UILabel *lblForTitle=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, descpSize.width+12, 30)];
        lblForTitle.textColor=[UIColor whiteColor];
        lblForTitle.backgroundColor=[UIColor clearColor];
        lblForTitle.text=activity;
        [tagView addSubview:lblForTitle];
        
//        lbl_title.frame=CGRectMake(lblForTitle.frame.origin.x, lbl_title.frame.origin.y, descpSize.width+10, lbl_title.frame.size.height);
        UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        btnDelete.frame=CGRectMake(lblForTitle.frame.origin.x+lblForTitle.frame.size.width+5,5, 30, 30);
        btnDelete.tag=100+items;
        [btnDelete addTarget:self action:@selector(TappedOnDelete:) forControlEvents:UIControlEventTouchUpInside];
        [tagView addSubview:btnDelete];
        
        tagView.frame=CGRectMake(tagView.frame.origin.x, tagView.frame.origin.y, btnDelete.frame.size.width+lblForTitle.frame.size.width+15, tagView.frame.size.height);
        
        
        xSize=tagView.frame.size.width+5+xSize;
        
        NSLog(@"aaa %d",xSize);
        
        if([[UIScreen mainScreen]bounds].size.width<xSize+130)
        {
            xSize=5;
            ySize=ySize+50;
        }
        
        [objScrollView addSubview:tagView];
    }
}
@end
