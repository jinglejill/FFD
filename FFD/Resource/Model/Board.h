//
//  Board.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Board : NSObject
@property (nonatomic) NSInteger boardID;
@property (retain, nonatomic) NSString * content;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Board *)initWithContent:(NSString *)content;
+(NSInteger)getNextID;
+(void)addObject:(Board *)board;
+(void)removeObject:(Board *)board;
+(void)addList:(NSMutableArray *)boardList;
+(void)removeList:(NSMutableArray *)boardList;
+(Board *)getBoard:(NSInteger)boardID;
+(NSString *)getContent;


@end
