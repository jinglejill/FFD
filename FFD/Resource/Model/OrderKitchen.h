//
//  OrderKitchen.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderKitchen : NSObject
@property (nonatomic) NSInteger orderKitchenID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger sequenceNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(OrderKitchen *)initWithCustomerTableID:(NSInteger)customerTableID orderTakingID:(NSInteger)orderTakingID sequenceNo:(NSInteger)sequenceNo;
+(NSInteger)getNextID;
+(void)addObject:(OrderKitchen *)orderKitchen;
+(void)removeObject:(OrderKitchen *)orderKitchen;
+(OrderKitchen *)getOrderKitchen:(NSInteger)orderKitchenID;
+(NSInteger)getNextSequenceNo;


@end
