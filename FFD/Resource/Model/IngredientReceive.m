//
//  IngredientReceive.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientReceive.h"
#import "SharedIngredientReceive.h"
#import "Utility.h"
#import "Ingredient.h"


@implementation IngredientReceive

-(IngredientReceive *)initWithIngredientID:(NSInteger)ingredientID amount:(float)amount amountSmall:(float)amountSmall price:(float)price receiveDate:(NSDate *)receiveDate
{
    self = [super init];
    if(self)
    {
        self.ingredientReceiveID = [IngredientReceive getNextID];
        self.ingredientID = ingredientID;
        self.amount = amount;
        self.amountSmall = amountSmall;
        self.price = price;
        self.receiveDate = receiveDate;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"ingredientReceiveID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    
    
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

+(void)addObject:(IngredientReceive *)ingredientReceive
{
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    [dataList addObject:ingredientReceive];
}

+(void)removeObject:(IngredientReceive *)ingredientReceive
{
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    [dataList removeObject:ingredientReceive];
}

+(void)addList:(NSMutableArray *)ingredientReceiveList
{
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    [dataList addObjectsFromArray:ingredientReceiveList];
}

+(void)removeList:(NSMutableArray *)ingredientReceiveList
{
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    [dataList removeObjectsInArray:ingredientReceiveList];
}

+(IngredientReceive *)getIngredientReceive:(NSInteger)ingredientReceiveID
{
    NSMutableArray *dataList = [SharedIngredientReceive sharedIngredientReceive].ingredientReceiveList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientReceiveID = %ld",ingredientReceiveID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getIngredientReceiveList
{
    NSMutableArray *ingredientReceiveList = [[NSMutableArray alloc]init];
    NSMutableArray *ingredientList = [Ingredient getIngredientListWithStatus:1];
    ingredientList = [Ingredient getIngredientListWithIngredientTypeStatus:1 ingredientList:ingredientList];
    for(Ingredient *item in ingredientList)
    {
        IngredientReceive *ingredientReceive = [[IngredientReceive alloc]initWithIngredientID:item.ingredientID amount:0 amountSmall:0 price:0 receiveDate:[Utility notIdentifiedDate]];
        [IngredientReceive addObject:ingredientReceive];
        [ingredientReceiveList addObject:ingredientReceive];
    }
    
    return ingredientReceiveList;
}

+(NSMutableArray *)getIngredientReceiveListWithIngredientTypeID:(NSInteger)ingredientTypeID ingredientReceiveList:(NSMutableArray *)ingredientReceiveList
{
    NSMutableArray *filterIngredientReceiveList = [[NSMutableArray alloc]init];
    for(IngredientReceive *item in ingredientReceiveList)
    {
        Ingredient *ingredient = [Ingredient getIngredient:item.ingredientID];
        if(ingredient.ingredientTypeID == ingredientTypeID)
        {
            [filterIngredientReceiveList addObject:item];
        }
    }
    
    
    return filterIngredientReceiveList;    
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((IngredientReceive *)copy).ingredientReceiveID = self.ingredientReceiveID;
        ((IngredientReceive *)copy).ingredientID = self.ingredientID;
        ((IngredientReceive *)copy).amount = self.amount;
        ((IngredientReceive *)copy).amountSmall = self.amountSmall;
        ((IngredientReceive *)copy).price = self.price;
        [copy setReceiveDate:[self.receiveDate copyWithZone:zone]];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((IngredientReceive *)copy).replaceSelf = self.replaceSelf;
        ((IngredientReceive *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(NSMutableArray *)copy:(NSMutableArray *)ingredientReceiveList
{
    NSMutableArray *copyIngredientReceiveList = [[NSMutableArray alloc]init];
    for(IngredientReceive *item in ingredientReceiveList)
    {
        IngredientReceive *ingredientReceive = [item copy];
        [copyIngredientReceiveList addObject:ingredientReceive];
    }
    return copyIngredientReceiveList;
}

+(NSMutableArray *)getIngredientReceiveListWithReceiveDate:(NSDate *)receiveDate ingredientReceiveList:(NSMutableArray *)ingredientReceiveList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiveDate = %@",receiveDate];
    NSArray *filterArray = [ingredientReceiveList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortList:(NSMutableArray *)ingredientReceiveList
{
    NSMutableArray *ingredientList = [[NSMutableArray alloc]init];
    for(IngredientReceive *item in ingredientReceiveList)
    {
        Ingredient *ingredient = [Ingredient getIngredient:item.ingredientID];
        [ingredientList addObject:ingredient];
    }
    
    
    NSMutableArray *tempIngredientReceiveList = [[NSMutableArray alloc]init];
    ingredientList = [Ingredient sortList:ingredientList];
    for(Ingredient *item in ingredientList)
    {
        IngredientReceive *ingredientReceive = [IngredientReceive getIngredientReceiveWithIngredientID:item.ingredientID ingredientReceiveList:ingredientReceiveList];
        [tempIngredientReceiveList addObject:ingredientReceive];
    }
    
    return tempIngredientReceiveList;
}

+(NSMutableArray *)sortListByReceiveDate:(NSMutableArray *)ingredientReceiveList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_receiveDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [ingredientReceiveList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(IngredientReceive *)getIngredientReceiveWithIngredientID:(NSInteger)ingredientID ingredientReceiveList:(NSMutableArray *)ingredientReceiveList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientID = %ld",ingredientID];
    NSArray *filterArray = [ingredientReceiveList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}

+(void)copyFrom:(NSMutableArray *)fromIngredientReceiveList to:(NSMutableArray *)toIngredientReceiveList
{
    for(IngredientReceive *item in fromIngredientReceiveList)
    {
        IngredientReceive *ingredientReceive = [IngredientReceive getIngredientReceiveWithIngredientID:item.ingredientID ingredientReceiveList:toIngredientReceiveList];
        ingredientReceive.ingredientReceiveID = item.ingredientReceiveID;
        ingredientReceive.amount = item.amount;
        ingredientReceive.amountSmall = item.amountSmall;
        ingredientReceive.price = item.price;
        ingredientReceive.receiveDate = item.receiveDate;
    }
}

@end
