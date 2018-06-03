//
//  MenuTypeNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuTypeNote : NSObject
@property (nonatomic) NSInteger menuTypeNoteID;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;


-(MenuTypeNote *)initWithMenuTypeID:(NSInteger)menuTypeID noteID:(NSInteger)noteID;
+(NSInteger)getNextID;
+(void)addObject:(MenuTypeNote *)menuTypeNote;
+(void)removeObject:(MenuTypeNote *)menuTypeNote;
+(MenuTypeNote *)getMenuTypeNote:(NSInteger)menuTypeNoteID;
+(NSMutableArray *)getNoteListWithMenuTypeID:(NSInteger)menuTypeID;
@end
