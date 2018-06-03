//
//  ReceiptCustomerTable.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptCustomerTable.h"
#import "SharedReceiptCustomerTable.h"
#import "Utility.h"
#import "CustomerTable.h"
#import "Receipt.h"


@implementation ReceiptCustomerTable

-(ReceiptCustomerTable *)initWithMergeReceiptID:(NSInteger)mergeReceiptID receiptID:(NSInteger)receiptID customerTableID:(NSInteger)customerTableID
{
    self = [super init];
    if(self)
    {
        self.receiptCustomerTableID = [ReceiptCustomerTable getNextID];
        self.mergeReceiptID = mergeReceiptID;
        self.receiptID = receiptID;
        self.customerTableID = customerTableID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"receiptCustomerTableID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
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

+(void)addObject:(ReceiptCustomerTable *)receiptCustomerTable
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    [dataList addObject:receiptCustomerTable];
}

+(void)removeObject:(ReceiptCustomerTable *)receiptCustomerTable
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    [dataList removeObject:receiptCustomerTable];
}

+(void)addList:(NSMutableArray *)receiptCustomerTableList
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    [dataList addObjectsFromArray:receiptCustomerTableList];
}

+(void)removeList:(NSMutableArray *)receiptCustomerTableList
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    [dataList removeObjectsInArray:receiptCustomerTableList];
}

+(ReceiptCustomerTable *)getReceiptCustomerTable:(NSInteger)receiptCustomerTableID
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptCustomerTableID = %ld",receiptCustomerTableID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getReceiptCustomerTableListWithMergeReceiptID:(NSInteger)mergeReceiptID
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_mergeReceiptID = %ld",mergeReceiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getCustomerTableListWithMergeReceiptID:(NSInteger)mergeReceiptID
{
    NSMutableArray *customerTableList = [[NSMutableArray alloc]init];
    NSMutableArray *receiptCustomerTableList = [self getReceiptCustomerTableListWithMergeReceiptID:mergeReceiptID];
    for(ReceiptCustomerTable *item in receiptCustomerTableList)
    {
        CustomerTable *customerTable = [CustomerTable getCustomerTable:item.customerTableID];
        [customerTableList addObject:customerTable];
    }
    
    return customerTableList;
}

+(NSMutableArray *)getReceiptListWithMergeReceiptID:(NSInteger)mergeReceiptID
{
    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
    NSMutableArray *receiptCustomerTableList = [self getReceiptCustomerTableListWithMergeReceiptID:mergeReceiptID];
    for(ReceiptCustomerTable *item in receiptCustomerTableList)
    {
        Receipt *receipt = [Receipt getReceiptWithCustomerTableID:item.customerTableID status:1];
        [receiptList addObject:receipt];
    }
    return receiptList;
}

+(ReceiptCustomerTable *)getReceiptCustomerTableWithReceiptID:(NSInteger)receiptID customerTableID:(NSInteger)customerTableID
{
    NSMutableArray *dataList = [SharedReceiptCustomerTable sharedReceiptCustomerTable].receiptCustomerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and _customerTableID = %ld",receiptID,customerTableID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

@end
