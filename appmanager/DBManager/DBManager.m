//
//  DBManager.m
//  Pocket_Passwords
//
//  Created by webAstral on 11/12/14.
//  Copyright (c) 2014 Pardeep Batra. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
//static sqlite3_stmt *statement = nil;

NSString *const DBdeleteStmt =@"delete";
NSString *const DBInsertStmt=@"Insert" ;
NSString *const DBUpdateStmt =@"Update";

// SQL Table name const
 NSString *const AllMessage=@"ReadAllMessage";
 NSString *const AddPhotosTb=@"AddPhotos";
 NSString *const GeneralNotesTb=@"GeneralNotes";
 NSString *const FollowupNotesTB=@"FollowupNotes";
 NSString *const ImmidiateActionNoteTb=@"ImmidiateActionNote";

@implementation DBManager
@synthesize Delegate;
+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
       // [sharedInstance createDB];
    }
    return sharedInstance;
}


#pragma mark-createDB-
-(void)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"buddySystem.sqlite"]];
    NSLog(@"%@",databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            // messages
           const char *sql_stmt = "CREATE TABLE IF NOT EXISTS Messages(ID INTEGER PRIMARY KEY AUTOINCREMENT, to_name TEXT,to_id TEXT,from_name TEXT,from_id TEXT,msg_id INTEGER,session_id INTEGER,content TEXT,type_id INTEGER,state INTEGER,create_time DATETIME,latitute double, longitute double)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create Messages table");
            }

            // messages
            const char *sql_stmt1 = "CREATE TABLE IF NOT EXISTS Category(cat_id INTEGER PRIMARY KEY , category TEXT,thumbnails TEXT,youtube_link TEXT,video_url TEXT)";
            if (sqlite3_exec(database, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create Messages table");
            }
            

            
            sqlite3_close(database);
            
        } else
        {
            NSLog( @"Failed to open/create database");
        }
    }

}




#pragma mark-  Sql Query-


#pragma mark- insertQueryAction-
-(void)insertQuery:(NSString *)insertQuery
{
    static sqlite3_stmt *statement=nil;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
       
        const char *insert_stmt = [insertQuery UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        
        //  sqlite3_bind_text(statement, 1, [dateString UTF8String] , -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [Delegate database:self success:YES withSatement:DBInsertStmt];
            
        } else
        {
          NSLog(@"Failed to add contact  %s",sqlite3_errmsg( database ));            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }

}

#pragma mark- UpdateQueryAction-
-(void)updateQuery:(NSString *)updatequery
{
    
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        const char *update_stmt = [updatequery UTF8String];
        
        sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [Delegate database:self success:YES withSatement:DBUpdateStmt];
            
        } else
        {
            NSLog(@"Failed to add contact");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }

}


#pragma mark- DeleteQueryAction-
-(void)deleteQuery:(NSString *)deleteQuery
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
       
        
        const char *query_stmt = [deleteQuery UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
                
                [Delegate database:self success:YES withSatement:DBdeleteStmt];
                
                
            }
            else
            {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    

}

-(NSMutableArray*)fetchAllIds:(NSString*)selectQuery

{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray * readmessageArr=[NSMutableArray new];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
       // NSString *selectQuery=@"SELECT job_id FROM MyJob";
        const char *query_stmt = [selectQuery UTF8String];
        // int sqlResult = sqlite3_prepare_v2(database, //query_stmt, -1, &statement, NULL) ;
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
              //  NSLog(@"%@",statement);
                
                    int job_idField =  sqlite3_column_int(statement, 0);
                    [readmessageArr addObject:[NSNumber numberWithInt:job_idField]];
               
            }
            
            sqlite3_finalize(statement);
        }
        else
        {
            
        }
        sqlite3_close(database);
    }
    
    return readmessageArr;
}
#pragma mark-readallMessage-
- (NSMutableArray*)readallMessageQuery:(NSString*)selectquery
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray * readmessageArr=[NSMutableArray new];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //ORDER BY "column_name" ASC
        //SELECT * FROM scoretable order by score desc"
       // NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Messages order by msg_id ASC"];
        
        const char *query_stmt = [selectquery UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int RowIdField =  sqlite3_column_int(statement, 0);
                
                
                
                NSString *tonameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *to_userid = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *fromnameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *from_id = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                int msgIdField =  sqlite3_column_int(statement, 5);
                double session_id=sqlite3_column_int64(statement, 6);
                NSString *content = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                int type_id=sqlite3_column_int(statement, 8);
                
                int state=sqlite3_column_int(statement, 9);
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *myDate =[dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                
                NSString * createTime=[[ServerManager getSharedInstance]getUTCFormateDate:myDate];
                
                NSMutableDictionary * tempdict=  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:RowIdField],@"rowIndex",tonameField,@"to_name",to_userid,@"to_userId",fromnameField,@"from_name",from_id,@"from_id",[NSNumber numberWithInt:msgIdField],@"msg_id",[NSNumber numberWithLongLong:session_id],@"session_id",content,@"content",[NSNumber numberWithInt:type_id],@"type_id",[NSNumber numberWithInt:state],@"state",createTime,@"create_time", nil];
                
                [readmessageArr addObject:tempdict];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    return readmessageArr;
}

