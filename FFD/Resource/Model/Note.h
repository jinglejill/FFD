//
//  Note.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) float price;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Note *)initWithName:(NSString *)name price:(float)price orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Note *)note;
+(void)removeObject:(Note *)note;
+(Note *)getNote:(NSInteger)noteID;


@end
