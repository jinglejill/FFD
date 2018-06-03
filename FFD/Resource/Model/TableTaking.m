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


@implementation TableTaking

-(TableTaking *)initWithCustomerTableID:(NSInteger)customerTableID servingPerson:(NSInteger)servingPerson status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.tableTakingID = [TableTaking getNextID];
        self.customerTableID = customerTableID;
        self.servingPerson = servingPerson;
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
    dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    strNameID = @"tableTakingID";
    
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

+(TableTaking *)getTableTakingWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedTableTaking sharedTableTaking].tableTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld",customerTableID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}


@end
