//
//  MoneyCheck.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MoneyCheck.h"
#import "SharedMoneyCheck.h"
#import "Utility.h"


@implementation MoneyCheck

-(MoneyCheck *)initWithType:(NSInteger)type method:(NSInteger)method amount:(float)amount status:(NSInteger)status checkUser:(NSString *)checkUser checkDate:(NSDate *)checkDate
{
    self = [super init];
    if(self)
    {
        self.moneyCheckID = [MoneyCheck getNextID];
        self.type = type;
        self.method = method;
        self.amount = amount;
        self.status = status;
        self.checkUser = checkUser;
        self.checkDate = checkDate;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"moneyCheckID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    
    
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

+(void)addObject:(MoneyCheck *)moneyCheck
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    [dataList addObject:moneyCheck];
}

+(void)removeObject:(MoneyCheck *)moneyCheck
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    [dataList removeObject:moneyCheck];
}

+(void)addList:(NSMutableArray *)moneyCheckList
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    [dataList addObjectsFromArray:moneyCheckList];
}

+(void)removeList:(NSMutableArray *)moneyCheckList
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    [dataList removeObjectsInArray:moneyCheckList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((MoneyCheck *)copy).moneyCheckID = self.moneyCheckID;
        ((MoneyCheck *)copy).type = self.type;
        ((MoneyCheck *)copy).method = self.method;
        ((MoneyCheck *)copy).amount = self.amount;
        ((MoneyCheck *)copy).status = self.status;
        [copy setCheckUser:self.checkUser];
        [copy setCheckDate:self.checkDate];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((MoneyCheck *)copy).replaceSelf = self.replaceSelf;
        ((MoneyCheck *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(MoneyCheck *)getMoneyCheck:(NSInteger)moneyCheckID
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_moneyCheckID = %ld",moneyCheckID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMoneyCheckListWithType:(NSInteger)type checkDateStart:(NSDate *)startDate checkDateEnd:(NSDate *)endDate
{
    NSMutableArray *dataList = [SharedMoneyCheck sharedMoneyCheck].moneyCheckList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_type = %ld and (_checkDate >= %@ and _checkDate <= %@)",type,startDate,endDate];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
