//
//  CustomerTable.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomerTable.h"
#import "SharedCustomerTable.h"
#import "Utility.h"


@implementation CustomerTable

-(CustomerTable *)initWithTableName:(NSString *)tableName type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.customerTableID = [CustomerTable getNextID];
        self.tableName = tableName;
        self.type = type;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    strNameID = @"customerTableID";
    
    NSString *strSortID = [NSString stringWithFormat:@"_%@",strNameID];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:strSortID ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else;
    {
        id value = [dataList[0] valueForKey:strNameID];
        NSString *strMaxID = value;
        
        return [strMaxID intValue]+1;
    }
}

+(void)addObject:(CustomerTable *)customerTable
{
    NSMutableArray *dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    [dataList addObject:customerTable];
}

+(CustomerTable *)getCustomerTable:(NSInteger)customerTableID
{
    NSMutableArray *dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld",customerTableID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getCustomerTableListWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(CustomerTable *)getCustomerTableWithTableName:(NSString *)tableName status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_tableName = %@ and _status = %ld",tableName,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}
@end