//------------------------------ End--------------------------------
#pragma mark- imagepath-
-(NSString*)imagePathfromdirectory:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    NSString *fullPath ;
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"MddyyHHmmss"];
    
    NSString *dateInStringFormated=[dateformatter stringFromDate:[NSDate date]];
    
    dateInStringFormated = [dateInStringFormated stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[self randomNumberZeroToTwo]]];
    fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%@.png",dateInStringFormated]]; //add our image to the path
    
    
    
    NSLog(@"%@",fullPath);
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    return [NSString stringWithFormat:@"image_%@.png",dateInStringFormated];
    
}
#pragma mark-fetchTheImage-
-(UIImage *)fetchTheImage:(NSString *)imagename
{
    NSLog(@"\n\nfetchTheImagename=%@",imagename);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    NSString *fullPath ;
    
    
    fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imagename]]; //ad
    NSLog(@"image=%@",[UIImage imageWithContentsOfFile:fullPath]);
    
    NSURL *imageurl=[NSURL fileURLWithPath:fullPath];
    
    NSData * imagedata=[NSData dataWithContentsOfURL:imageurl];
    
    UIImage *image=[UIImage imageWithData:imagedata];
    
    return image;
    
}

#pragma mark- RandomFunction-
-(NSInteger) randomNumberZeroToTwo {
    NSInteger randomNumber = (NSInteger) arc4random_uniform(3); // picks between 0 and n-1 where n is 3 in this case, so it will return a result between 0
    return randomNumber;
    
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

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

#pragma mark-cropimageCricularOvalShape-

-(CALayer*)cropimageCricularOvalShape :(UIView*)YourImageview CornerRadius:(CGFloat)Radius BorderWidth:(CGFloat)BorderWidth
{
   
    CALayer *imageLayer = YourImageview.layer;
    [imageLayer setCornerRadius:Radius];
    [imageLayer setBorderWidth:BorderWidth];
    [imageLayer setMasksToBounds:YES];
    return imageLayer;
}



- (NSMutableArray*)FetchCategaryList:(NSString*)selectquery
{
   //cat_id INTEGER PRIMARY KEY , category TEXT,thumbnails TEXT,youtube_link TEXT
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray * readmessageArr=[NSMutableArray new];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //ORDER BY "column_name" ASC
        //SELECT * FROM scoretable order by score desc"
        // NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Messages order by msg_id ASC"];
        
        const char *query_stmt = [selectquery UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int cat_id =  sqlite3_column_int(statement, 0);
                
                
                
                NSString *categoryField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *thumbnails = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *youtube_link = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *video_url = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
               
                
                NSMutableDictionary * tempdict=  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cat_id],@"id",categoryField,@"category",thumbnails,@"thumbnails",youtube_link,@"youtube_link",video_url,@"video_url", nil];
                
                [readmessageArr addObject:tempdict];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    return readmessageArr;

}


-(NSString*)getFilePath:(NSString*)filename
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
     NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString * path=[[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: filename]];
    
     if ([filemgr fileExistsAtPath: path ] == YES)
     {
         return path;
     }
    else
    {
        return @"No found";
    }
   

}
@end
