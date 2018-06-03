//
//  ReceiptNo.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptNo.h"
#import "SharedReceiptNo.h"
#import "Utility.h"


@implementation ReceiptNo

//-(ReceiptNo *)init
//{
//    self = [super init];
//    if(self)
//    {
//        self.receiptNoID = [ReceiptNo getNextID];
//        {
//            NSRange needleRange = NSMakeRange(0,4);
//            self.year = [[self.receiptNoID substringWithRange:needleRange] integerValue];
//        }
//        {
//            NSRange needleRange = NSMakeRange(4,2);
//            self.month = [[self.receiptNoID substringWithRange:needleRange] integerValue];
//        }
//        {
//            NSRange needleRange = NSMakeRange(6,6);
//            self.runningNo = [[self.receiptNoID substringWithRange:needleRange] integerValue];
//        }
//        self.modifiedUser = [Utility modifiedUser];
//        self.modifiedDate = [Utility currentDateTime];
//    }
//    return self;
//}

+(NSString *)getNextID//yyyyMM000001
{
    NSString *primaryKeyName = @"receiptNoID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    
    
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
        ReceiptNo *receiptNo = dataList[0];
        NSRange needleRange = NSMakeRange(0,6);
        NSString *yearMonth = [receiptNo.receiptNoID substringWithRange:needleRange];
        
        if([yearMonth isEqualToString:[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"]])
        {
            return [NSString stringWithFormat:@"%@%06ld",[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"],receiptNo.runningNo+1];
        }
        else
        {
            return [NSString stringWithFormat:@"%@%06d",[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMM"],1];
        }
    }
    return @"";
}

+(void)addObject:(ReceiptNo *)receiptNo
{
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    [dataList addObject:receiptNo];
}

+(void)removeObject:(ReceiptNo *)receiptNo
{
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    [dataList removeObject:receiptNo];
}

+(void)addList:(NSMutableArray *)receiptNoList
{
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    [dataList addObjectsFromArray:receiptNoList];
}

+(void)removeList:(NSMutableArray *)receiptNoList
{
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    [dataList removeObjectsInArray:receiptNoList];
}

+(ReceiptNo *)getReceiptNo:(NSInteger)receiptNoID
{
    NSMutableArray *dataList = [SharedReceiptNo sharedReceiptNo].receiptNoList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptNoID = %ld",receiptNoID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)makeFormatedReceiptNoWithReceiptNoID:(NSString *)receiptNoID
{
    if([receiptNoID isEqualToString:@""])
    {
        return @"";
    }
    if([receiptNoID length] == 8)
    {
        return receiptNoID;
    }
    
    NSString *yearMonth = @"";
    NSString *runningNo = @"";
    {
        NSRange needleRange = NSMakeRange(2,4);
        yearMonth = [receiptNoID substringWithRange:needleRange];
    }
    {
        NSRange needleRange = NSMakeRange(6,6);
        runningNo = [receiptNoID substringWithRange:needleRange];
    }
    return [NSString stringWithFormat:@"T%@/%@",yearMonth,runningNo];
}

@end
