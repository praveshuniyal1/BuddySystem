//
//  DBManager.h
//  Pocket_Passwords
//
//  Created by webAstral on 11/12/14.
//  Copyright (c) 2014 Pardeep Batra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "JKClassManager.h"
#import "DBManagerDelegate.h"
//@class DBManager;
//@protocol DBManagerDelegate <NSObject>
//
//@optional
//
//-(void)database:(DBManager*)database success:(BOOL)_issuccess withSatement:(NSString*)statement;
//
//@end
// DBSatement const
UIKIT_EXTERN NSString *const DBdeleteStmt;
UIKIT_EXTERN NSString *const DBInsertStmt;
UIKIT_EXTERN NSString *const DBUpdateStmt;


// SQL Table name const
UIKIT_EXTERN NSString *const AllMessage;
UIKIT_EXTERN NSString *const AddPhotosTb;
UIKIT_EXTERN NSString *const GeneralNotesTb;
UIKIT_EXTERN NSString *const FollowupNotesTB;
UIKIT_EXTERN NSString *const ImmidiateActionNoteTb;

@interface DBManager : NSObject
{
  sqlite3 *db;
  NSString *databasePath;

    id<DBManagerDelegate>Delegate;
 
}
@property(strong,nonatomic)id<DBManagerDelegate>Delegate;
+(DBManager*)getSharedInstance;
-(void)createDB;

// Methods Of Sql Query-
-(void)insertQuery:(NSString*)insertQuery;
-(void)updateQuery:(NSString*)updatequery;
- (NSMutableArray*)readallMessageQuery:(NSString*)selectquery;
-(void)deleteQuery:(NSString*)deleteQuery;
-(NSMutableArray*)fetchAllIds:(NSString*)selectQuery;
- (NSMutableArray*)FetchCategaryList:(NSString*)selectquery;
// Image Methods-
-(NSString*)imagePathfromdirectory:(UIImage *)image;
-(UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
//-(NSString*)base64StringOfImagedata:(NSData*)imagedata;
//-(UIImage*)getimageOfBase64String:(NSString*)encodedString;
-(CALayer*)cropimageCricularOvalShape :(UIView*)YourImageview CornerRadius:(CGFloat)Radius BorderWidth:(CGFloat)BorderWidth;
-(UIImage *)fetchTheImage:(NSString *)imagename;

-(NSString*)getFilePath:(NSString*)filename;

@end
