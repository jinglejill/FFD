//
//  OrderKitchen.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderKitchen.h"
#import "SharedOrderKitchen.h"
#import "Utility.h"


@implementation OrderKitchen

-(OrderKitchen *)initWithCustomerTableID:(NSInteger)customerTableID orderTakingID:(NSInteger)orderTakingID sequenceNo:(NSInteger)sequenceNo
{
    self = [super init];
    if(self)
    {
        self.orderKitchenID = [OrderKitchen getNextID];
        self.customerTableID = customerTableID;
        self.orderTakingID = orderTakingID;
        self.sequenceNo = sequenceNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    strNameID = @"orderKitchenID";
    
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

+(void)addObject:(OrderKitchen *)orderKitchen
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList addObject:orderKitchen];
}

+(void)removeObject:(OrderKitchen *)orderKitchen
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList removeObject:orderKitchen];
}

+(OrderKitchen *)getOrderKitchen:(NSInteger)orderKitchenID
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderKitchenID = %ld",orderKitchenID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSInteger)getNextSequenceNo
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    NSString *strNameID = @"orderKitchenID";
    
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



@end
