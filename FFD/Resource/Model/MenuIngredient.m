//
//  MenuIngredient.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MenuIngredient.h"
#import "SharedMenuIngredient.h"
#import "Utility.h"


@implementation MenuIngredient

-(MenuIngredient *)initWithMenuID:(NSInteger)menuID ingredientID:(NSInteger)ingredientID amount:(float)amount
{
    self = [super init];
    if(self)
    {
        self.menuIngredientID = [MenuIngredient getNextID];
        self.menuID = menuID;
        self.ingredientID = ingredientID;
        self.amount = amount;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuIngredientID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    
    
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

+(void)addObject:(MenuIngredient *)menuIngredient
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    [dataList addObject:menuIngredient];
}

+(void)removeObject:(MenuIngredient *)menuIngredient
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    [dataList removeObject:menuIngredient];
}

+(void)addList:(NSMutableArray *)menuIngredientList
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    [dataList addObjectsFromArray:menuIngredientList];
}

+(void)removeList:(NSMutableArray *)menuIngredientList
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    [dataList removeObjectsInArray:menuIngredientList];
}

+(MenuIngredient *)getMenuIngredient:(NSInteger)menuIngredientID
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuIngredientID = %ld",menuIngredientID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuIngredientListWithMenuID:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(MenuIngredient *)getMenuIngredientWithMenuID:(NSInteger)menuID ingredientID:(NSInteger)ingredientID
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld and _ingredientID = %ld",menuID,ingredientID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuIngredientListWithIngredientID:(NSInteger)ingredientID
{
    NSMutableArray *dataList = [SharedMenuIngredient sharedMenuIngredient].menuIngredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientID = %ld",ingredientID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

-(BOOL)editMenuIngredient:(MenuIngredient *)editingMenuIngredient
{
    if(self.amount == editingMenuIngredient.amount
       )
    {
        return NO;
    }
    return YES;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((MenuIngredient *)copy).menuIngredientID = self.menuIngredientID;
        ((MenuIngredient *)copy).menuID = self.menuID;
        ((MenuIngredient *)copy).ingredientID = self.ingredientID;
        ((MenuIngredient *)copy).amount = self.amount;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((MenuIngredient *)copy).replaceSelf = self.replaceSelf;
        ((MenuIngredient *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

@end
