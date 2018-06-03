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

-(Menu *)initWithMenuCode:(NSString *)menuCode titleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID subMenuType2ID:(NSInteger)subMenuType2ID subMenuType3ID:(NSInteger)subMenuType3ID color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.menuID = [Menu getNextID];
        self.menuCode = menuCode;
        self.titleThai = titleThai;
        self.price = price;
        self.menuTypeID = menuTypeID;
        self.subMenuTypeID = subMenuTypeID;
        self.subMenuType2ID = subMenuType2ID;
        self.subMenuType3ID = subMenuType3ID;
        self.color = color;
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
    NSString *primaryKeyName = @"menuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    
    
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

+(void)addObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObject:menu];
}

+(void)removeObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList removeObject:menu];
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

+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _status = %ld",menuTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [self sortList:[filterArray mutableCopy]];
}

+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _subMenuTypeID = %ld and _status = %ld",menuTypeID,subMenuTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [self sortList:[filterArray mutableCopy]];
}

+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _subMenuTypeID = %ld",menuTypeID,subMenuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    if([sortArray count] == 0)
    {
        return 1;
    }
    else
    {
        Menu *menu = sortArray[0];
        return menu.orderNo+1;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Menu *)copy).menuID = self.menuID;
        [copy setMenuCode:[self.menuCode copyWithZone:zone]];
        [copy setTitleThai:[self.titleThai copyWithZone:zone]];
        ((Menu *)copy).price = self.price;
        ((Menu *)copy).menuTypeID = self.menuTypeID;
        ((Menu *)copy).subMenuTypeID = self.subMenuTypeID;
        ((Menu *)copy).subMenuType2ID = self.subMenuType2ID;
        ((Menu *)copy).subMenuType3ID = self.subMenuType3ID;
        [copy setColor:[self.color copyWithZone:zone]];
        ((Menu *)copy).orderNo = self.orderNo;
        ((Menu *)copy).status = self.status;
        [copy setRemark:[self.remark copyWithZone:zone]];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((Menu *)copy).replaceSelf = self.replaceSelf;
        ((Menu *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

-(BOOL)editMenu:(Menu *)editingMenu
{
    if([self.menuCode isEqualToString:editingMenu.menuCode] &&
       [self.titleThai isEqualToString:editingMenu.titleThai] &&
       self.price == editingMenu.price &&
       self.remark == editingMenu.remark &&
       self.status == editingMenu.status
       )
    {
        return NO;
    }
    return YES;
}

+(void)setMenuList:(NSMutableArray *)menuList
{
    [SharedMenu sharedMenu].menuList = menuList;
}

+(NSMutableArray *)sortList:(NSMutableArray *)menuList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [menuList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end
