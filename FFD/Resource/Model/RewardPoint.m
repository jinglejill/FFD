//
//  RewardPoint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "RewardPoint.h"
#import "SharedRewardPoint.h"
#import "Utility.h"


@implementation RewardPoint

-(RewardPoint *)initWithMemberID:(NSInteger)memberID receiptID:(NSInteger)receiptID point:(float)point status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.rewardPointID = [RewardPoint getNextID];
        self.memberID = memberID;
        self.receiptID = receiptID;
        self.point = point;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}
+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"rewardPointID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    
    
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
//    NSString *primaryKeyName = @"rewardPointID";
//    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
//    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
//    
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
//    dataList = [sortArray mutableCopy];
//    
//    if([dataList count] == 0)
//    {
//        return 1;
//    }
//    else
//    {
//        id value = [dataList[0] valueForKey:primaryKeyName];
//        NSString *strMaxID = value;
//        
//        return [strMaxID intValue]+1;
//    }
//}

+(void)addObject:(RewardPoint *)rewardPoint
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList addObject:rewardPoint];
}

+(void)removeObject:(RewardPoint *)rewardPoint
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList removeObject:rewardPoint];
}

+(void)addList:(NSMutableArray *)rewardPointList
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList addObjectsFromArray:rewardPointList];
}

+(void)removeList:(NSMutableArray *)rewardPointList
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList removeObjectsInArray:rewardPointList];
}

+(RewardPoint *)getRewardPoint:(NSInteger)rewardPointID
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_rewardPointID = %ld",rewardPointID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSInteger)getTotalPointWithMemberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    float sum = 0;
    for(RewardPoint *item in filterArray)
    {
        sum += item.point*item.status;
    }
    return (long)sum;
}

+(RewardPoint *)getRewardPointWithReceiptID:(NSInteger)receiptID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and _status = %ld",receiptID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

@end
