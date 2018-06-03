//
//  OrderCancelDiscount.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderTaking.h"


@interface OrderCancelDiscount : NSObject
@property (nonatomic) NSInteger orderCancelDiscountID;
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (retain, nonatomic) NSString * reason;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(OrderCancelDiscount *)initWithOrderTakingID:(NSInteger)orderTakingID type:(NSInteger)type discountType:(NSInteger)discountType discountAmount:(float)discountAmount reason:(NSString *)reason;
+(NSInteger)getNextID;
+(void)addObject:(OrderCancelDiscount *)orderCancelDiscount;
+(void)removeObject:(OrderCancelDiscount *)orderCancelDiscount;
+(void)addList:(NSMutableArray *)orderCancelDiscountList;
+(void)removeList:(NSMutableArray *)orderCancelDiscountList;
+(OrderCancelDiscount *)getOrderCancelDiscount:(NSInteger)orderCancelDiscountID;
+(OrderCancelDiscount *)getOrderCancelDiscountWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderCancelDiscountListWithOrderTaking:(OrderTaking *)orderTaking;

@end
