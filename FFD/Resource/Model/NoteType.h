//
//  NoteType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteType : NSObject
@property (nonatomic) NSInteger noteTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;


@property (nonatomic) NSInteger type;




-(NoteType *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(NoteType *)noteType;
+(void)removeObject:(NoteType *)noteType;
+(void)addList:(NSMutableArray *)noteTypeList;
+(void)removeList:(NSMutableArray *)noteTypeList;
+(NoteType *)getNoteType:(NSInteger)noteTypeID;
+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList;



@end
