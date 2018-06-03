//
//  SalesDaily.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesDaily : NSObject
@property (retain, nonatomic) NSDate * salesDate;
@property (nonatomic) float sales;
@property (nonatomic) float discountValue;
@property (nonatomic) float dayOfWeek;
@property (nonatomic) float menuTypeID;
@property (nonatomic) float menuID;
@property (nonatomic) float salesYTD;
@property (nonatomic) NSInteger menuTypeOrderNo;
@property (nonatomic) NSInteger subMenuTypeOrderNo;
@property (nonatomic) NSInteger menuOrderNo;
@property (nonatomic,retain) NSString *customer;
@property (nonatomic,retain) NSDate *memberDate;
@property (nonatomic) float salesEatIn;
@property (nonatomic) float salesTakeAway;
@property (nonatomic) float salesDelivey;


+(SalesDaily *)getSalesDailyWithSalesDate:(NSDate *)salesDate menuTypeID:(NSInteger)menuTypeID salesDailyList:(NSMutableArray *)salesDailyList;
+(float)getSumSalesWithSalesDate:(NSDate *)salesDate salesDailyList:(NSMutableArray *)salesDailyList;
+(NSInteger)getCountSalesDate:(NSMutableArray *)salesDailyList;
+(float)getSumSales:(NSMutableArray *)salesDailyList;
+(float)getSumSalesYTD:(NSMutableArray *)salesDailyList;
+(SalesDaily *)getSalesDailyWithMenuTypeID:(NSInteger)menuTypeID salesDailyList:(NSMutableArray *)salesDailyList;
+(float)getSumSalesCustomerBlank:(NSMutableArray *)salesDailyList;
@end
