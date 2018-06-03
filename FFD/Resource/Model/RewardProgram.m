//
//  RewardProgram.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/5/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "RewardProgram.h"
#import "SharedRewardProgram.h"
#import "Utility.h"


@implementation RewardProgram

-(RewardProgram *)initWithType:(NSInteger)type startDate:(NSDate *)startDate endDate:(NSDate *)endDate salesSpent:(NSInteger)salesSpent receivePoint:(float)receivePoint pointSpent:(NSInteger)pointSpent discountType:(NSInteger)discountType discountAmount:(float)discountAmount
{
    self = [super init];
    if(self)
    {
        self.rewardProgramID = [RewardProgram getNextID];
        self.type = type;
        self.startDate = startDate;
        self.endDate = endDate;
        self.salesSpent = salesSpent;
        self.receivePoint = receivePoint;
        self.pointSpent = pointSpent;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"rewardProgramID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    
    
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

+(void)addObject:(RewardProgram *)rewardProgram
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    [dataList addObject:rewardProgram];
}

+(void)removeObject:(RewardProgram *)rewardProgram
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    [dataList removeObject:rewardProgram];
}

+(void)addList:(NSMutableArray *)rewardProgramList
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    [dataList addObjectsFromArray:rewardProgramList];
}

+(void)removeList:(NSMutableArray *)rewardProgramList
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    [dataList removeObjectsInArray:rewardProgramList];
}

+(RewardProgram *)getRewardProgram:(NSInteger)rewardProgramID
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_rewardProgramID = %ld",rewardProgramID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(RewardProgram *)getRewardProgramCollectToday
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[Utility currentDateTime] options:0];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_type = 1 and _startDate <= %@ and _endDate >= %@",today,today];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
        NSArray *sortDescriptors1 = [NSArray arrayWithObjects:sortDescriptor, nil];
        NSArray *sortedArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors1];
        
        return sortedArray[0];
    }
    return nil;
}

+(NSMutableArray *)getRewardProgramUseListToday
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[Utility currentDateTime] options:0];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_type = -1 and _startDate <= %@ and _endDate >= %@",today,today];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_discountType" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_pointSpent" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_discountAmount" ascending:NO];
    NSArray *sortDescriptors1 = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3, nil];
    NSArray *sortedArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors1];
    

    return [sortedArray mutableCopy];
}

+(NSInteger)getSelectedIndexWithRewardProgramList:(NSMutableArray *)rewardProgramList pointSpent:(NSInteger)pointSpent discountType:(NSInteger)discountType discountAmount:(float)discountAmount
{
    for(int i=0; i<[rewardProgramList count]; i++)
    {
        RewardProgram *rewardProgram = rewardProgramList[i];
        if(rewardProgram.pointSpent == pointSpent && rewardProgram.discountType == discountType && rewardProgram.discountAmount == discountAmount)
        {
            return i;
        }
    }
    return 0;
}

+(NSMutableArray *)getRewardProgramListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate type:(NSInteger)type
{
    NSMutableArray *dataList = [SharedRewardProgram sharedRewardProgram].rewardProgramList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((_endDate >= %@ and _startDate <= %@) or (_startDate <= %@ and _endDate >= %@)) and _type = %ld",startDate,endDate,endDate,startDate,type];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [self sortList:[filterArray mutableCopy]];
}

+(NSMutableArray *)sortList:(NSMutableArray *)rewardProgramList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_startDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_endDate" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_salesSpent" ascending:YES];
    NSSortDescriptor *sortDescriptor5 = [[NSSortDescriptor alloc] initWithKey:@"_receivePoint" ascending:YES];
    NSSortDescriptor *sortDescriptor6 = [[NSSortDescriptor alloc] initWithKey:@"_pointSpent" ascending:YES];
    NSSortDescriptor *sortDescriptor7 = [[NSSortDescriptor alloc] initWithKey:@"_discountType" ascending:YES];
    NSSortDescriptor *sortDescriptor8 = [[NSSortDescriptor alloc] initWithKey:@"_discountAmount" ascending:YES];
    NSArray *sortDescriptors1 = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,sortDescriptor5,sortDescriptor6,sortDescriptor7,sortDescriptor8, nil];
    NSArray *sortedArray = [rewardProgramList sortedArrayUsingDescriptors:sortDescriptors1];
    
    return [sortedArray mutableCopy];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((RewardProgram *)copy).rewardProgramID = self.rewardProgramID;
        ((RewardProgram *)copy).type = self.type;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        ((RewardProgram *)copy).salesSpent = self.salesSpent;
        ((RewardProgram *)copy).receivePoint = self.receivePoint;
        ((RewardProgram *)copy).pointSpent = self.pointSpent;
        ((RewardProgram *)copy).discountType = self.discountType;
        ((RewardProgram *)copy).discountAmount = self.discountAmount;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((RewardProgram *)copy).replaceSelf = self.replaceSelf;
        ((RewardProgram *)copy).idInserted = self.idInserted;
    }
    
    return self;
}
@end
