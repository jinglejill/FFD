//
//  IngredientCheck.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientCheck.h"
#import "SharedIngredientCheck.h"
#import "Utility.h"


@implementation IngredientCheck

-(IngredientCheck *)initWithIngredientID:(NSInteger)ingredientID amount:(float)amount amountSmall:(float)amountSmall checkDate:(NSDate *)checkDate
{
    self = [super init];
    if(self)
    {
        self.ingredientCheckID = [IngredientCheck getNextID];
        self.ingredientID = ingredientID;
        self.amount = amount;
        self.amountSmall = amountSmall;
        self.checkDate = checkDate;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"ingredientCheckID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    
    
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

+(void)addObject:(IngredientCheck *)ingredientCheck
{
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    [dataList addObject:ingredientCheck];
}

+(void)removeObject:(IngredientCheck *)ingredientCheck
{
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    [dataList removeObject:ingredientCheck];
}

+(void)addList:(NSMutableArray *)ingredientCheckList
{
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    [dataList addObjectsFromArray:ingredientCheckList];
}

+(void)removeList:(NSMutableArray *)ingredientCheckList
{
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    [dataList removeObjectsInArray:ingredientCheckList];
}

+(IngredientCheck *)getIngredientCheck:(NSInteger)ingredientCheckID
{
    NSMutableArray *dataList = [SharedIngredientCheck sharedIngredientCheck].ingredientCheckList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientCheckID = %ld",ingredientCheckID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(IngredientCheck *)getIngredientCheckWithIngredientID:(NSInteger)ingredientID ingredientCheckList:(NSMutableArray *)ingredientCheckList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientID = %ld",ingredientID];
    NSArray *filterArray = [ingredientCheckList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((IngredientCheck *)copy).ingredientCheckID = self.ingredientCheckID;
        ((IngredientCheck *)copy).ingredientID = self.ingredientID;
        ((IngredientCheck *)copy).amount = self.amount;
        ((IngredientCheck *)copy).amountSmall = self.amountSmall;
        [copy setCheckDate:[self.checkDate copyWithZone:zone]];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((IngredientCheck *)copy).replaceSelf = self.replaceSelf;
        ((IngredientCheck *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(NSMutableArray *)copy:(NSMutableArray *)ingredientCheckList
{
    NSMutableArray *copyIngredientCheckList = [[NSMutableArray alloc]init];
    for(IngredientCheck *item in ingredientCheckList)
    {
        IngredientCheck *ingredientCheck = [item copy];
        [copyIngredientCheckList addObject:ingredientCheck];
    }
    return copyIngredientCheckList;
}

+(void)copyFrom:(NSMutableArray *)fromIngredientCheckList to:(NSMutableArray *)toIngredientCheckList
{
    for(IngredientCheck *item in fromIngredientCheckList)
    {
        IngredientCheck *ingredientCheck = [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:toIngredientCheckList];
        ingredientCheck.ingredientCheckID = item.ingredientCheckID;
        ingredientCheck.amount = item.amount;
        ingredientCheck.amountSmall = item.amountSmall;
        ingredientCheck.checkDate = item.checkDate;
    }
}

@end
