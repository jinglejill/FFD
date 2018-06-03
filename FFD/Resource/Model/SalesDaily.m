//
//  SalesDaily.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SalesDaily.h"

@implementation SalesDaily


+(SalesDaily *)getSalesDailyWithSalesDate:(NSDate *)salesDate menuTypeID:(NSInteger)menuTypeID salesDailyList:(NSMutableArray *)salesDailyList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_salesDate = %@ and menuTypeID = %ld",salesDate,menuTypeID];
    NSArray *filterArray = [salesDailyList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}

+(float)getSumSalesWithSalesDate:(NSDate *)salesDate salesDailyList:(NSMutableArray *)salesDailyList
{
    float sum = 0;
    for(SalesDaily *item in salesDailyList)
    {
        if([item.salesDate isEqual:salesDate])
        {
            sum += item.sales;
        }
    }
    return sum;
}

+(NSInteger)getCountSalesDate:(NSMutableArray *)salesDailyList
{
    NSSet *salesDateSet = [NSSet setWithArray:[salesDailyList valueForKey:@"_salesDate"]];
    return [salesDateSet count];
}

+(float)getSumSales:(NSMutableArray *)salesDailyList
{
    float sum = 0;
    for(SalesDaily *item in salesDailyList)
    {
        sum += item.sales;
    }
    return sum;
}

+(float)getSumSalesYTD:(NSMutableArray *)salesDailyList
{
    float sum = 0;
    for(SalesDaily *item in salesDailyList)
    {
        sum += item.salesYTD;
    }
    return sum;
}

+(SalesDaily *)getSalesDailyWithMenuTypeID:(NSInteger)menuTypeID salesDailyList:(NSMutableArray *)salesDailyList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [salesDailyList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}

+(float)getSumSalesCustomerBlank:(NSMutableArray *)salesDailyList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customer = ''"];
    NSArray *filterArray = [salesDailyList filteredArrayUsingPredicate:predicate];
    
    
    if([filterArray count]>0)
    {
        SalesDaily *salesDaily = filterArray[0];
        return salesDaily.sales;
    }
    return 0;
}
@end
