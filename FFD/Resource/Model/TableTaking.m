//
//  TableTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "TableTaking.h"
#import "SharedTableTaking.h"
#import "Utility.h"
#import "CustomerTable.h"


@implementation TableTaking

-(TableTaking *)initWithCustomerTableID:(NSInteger)customerTableID servingPerson:(NSInteger)servingPerson receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.tableTakingID = [TableTaking getNextID];
        self.customerTableID = customerTableID;
        self.servingPerson = servingPerson;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}
+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"tableTakingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    
    
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
//+(NSInteger)getNextID
//{
//    NSString *primaryKeyName = @"tableTakingID";
//    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
//    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
//    
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
//    dataList = [sortArray mutableCopy];
//    
//    if([dataList count] == 0)
//    {
//        return -1;
//    }
//    else
//    {
//        id value = [dataList[0] valueForKey:primaryKeyName];
//        if([value integerValue]>0)
//        {
//            return -1;
//        }
//        else
//        {
//            return [value integerValue]-1;
//        }
//    }
//}


+(void)addObject:(TableTaking *)tableTaking
{
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    [dataList addObject:tableTaking];
}

+(void)removeObject:(TableTaking *)tableTaking
{
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    [dataList removeObject:tableTaking];
}

+(TableTaking *)getTableTaking:(NSInteger)tableTakingID
{
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_tableTakingID = %ld",tableTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(TableTaking *)getTableTakingWithCustomerTableID:(NSInteger)customerTableID receiptID:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _receiptID = %ld",customerTableID,receiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
    if([sortArray count] > 0)
    {
        return sortArray[0];
    }
    return nil;
}

+(NSMutableArray *)getTableTakingListWithCustomerTableList:(NSMutableArray *)customerTableList receiptID:(NSInteger)receiptID
{
    NSMutableArray *tableTakingList = [[NSMutableArray alloc]init];
    for(CustomerTable *item in customerTableList)
    {
        TableTaking *tableTaking = [self getTableTakingWithCustomerTableID:item.customerTableID receiptID:0];
        [tableTakingList addObject:tableTaking];
    }
    return tableTakingList;
}

+(NSInteger)getSumServingPersonWithCustomerTableList:(NSMutableArray *)customerTableList receiptID:(NSInteger)receiptID
{
    NSInteger sum = 0;
    for(CustomerTable *item in customerTableList)
    {
        TableTaking *tableTaking = [self getTableTakingWithCustomerTableID:item.customerTableID receiptID:0];
        sum += tableTaking.servingPerson;
    }
    return sum;
}
@end
