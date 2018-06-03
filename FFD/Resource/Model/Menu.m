//
//  Menu.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Menu.h"
#import "SharedMenu.h"
#import "Utility.h"


@implementation Menu

-(Menu *)initWithTitleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.menuID = [Menu getNextID];
        self.titleThai = titleThai;
        self.price = price;
        self.menuTypeID = menuTypeID;
        self.orderNo = orderNo;
        self.status = status;
        self.remark = remark;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedMenu sharedMenu].menuList;
    strNameID = @"menuID";
    
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

+(void)addObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObject:menu];
}

+(Menu *)getMenu:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status;
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _status = %ld",menuTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(NSMutableArray *)reorganizeToTwoColumn:(NSMutableArray *)menuList
{
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    for(int i=0; i<ceil([menuList count]/2.0); i++)
    {
        [dataList addObject:menuList[i]];
        
        
        NSInteger rightColumnDataIndex = ceil([menuList count]/2.0)+i;
        if(rightColumnDataIndex < [menuList count])
        {
            [dataList addObject:menuList[rightColumnDataIndex]];
        }
    }
    
    return dataList;
}
@end
