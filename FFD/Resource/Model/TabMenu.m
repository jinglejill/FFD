//
//  TabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "TabMenu.h"
#import "SharedTabMenu.h"
#import "Utility.h"


@implementation TabMenu

-(TabMenu *)initWithName:(NSString *)name type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.tabMenuID = [TabMenu getNextID];
        self.name = name;
        self.type = type;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"tabMenuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    
    
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

+(void)addObject:(TabMenu *)tabMenu
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    [dataList addObject:tabMenu];
}

+(void)removeObject:(TabMenu *)tabMenu
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    [dataList removeObject:tabMenu];
}

+(void)addList:(NSMutableArray *)tabMenuList
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    [dataList addObjectsFromArray:tabMenuList];
}

+(void)removeList:(NSMutableArray *)tabMenuList
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    [dataList removeObjectsInArray:tabMenuList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((TabMenu *)copy).tabMenuID = self.tabMenuID;
        [copy setName:self.name];
        ((TabMenu *)copy).type = self.type;
        ((TabMenu *)copy).orderNo = self.orderNo;
        ((TabMenu *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((TabMenu *)copy).replaceSelf = self.replaceSelf;
        ((TabMenu *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(TabMenu *)getTabMenu:(NSInteger)tabMenuID
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_tabMenuID = %ld",tabMenuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getTabMenuListWithType:(NSInteger)type
{
    NSMutableArray *dataList = [SharedTabMenu sharedTabMenu].tabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_type = %ld",type];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
