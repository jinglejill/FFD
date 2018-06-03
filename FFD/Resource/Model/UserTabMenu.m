//
//  UserTabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "UserTabMenu.h"
#import "SharedUserTabMenu.h"
#import "Utility.h"


@implementation UserTabMenu

-(UserTabMenu *)initWithUserAccountID:(NSInteger)userAccountID tabMenuID:(NSInteger)tabMenuID
{
    self = [super init];
    if(self)
    {
        self.userTabMenuID = [UserTabMenu getNextID];
        self.userAccountID = userAccountID;
        self.tabMenuID = tabMenuID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"userTabMenuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    
    
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

+(void)addObject:(UserTabMenu *)userTabMenu
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    [dataList addObject:userTabMenu];
}

+(void)removeObject:(UserTabMenu *)userTabMenu
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    [dataList removeObject:userTabMenu];
}

+(void)addList:(NSMutableArray *)userTabMenuList
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    [dataList addObjectsFromArray:userTabMenuList];
}

+(void)removeList:(NSMutableArray *)userTabMenuList
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    [dataList removeObjectsInArray:userTabMenuList];
}

+(UserTabMenu *)getUserTabMenu:(NSInteger)userTabMenuID
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userTabMenuID = %ld",userTabMenuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getUserTabMenuListWithUserAccountID:(NSInteger)userAccountID
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userAccountID = %ld",userAccountID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(UserTabMenu *)getUserTabMenuWithUserAccountID:(NSInteger)userAccountID tabMenuID:(NSInteger)tabMenuID
{
    NSMutableArray *dataList = [SharedUserTabMenu sharedUserTabMenu].userTabMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userAccountID = %ld and _tabMenuID = %ld",userAccountID,tabMenuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}



@end
