//
//  TableTaking.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableTaking : NSObject
@property (nonatomic) NSInteger tableTakingID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger servingPerson;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(TableTaking *)initWithCustomerTableID:(NSInteger)customerTableID servingPerson:(NSInteger)servingPerson status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(TableTaking *)tableTaking;
+(void)removeObject:(TableTaking *)tableTaking;
+(TableTaking *)getTableTaking:(NSInteger)tableTakingID;
+(TableTaking *)getTableTakingWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
@end
