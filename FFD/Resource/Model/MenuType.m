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

-(MenuType *)initWithName:(NSString *)name allowDiscount:(NSInteger)allowDiscount color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.menuTypeID = [MenuType getNextID];
        self.name = name;
        self.allowDiscount = allowDiscount;
        self.color = color;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    
    
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

+(void)addObject:(MenuType *)menuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList addObject:menuType];
}

+(void)removeObject:(MenuType *)menuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList removeObject:menuType];
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
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getMenuTypeList
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
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
        MenuType *menuType = sortArray[0];
        return menuType.orderNo+1;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((MenuType *)copy).menuTypeID = self.menuTypeID;
        [copy setName:[self.name copyWithZone:zone]];
        ((MenuType *)copy).allowDiscount = self.allowDiscount;
        [copy setColor:[self.color copyWithZone:zone]];
        ((MenuType *)copy).orderNo = self.orderNo;
        ((MenuType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((MenuType *)copy).replaceSelf = self.replaceSelf;
        ((MenuType *)copy).idInserted = self.idInserted;        
    }
    
    return copy;
}

-(BOOL)editMenuType:(MenuType *)editingMenuType
{
    if([self.name isEqualToString:editingMenuType.name] &&
       self.allowDiscount == editingMenuType.allowDiscount &&
       self.color == editingMenuType.color &&
       self.status == editingMenuType.status
       )
    {
        return NO;
    }
    return YES;
}

+(void)setMenuTypeList:(NSMutableArray *)menuTypeList
{
    [SharedMenuType sharedMenuType].menuTypeList = menuTypeList;
}

+(NSMutableArray *)sort:(NSMutableArray *)menuTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [menuTypeList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSInteger)getCountMenuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = 1"];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray count];
}
@end
