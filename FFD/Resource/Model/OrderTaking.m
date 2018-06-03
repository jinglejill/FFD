//
//  OrderTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderTaking.h"
#import "SharedOrderTaking.h"
#import "OrderNote.h"
#import "Menu.h"
#import "Utility.h"


@implementation OrderTaking

-(OrderTaking *)initWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText orderNo:(NSInteger)orderNo status:(NSInteger)status receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.orderTakingID = [OrderTaking getNextID];
        self.customerTableID = customerTableID;
        self.menuID = menuID;
        self.quantity = quantity;
        self.specialPrice = specialPrice;
        self.price = price;
        self.takeAway = takeAway;
        self.noteIDListInText = noteIDListInText;
        self.orderNo = orderNo;
        self.status = status;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
        
        
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    strNameID = @"orderTakingID";
    
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

+(void)addObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList addObject:orderTaking];
}

+(void)removeObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObject:orderTaking];
}

+(void)removeList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObjectsInArray:orderTakingList];
}

+(OrderTaking *)getOrderTaking:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText status:(NSInteger)status;
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _menuID = %ld and _takeAway = %ld and _noteIDListInText = %@ and _status = %ld",customerTableID,menuID,takeAway,noteIDListInText,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld",customerTableID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListOccupyWithCustomerTableID:(NSInteger)customerTableID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and (_status = 1 or _status = 2)",customerTableID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(NSInteger)getTotalQuantity:(NSMutableArray *)orderTakingList
{
    NSInteger sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity;
    }
    return sum;
}

+(NSInteger)getTotalAmount:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity*item.price;
    }
    return sum;
}

- (id)copyWithZone:(NSZone *)zone
{
    // Copying code here.
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Copy NSObject subclasses
        ((OrderTaking *)copy).orderTakingID = self.orderTakingID;
        ((OrderTaking *)copy).customerTableID = self.orderTakingID;
        ((OrderTaking *)copy).menuID = self.orderTakingID;
        ((OrderTaking *)copy).quantity = self.orderTakingID;
        ((OrderTaking *)copy).specialPrice = self.orderTakingID;
        ((OrderTaking *)copy).price = self.orderTakingID;
        ((OrderTaking *)copy).takeAway = self.orderTakingID;
        [copy setNoteIDListInText:[self.noteIDListInText copyWithZone:zone]];
        ((OrderTaking *)copy).orderNo = self.orderNo;
        ((OrderTaking *)copy).status = self.status;
        ((OrderTaking *)copy).receiptID = self.receiptID;
        [copy setModifiedDate:[self.modifiedUser copyWithZone:zone]];
        [copy setModifiedDate:[self.modifiedDate copyWithZone:zone]];
        ((OrderTaking *)copy).replaceSelf = self.replaceSelf;
        ((OrderTaking *)copy).idInserted = self.idInserted;
        ((OrderTaking *)copy).menuOrderNo = self.menuOrderNo;
    }
    
    return copy;
}

@end
