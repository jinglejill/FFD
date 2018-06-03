//
//  OrderCancelDiscount.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "OrderCancelDiscount.h"
#import "SharedOrderCancelDiscount.h"
#import "Utility.h"
#import "OrderTaking.h"


@implementation OrderCancelDiscount

-(OrderCancelDiscount *)initWithOrderTakingID:(NSInteger)orderTakingID type:(NSInteger)type discountType:(NSInteger)discountType discountAmount:(float)discountAmount reason:(NSString *)reason
{
    self = [super init];
    if(self)
    {
        self.orderCancelDiscountID = [OrderCancelDiscount getNextID];
        self.orderTakingID = orderTakingID;
        self.type = type;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.reason = reason;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"orderCancelDiscountID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    
    
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

+(void)addObject:(OrderCancelDiscount *)orderCancelDiscount
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    [dataList addObject:orderCancelDiscount];
}

+(void)removeObject:(OrderCancelDiscount *)orderCancelDiscount
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    [dataList removeObject:orderCancelDiscount];
}

+(void)addList:(NSMutableArray *)orderCancelDiscountList
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    [dataList addObjectsFromArray:orderCancelDiscountList];
}

+(void)removeList:(NSMutableArray *)orderCancelDiscountList
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    [dataList removeObjectsInArray:orderCancelDiscountList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((OrderCancelDiscount *)copy).orderCancelDiscountID = self.orderCancelDiscountID;
        ((OrderCancelDiscount *)copy).orderTakingID = self.orderTakingID;
        ((OrderCancelDiscount *)copy).type = self.type;
        ((OrderCancelDiscount *)copy).discountType = self.discountType;
        ((OrderCancelDiscount *)copy).discountAmount = self.discountAmount;
        [copy setReason:self.reason];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((OrderCancelDiscount *)copy).replaceSelf = self.replaceSelf;
        ((OrderCancelDiscount *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}


+(OrderCancelDiscount *)getOrderCancelDiscount:(NSInteger)orderCancelDiscountID
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderCancelDiscountID = %ld",orderCancelDiscountID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(OrderCancelDiscount *)getOrderCancelDiscountWithOrderTakingID:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderCancelDiscount sharedOrderCancelDiscount].orderCancelDiscountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getOrderCancelDiscountListWithOrderTaking:(OrderTaking *)orderTaking
{
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:orderTaking.customerTableID status:orderTaking.status takeAway:orderTaking.takeAway menuID:orderTaking.menuID noteIDListInText:orderTaking.noteIDListInText specialPrice:orderTaking.specialPrice cancelDiscountReason:orderTaking.cancelDiscountReason];
    NSMutableArray *orderCancelDiscountList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in orderTakingList)
    {
        OrderCancelDiscount *orderCancelDiscount = [self getOrderCancelDiscountWithOrderTakingID:item.orderTakingID];
        if(orderCancelDiscount)
        {
            [orderCancelDiscountList addObject:orderCancelDiscount];
        }
        else
        {
            break;
        }
    }
    return orderCancelDiscountList;
}
@end
