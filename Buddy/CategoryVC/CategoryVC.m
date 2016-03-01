  //
//  CategoryVC.m
//  BuddySystem
//
//  Created by Jitendra on 19/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#import "CategoryVC.h"

@interface CategoryVC ()
{
     IBOutlet UICollectionViewFlowLayout *flowLayout;
    NSInteger sessionCurrentPage;
    NSInteger previousPage;
    NSInteger currentPage;
    BOOL ignorePageChangeUntilDecelerated;
    BOOL activietdmove;
    long currentIndex;
}
@end

@implementation CategoryVC
@synthesize delegate,downloadedURl;
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
    CountoFpages=0;
    categoryList=[NSMutableArray new];
    jsonarray=[NSMutableArray new];
    [Headerbtn setTitle:self.currentTime forState:UIControlStateNormal];
    
    [flowLaout setMinimumInteritemSpacing:0.0f];
    [flowLaout setMinimumLineSpacing:0.0f];
    flowLaout.minimumLineSpacing = 0;
    [categoryCollection setPagingEnabled:YES];
    [categoryCollection setShowsHorizontalScrollIndicator:NO];
    [categoryCollection setCollectionViewLayout:flowLaout];
   
    KappDelgate.categoryidArr=[KappDelgate getAllCategoryId];
    NSLog(@"%@",KappDelgate.categoryidArr);
    
    [[NSNotificationCenter defaultCenter]addObserverForName:DBInsertStmt object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         [self afterDownloadReload];
         if ( [[note object] isKindOfClass:[NSURL class]])
         {
             NSURL * fileUrl=(NSURL*)[note object];
            
                 [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
            
         }
         [[NSNotificationCenter defaultCenter]removeObserver:self name:DBInsertStmt object:nil];
    }];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:@"NewMessage" object:nil];

}

-(void)changeImage:(NSNotification *)notif
{
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"chat_hover"] forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getDBCategory];
    [self getCategoryList];
    
    
}
-(void)getDBCategory
{
    NSMutableArray * readdata=[NSMutableArray arrayWithArray:[KappDelgate readAllCategory]];
   
    if (readdata.count)
    {
        [jsonarray removeAllObjects];
        [categoryList removeAllObjects];
        jsonarray=[readdata mutableCopy];
        categoryList=[readdata mutableCopy];
        
        //pagecontrol.numberOfPages=categoryList.count;
       
        [categoryCollection reloadData];
       
        
        NSString * vidoeFileName=[NSUserDefaults getNSUserDefaultObjectForKey:@"vidoeFileName"];
        
        if (vidoeFileName.length>0&&(![vidoeFileName isKindOfClass:[NSNull class]]))
        {
            NSString * videoPath=[[DBManager getSharedInstance]getFilePath:vidoeFileName];
            
            if (![videoPath isEqual:@"No found"])
            {
                NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",videoPath]];
                [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
                [NSUserDefaults removeNSUserDefaultObjectForKey:@"vidoeFileName"];
                
            }
        }
        else
        {
            
            NSString * video_name=[[categoryList objectAtIndex:pagecontrol.currentPage] valueForKey:@"video_url"] ;
            // NSString * video_name=[[categoryList objectAtIndex:currentIndex] valueForKey:@"video_url"] ;
            
            NSString * videoPath=[[DBManager getSharedInstance]getFilePath:video_name];
            
            if (![videoPath isEqual:@"No found"])
            {
                NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",videoPath]];
                
                [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
            }
        }
        
    }
    
}


#pragma mark - Data Source Method Of Collection View-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [categoryList count];
        
   
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    
    CategoryCell *playingCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [playingCardCell loadCategoryListData:[categoryList objectAtIndex:indexPath.row]];

    playingCardCell.letsdoThisbtn.tag=100+indexPath.row;
    [playingCardCell.letsdoThisbtn addTarget:self action:@selector(TappedOnLetDoThis:) forControlEvents:UIControlEventTouchUpInside];
    return playingCardCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}



#pragma mark- Delegate method of UIScrollView-

- (void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    
        sessionCurrentPage = lround( aScrollView.contentOffset.x / CGRectGetWidth(aScrollView.frame) );
        previousPage = sessionCurrentPage;
    
    
  
}
#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

   ignorePageChangeUntilDecelerated = decelerate;
    //NSLog(@"%@",eventTable.visibleCells);
    if (decelerate)
        activietdmove=YES;
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    ignorePageChangeUntilDecelerated = NO;
   
    if (activietdmove==YES)
    {

        [self showVisibleCell];
        activietdmove=NO;
    }
   //
    
}


