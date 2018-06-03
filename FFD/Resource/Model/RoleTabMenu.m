//
//  RoleTabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RoleTabMenu.h"
#import "SharedRoleTabMenu.h"
#import "TabMenu.h"
#import "Utility.h"


@implementation RoleTabMenu

-(RoleTabMenu *)initWithRoleID:(NSInteger)roleID tabMenuID:(NSInteger)tabMenuID
{
    self = [super init];
    if(self)
    {
        self.roleTabMenuID = [RoleTabMenu getNextID];
        self.roleID = roleID;
        self.tabMenuID = tabMenuID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"roleTabMenuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    
    
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

+(void)addObject:(RoleTabMenu *)roleTabMenu
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    [dataList addObject:roleTabMenu];
}

+(void)removeObject:(RoleTabMenu *)roleTabMenu
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    [dataList removeObject:roleTabMenu];
}

+(void)addList:(NSMutableArray *)roleTabMenuList
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    [dataList addObjectsFromArray:roleTabMenuList];
}

+(void)removeList:(NSMutableArray *)roleTabMenuList
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    [dataList removeObjectsInArray:roleTabMenuList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((RoleTabMenu *)copy).roleTabMenuID = self.roleTabMenuID;
        ((RoleTabMenu *)copy).roleID = self.roleID;
        ((RoleTabMenu *)copy).tabMenuID = self.tabMenuID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((RoleTabMenu *)copy).replaceSelf = self.replaceSelf;
        ((RoleTabMenu *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}


+(RoleTabMenu *)getRoleTabMenu:(NSInteger)roleTabMenuID
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_roleTabMenuID = %ld",roleTabMenuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)createRoleTabMenuListWithRoleID:(NSInteger)roleID tabMenuType:(NSInteger)tabMenuType
{
    NSMutableArray *tabMenuList = [TabMenu getTabMenuListWithType:tabMenuType];
    NSMutableArray *roleTabMenuList = [[NSMutableArray alloc]init];
    for(TabMenu *item in tabMenuList)
    {
        RoleTabMenu *roleTabMenu = [[RoleTabMenu alloc]initWithRoleID:roleID tabMenuID:item.tabMenuID];
        [roleTabMenuList addObject:roleTabMenu];
        [RoleTabMenu addObject:roleTabMenu];
    }
    
    return roleTabMenuList;
}

+(NSMutableArray *)getRoleTabMenuListWithRoleID:(NSInteger)roleID tabMenuType:(NSInteger)tabMenuType
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_roleID = %ld",roleID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *roleTabMenuList = [[NSMutableArray alloc]init];
    for(RoleTabMenu *item in filterArray)
    {
        TabMenu *tabMenu = [TabMenu getTabMenu:item.tabMenuID];
        if(tabMenu.type == tabMenuType)
        {
            [roleTabMenuList addObject:item];
        }
    }
    
    return roleTabMenuList;
}

+(RoleTabMenu *)getRoleTabMenuWithRoleID:(NSInteger)roleID tabMenuID:(NSInteger)tabMenuID
{
    NSMutableArray *dataList = [SharedRoleTabMenu sharedRoleTabMenu].roleTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_roleID = %ld and tabMenuID = %ld",roleID,tabMenuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}
@end
