//
//  CustomerTable.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerTable : NSObject
@property (nonatomic) NSInteger customerTableID;
@property (retain, nonatomic) NSString * tableName;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(CustomerTable *)initWithTableName:(NSString *)tableName type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(CustomerTable *)customerTable;
+(CustomerTable *)getCustomerTable:(NSInteger)customerTableID;
+(NSMutableArray *)getCustomerTableListWithStatus:(NSInteger)status;
+(CustomerTable *)getCustomerTableWithTableName:(NSString *)tableName status:(NSInteger)status;
@end