#pragma mark-showVisibleCell-
-(void)showVisibleCell
{
    
    pagecontrol.numberOfPages=5;
   
    CGRect visibleRect = (CGRect){.origin = categoryCollection.contentOffset, .size = categoryCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    
    
    NSIndexPath *visibleIndexPath = [categoryCollection indexPathForItemAtPoint:visiblePoint];
    if (pagecontrol.currentPage< pagecontrol.numberOfPages)
    {
        NSLog(@"%ld",visibleIndexPath.row);
        pagecontrol.currentPage=visibleIndexPath.row;
        //[self currentPageindex:pagecontrol.currentPage];
        [self currentPageindex:visibleIndexPath.row];
    }



}
// c
#pragma mark-currentPageindex-
-(void)currentPageindex:(NSInteger)current
{
    currentIndex=current;
    if (current>=5)
    {
        if (current%5==0)
        {
             pagecontrol.currentPage=0;
        }
        else
        {
            long left=current/5;
            long leftpage=current-5*left;
            pagecontrol.currentPage=leftpage;
        }
    }
    if ([categoryList count]>0)
    {

        if (current<categoryList.count)
        {

            NSMutableDictionary * jsondict=[NSMutableDictionary dictionaryWithDictionary:[categoryList objectAtIndex:current]];
            NSLog(@"Select Slide dict %ldd=%@",(long)current,jsondict);

                NSString * video_name=[[[[categoryList objectAtIndex:current] valueForKey:@"video_url"] componentsSeparatedByString:@"/"] lastObject] ;
                
                NSString * videoPath=[[DBManager getSharedInstance]getFilePath:video_name];
                
                if (![videoPath isEqual:@"No found"])
                {
                    NSURL * fileUrl= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",videoPath]];
                    
                    if (KappDelgate.playerview!=nil)
                    {
                        //[KappDelgate.playerview playnewVideoWithUrl: fileUrl];
                         [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
                    }
                    else
                    {
                        [KappDelgate addPlayerInCurrentViewController:self.view bringView:contentView MovieUrl:fileUrl];
                    }
                }

            else
            {
                
                if ([[ServerManager getSharedInstance]checkNetwork]==YES)
                {
                    KappDelgate.downloadIndx=(int)current;
                    
                    //[KappDelgate dowloadStreamVideo:[categoryList objectAtIndex: current] fileCount:(int)categoryList.count];
                    if (current<categoryList.count-2)
                    {
//                        [KappDelgate dowloadStreamVideo:[categoryList objectAtIndex: current] andNext:[categoryList objectAtIndex: current+1]   fileCount:(int)current];
                        
                        [KappDelgate dowloadStreamVideo:[categoryList objectAtIndex: current] andNext:[categoryList objectAtIndex: current+1]  andfurtherNexr:[categoryList objectAtIndex: current+2] fileCount:(int)current andtotalCount:(int)categoryList.count-1];
                    }
                    else if(current<categoryList.count-1)
                    {
                        [KappDelgate dowloadStreamVideo:[categoryList objectAtIndex: current] andFurtherNext:[categoryList objectAtIndex: current+1] fileCount:(int)current andtotalCount:(int)categoryList.count-1];
                    }
                    else if(current<categoryList.count)
                    {
                        [KappDelgate dowloadStreamVideo:[categoryList objectAtIndex: current]  fileCount:(int)current andtotalCount:(int)categoryList.count-1];
                    }

                    
                    

                }

            }

        }
    }
    
   }



- (IBAction)tappedOnMenu:(id)sender
{
    [KappDelgate showJKPopupMenuInView:self.view animation:YES];
    //[self showjkpopmenu:YES];
}

#pragma mark- TappedOnLetDoThis -
-(void)TappedOnLetDoThis:(UIButton*)btn
{
    int arrindex=(int)btn.tag-100;
    
    [[ServerManager getSharedInstance]showactivityHub:@"loading.." addWithView:self.navigationController.view];
    CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];
    
    [[LocationManager locationInstance]reverseGeocodeAddrLatitude:loctCoord.latitude longitude:loctCoord.longitude Success:^(NSString *currentAddress)
     {
         
         NSString* address=[currentAddress copy];
         
//         NSString * video_name=[[[[categoryList objectAtIndex:arrindex] valueForKey:@"video_url"] componentsSeparatedByString:@"/"] lastObject];
         NSString * video_name=[[categoryList objectAtIndex:arrindex] valueForKey:@"video_url"] ;
         [NSUserDefaults setNSUserDefaultValue:video_name key:@"vidoeFileName"];
         NSMutableDictionary * currentDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:Headerbtn.titleLabel.text,@"CatTime",[[categoryList objectAtIndex:arrindex] valueForKey:@"category"],@"cat_name",[[categoryList objectAtIndex:arrindex] valueForKey:@"id"],@"cat_id",video_name,@"videoFile",address,@"address",[[categoryList objectAtIndex:arrindex] valueForKey:@"youtube_link"],@"youtube_link",[[categoryList objectAtIndex:arrindex] valueForKey:@"youtube_thumbnails"],@"thumbnails",[[categoryList objectAtIndex:arrindex] valueForKey:@"status"],@"status", nil];
         
         FBWallPostVC * wallVc=[self.storyboard instantiateViewControllerWithIdentifier:@"FBWallPostVC"];
         
         wallVc.SelectCatDict=[currentDict mutableCopy];
         [self.navigationController pushViewController:wallVc animated:YES];
         [[ServerManager getSharedInstance]hideHud];
         
     }];
    
    
    
    
    
}

