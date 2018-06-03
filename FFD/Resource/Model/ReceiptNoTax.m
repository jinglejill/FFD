//
//  ReceiptNoTax.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptNoTax.h"
#import "SharedReceiptNoTax.h"
#import "Utility.h"


@implementation ReceiptNoTax

-(ReceiptNoTax *)init
{
    self = [super init];
    if(self)
    {
        self.receiptNoTaxID = [ReceiptNoTax getNextID];
        {
            NSRange needleRange = NSMakeRange(0,4);
            self.year = [[self.receiptNoTaxID substringWithRange:needleRange] integerValue];
        }
        {
            NSRange needleRange = NSMakeRange(4,2);
            self.month = [[self.receiptNoTaxID substringWithRange:needleRange] integerValue];
        }
        {
            NSRange needleRange = NSMakeRange(6,6);
            self.runningNo = [[self.receiptNoTaxID substringWithRange:needleRange] integerValue];
        }
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSString *)getNextID//yyyyMM000001
{
    NSString *primaryKeyName = @"receiptNoTaxID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return [NSString stringWithFormat:@"%@%06d",[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"],1];
    }
    else
    {
        ReceiptNoTax *receiptNoTax = dataList[0];
        NSRange needleRange = NSMakeRange(0,6);
        NSString *yearMonth = [receiptNoTax.receiptNoTaxID substringWithRange:needleRange];
        
        if([yearMonth isEqualToString:[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"]])
        {
            return [NSString stringWithFormat:@"%@%06ld",[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"],receiptNoTax.runningNo+1];
        }
        else
        {
            return [NSString stringWithFormat:@"%@%06d",[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"],1] ;
        }
    }
    return @"";
}

+(void)addObject:(ReceiptNoTax *)receiptNoTax
{
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    [dataList addObject:receiptNoTax];
}

+(void)removeObject:(ReceiptNoTax *)receiptNoTax
{
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    [dataList removeObject:receiptNoTax];
}

+(void)addList:(NSMutableArray *)receiptNoTaxList
{
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    [dataList addObjectsFromArray:receiptNoTaxList];
}

+(void)removeList:(NSMutableArray *)receiptNoTaxList
{
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    [dataList removeObjectsInArray:receiptNoTaxList];
}

+(ReceiptNoTax *)getReceiptNoTax:(NSInteger)receiptNoTaxID
{
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptNoTaxID = %ld",receiptNoTaxID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)makeFormatedReceiptNoTaxWithReceiptNoTaxID:(NSString *)receiptNoTaxID
{
    NSString *yearMonth = @"";
    NSString *runningNo = @"";
    {
        NSRange needleRange = NSMakeRange(2,4);
        yearMonth = [receiptNoTaxID substringWithRange:needleRange];
    }
    {
        NSRange needleRange = NSMakeRange(6,6);
        runningNo = [receiptNoTaxID substringWithRange:needleRange];
    }
    return [NSString stringWithFormat:@"TI%@/%@",yearMonth,runningNo];
}

+(NSInteger)getReceiptNoTaxCountToday
{
    NSDate *startDate = [Utility currentDateTime];
    NSDate *endDate = [Utility currentDateTime];
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    
    NSMutableArray *dataList = [SharedReceiptNoTax sharedReceiptNoTax].receiptNoTaxList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_modifiedDate BETWEEN %@", [NSArray arrayWithObjects:startDate, endDate, nil]];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray count];
}
@end
