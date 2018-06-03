//
//  MoneyCheck.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyCheck : NSObject
@property (nonatomic) NSInteger moneyCheckID;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger method;
@property (nonatomic) float amount;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * checkUser;
@property (retain, nonatomic) NSDate * checkDate;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(MoneyCheck *)initWithType:(NSInteger)type method:(NSInteger)method amount:(float)amount status:(NSInteger)status checkUser:(NSString *)checkUser checkDate:(NSDate *)checkDate;
+(NSInteger)getNextID;
+(void)addObject:(MoneyCheck *)moneyCheck;
+(void)removeObject:(MoneyCheck *)moneyCheck;
+(void)addList:(NSMutableArray *)moneyCheckList;
+(void)removeList:(NSMutableArray *)moneyCheckList;
+(MoneyCheck *)getMoneyCheck:(NSInteger)moneyCheckID;
+(NSMutableArray *)getMoneyCheckListWithType:(NSInteger)type checkDateStart:(NSDate *)startDate checkDateEnd:(NSDate *)endDate;



@end
