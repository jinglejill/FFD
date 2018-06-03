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

-(CustomerTable *)initWithTableName:(NSString *)tableName type:(NSInteger)type color:(NSString *)color zone:(NSString *)zone orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.customerTableID = [CustomerTable getNextID];
        self.tableName = tableName;
        self.type = type;
        self.color = color;
        self.zone = zone;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"customerTableID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedCustomerTable sharedCustomerTable].customerTableList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
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
    
    return [self sortList:[filterArray mutableCopy]];
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

+(NSInteger)getSelectedIndexWithCustomerTableList:(NSMutableArray *)customerTableList customerTableID:(NSInteger)customerTableID
{
    for(int i=0; i<[customerTableList count]; i++)
    {
        CustomerTable *customerTable = customerTableList[i];
        if(customerTable.customerTableID == customerTableID)
        {
            return i;
        }
    }
    return 0;
}

+(NSString *)getTableNameListInTextWithCustomerTableList:(NSMutableArray *)customerTableList
{
    NSMutableArray *sortCustomerTableList = [[NSMutableArray alloc]init];
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_zone = 'A' or _zone = 'B' or _zone = 'C' or _zone = 'T'"];
        NSArray *filterArray = [customerTableList filteredArrayUsingPredicate:predicate];
        
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_zone" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
        NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
        [sortCustomerTableList addObjectsFromArray:sortArray];
    }
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_zone = 'D'"];
        NSArray *filterArray = [customerTableList filteredArrayUsingPredicate:predicate];
        
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_zone" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
        NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
        [sortCustomerTableList addObjectsFromArray:sortArray];
    }
    
    
    
    int i=0;
    NSString *tableNameListInText;
    for(CustomerTable *item in sortCustomerTableList)
    {
        if(i == 0)
        {
            tableNameListInText = [NSString stringWithFormat:@"%@",item.tableName];
        }
        else
        {
            tableNameListInText = [NSString stringWithFormat:@"%@,%@",tableNameListInText,item.tableName];
        }
        i++;
    }
    return tableNameListInText;
}

+(NSMutableArray *)getCustomerTableListWithCustomerTableIDList:(NSArray*)customerTableIDList
{
    NSMutableArray *customerTableList = [[NSMutableArray alloc]init];
    for(NSNumber *item in customerTableIDList)
    {
        CustomerTable *customerTable = [CustomerTable getCustomerTable:[item integerValue]];
        [customerTableList addObject:customerTable];
    }
    
    return [self sortList:customerTableList];
}

+(NSMutableArray *)sortList:(NSMutableArray *)customerTableList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_zone" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3, nil];
    NSArray *sortArray = [customerTableList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end