#pragma mark- OnBack -
- (IBAction)OnBack:(id)sender
{
    //[delegate categoryview:self fromPopToView:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- OnChat -
- (IBAction)OnChat:(id)sender
{
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    [KappDelgate pushViewController:self NibIdentifier:@"FriendListVC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getCategoryList
{
    BOOL is_net=[[ServerManager getSharedInstance]checkNetwork];
    
    if (is_net==YES)
    {
        [ServerManager getSharedInstance].Delegate=self;
        [[ServerManager getSharedInstance]showactivityHub:@"Loading.." addWithView:self.navigationController.view];
        [[ServerManager getSharedInstance]FetchDatafromServer:KeventCategory withAppendString:@""];
        
    }
}
-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    NSLog(@"responceURL=%@",serviceurl);
    [[ServerManager getSharedInstance]hideHud];
    int success=[[responseDict valueForKey:@"status"]intValue];
    KappDelgate.categoryidArr=[KappDelgate getAllCategoryId];
    switch (success)
    {
        case 1:
        {
            NSMutableArray * jsonarr=[NSMutableArray arrayWithArray:[responseDict valueForKey:@"Activities"]];
            if (jsonarr.count>0)
            {
                [categoryList removeAllObjects];
                
                if (KappDelgate.categoryidArr.count>0)
                {
                    for (int ind=0; ind<[jsonarr count]; ind++)
                    {
                        NSMutableDictionary * jsondict=[NSMutableDictionary dictionaryWithDictionary:[jsonarr objectAtIndex:ind]];
                        
                        int categoryid=[[jsondict valueForKey:@"id"] intValue];
                        NSString* categoryid1=[jsondict valueForKey:@"id"];
                        
                        NSLog(@"%@",KappDelgate.categoryidArr);
                        if ([KappDelgate.categoryidArr containsObject:[NSNumber numberWithInt:categoryid]])
                        {
                            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(id == %d)", categoryid];
                            NSPredicate *resultPredicate1 = [NSPredicate predicateWithFormat:@"(id == %@)", categoryid1];
                            NSArray * filterarr = [jsonarray filteredArrayUsingPredicate:resultPredicate];
                            NSArray * filterarr1 = [jsonarr filteredArrayUsingPredicate:resultPredicate1];
                            //if (filterarr .count>0)
                            if (filterarr1 .count>0)
                            {
                                
                                //[categoryList addObject:[filterarr objectAtIndex:0]];
                                 [categoryList addObject:[filterarr1 objectAtIndex:0]];
                            }
                        }
                        else
                        {
                            [categoryList addObject:jsondict];
                        }
                    }
                    
                }
                else
                {
                    categoryList=[jsonarr mutableCopy];
                    
                }
                
                if (categoryList.count>0)
                {
                   // pagecontrol.numberOfPages=categoryList.count;
                    
                    [categoryCollection reloadData];
                    [jsonarray removeAllObjects];
                    
                    [self showVisibleCell];
                    
                }
                
                
            }
 
         }
            
            break;
            
        default:
            break;
    }
}

-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Error!!" withmessage:failureError.localizedDescription];
}


-(void)viewDidDisappear:(BOOL)animated
{
    
}


-(void)afterDownloadReload
{

     NSMutableArray * jsonarr=[NSMutableArray arrayWithArray:[KappDelgate readAllCategory]];
    if (jsonarr.count>0)
    {
        NSLog(@"categoryList==%@",categoryList);
        
        NSLog(@"jsonarr== %@",jsonarr);

        KappDelgate.categoryidArr=[KappDelgate getAllCategoryId];
        if (KappDelgate.categoryidArr.count>0)
        {
            int ind=KappDelgate.downloadIndx;
            
            NSMutableDictionary * jsondict;
            if(ind>=[jsonarr count])
            {
                jsondict=[NSMutableDictionary dictionaryWithDictionary:[jsonarr lastObject]];
            }
            else
            {
                // pankaj change
                
                   // jsondict=[NSMutableDictionary dictionaryWithDictionary:[jsonarr objectAtIndex:ind]];
                //jsondict=[NSMutableDictionary dictionaryWithDictionary:[jsonarr objectAtIndex:0]];
                
                
            }
            
            int categoryid=[[[categoryList objectAtIndex:ind] valueForKey:@"id"] intValue];
            
            if ([KappDelgate.categoryidArr containsObject:[NSNumber numberWithInt:categoryid]])
            {
                
              //  [categoryList replaceObjectAtIndex:ind withObject:jsondict];
               
                NSLog(@"after %@",categoryList);

                
            }

            
        }
        
        
        if (categoryList.count>0)
        {
            //pagecontrol.numberOfPages=categoryList.count;
            pagecontrol.numberOfPages=5;
            [categoryCollection reloadData];
            //[jsonarray removeAllObjects];
           
        }
        
        
    }
 
}
@end
