//
//  ReportEndDay.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/25/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportEndDay.h"

@implementation ReportEndDay


+(NSInteger)getSumQuantityWithCustomerTypeID:(NSInteger)customerTypeID menuTypeID:(NSInteger)menuTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld and _menuTypeID = %ld",customerTypeID,menuTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    NSInteger sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.quantity;
    }
    return sum;
}

+(float)getSumSalesWithCustomerTypeID:(NSInteger)customerTypeID menuTypeID:(NSInteger)menuTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld and _menuTypeID = %ld",customerTypeID,menuTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.sales;
    }
    return sum;
}

+(NSInteger)getSumQuantityWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    NSInteger sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.quantity;
    }
    return sum;
}

+(float)getSumSalesWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.sales;
    }
    return sum;
}

+(NSInteger)getSumQuantityWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSInteger sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.quantity;
    }
    return sum;
}

+(float)getSumSalesWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    float sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.sales;
    }
    return sum;
}

+(float)getSumCreditCardAmountWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    float sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.creditCardAmount;
    }
    return sum;
}
    
+(float)getDiscountValueWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        ReportEndDay *reportEndDay = filterArray[0];
        return reportEndDay.discountValue;
    }
    return 0;
}
    
    
+(float)getSumDiscountValueWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    float sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.discountValue;
    }
    return sum;
}

+(float)getSumVatWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    float sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.vat;
    }
    return sum;
}

+(float)getSumRoundWithReportEndDayList:(NSMutableArray *)reportEndDayList
{
    float sum = 0;
    for(ReportEndDay *item in reportEndDayList)
    {
        sum += item.round;
    }
    return sum;
}

+(float)getSumDiscountValueWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.discountValue;
    }
    return sum;
}

+(float)getSumVatWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.vat;
    }
    return sum;
}

+(float)getSumRoundWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTypeID = %ld",customerTypeID];
    NSArray *filterArray = [reportEndDayList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(ReportEndDay *item in filterArray)
    {
        sum += item.round;
    }
    return sum;
}
@end
