//
//  BillPrint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/14/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "BillPrint.h"
#import "SharedBillPrint.h"
#import "Utility.h"


@implementation BillPrint

-(BillPrint *)initWithReceiptID:(NSInteger)receiptID billPrintDate:(NSDate *)billPrintDate
{
    self = [super init];
    if(self)
    {
        self.billPrintID = [BillPrint getNextID];
        self.receiptID = receiptID;
        self.billPrintDate = billPrintDate;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"billPrintID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(BillPrint *)billPrint
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    [dataList addObject:billPrint];
}

+(void)removeObject:(BillPrint *)billPrint
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    [dataList removeObject:billPrint];
}

+(void)addList:(NSMutableArray *)billPrintList
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    [dataList addObjectsFromArray:billPrintList];
}

+(void)removeList:(NSMutableArray *)billPrintList
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    [dataList removeObjectsInArray:billPrintList];
}

+(BillPrint *)getBillPrint:(NSInteger)billPrintID
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_billPrintID = %ld",billPrintID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getBillPrintListWithReceiptID:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedBillPrint sharedBillPrint].billPrintList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortListByBillPrintDateDesc:(NSMutableArray *)billPrintList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_billPrintDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [billPrintList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end
