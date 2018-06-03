//
//  Discount.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Discount.h"
#import "SharedDiscount.h"
#import "Utility.h"


@implementation Discount

-(Discount *)initWithDiscountAmount:(NSInteger)discountAmount discountType:(NSInteger)discountType remark:(NSString *)remark orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.discountID = [Discount getNextID];
        self.discountAmount = discountAmount;
        self.discountType = discountType;
        self.remark = remark;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"discountID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    
    
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

+(void)addObject:(Discount *)discount
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    [dataList addObject:discount];
}

+(void)removeObject:(Discount *)discount
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    [dataList removeObject:discount];
}

+(void)addList:(NSMutableArray *)discountList
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    [dataList addObjectsFromArray:discountList];
}

+(void)removeList:(NSMutableArray *)discountList
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    [dataList removeObjectsInArray:discountList];
}

+(Discount *)getDiscount:(NSInteger)discountID
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_discountID = %ld",discountID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getDiscountListWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedDiscount sharedDiscount].discountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *sortArray = [self sortList:[filterArray mutableCopy]];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)sortList:(NSMutableArray *)discountList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_discountType" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_discountAmount" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_remark" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3, nil];
    NSArray *sortArray = [discountList sortedArrayUsingDescriptors:sortDescriptors];

    return [sortArray mutableCopy];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Discount *)copy).discountID = self.discountID;
        ((Discount *)copy).discountAmount = self.discountAmount;
        ((Discount *)copy).discountType = self.discountType;
        [copy setRemark:self.remark];
        ((Discount *)copy).orderNo = self.orderNo;
        ((Discount *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((Discount *)copy).replaceSelf = self.replaceSelf;
        ((Discount *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}


@end
