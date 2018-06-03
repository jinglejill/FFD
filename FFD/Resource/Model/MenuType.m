//
//  MenuType.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MenuType.h"
#import "SharedMenuType.h"
#import "Utility.h"


@implementation MenuType

-(MenuType *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.menuTypeID = [MenuType getNextID];
        self.name = name;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedMenuType sharedMenuType].menuTypeList;
    strNameID = @"menuTypeID";
    
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

+(void)addObject:(MenuType *)menuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList addObject:menuType];
}

+(MenuType *)getMenuType:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuTypeListWithStatus:(NSInteger)status;
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}
@end
