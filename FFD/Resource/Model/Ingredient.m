//
//  Ingredient.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Ingredient.h"
#import "SharedIngredient.h"
#import "Utility.h"
#import "IngredientType.h"


@implementation Ingredient

-(Ingredient *)initWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID name:(NSString *)name uom:(NSString *)uom uomSmall:(NSString *)uomSmall smallAmount:(float)smallAmount orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.ingredientID = [Ingredient getNextID];
        self.ingredientTypeID = ingredientTypeID;
        self.subIngredientTypeID = subIngredientTypeID;
        self.name = name;
        self.uom = uom;
        self.uomSmall = uomSmall;
        self.smallAmount = smallAmount;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"ingredientID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    
    
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

+(void)addObject:(Ingredient *)ingredient
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    [dataList addObject:ingredient];
}

+(void)removeObject:(Ingredient *)ingredient
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    [dataList removeObject:ingredient];
}

+(void)addList:(NSMutableArray *)ingredientList
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    [dataList addObjectsFromArray:ingredientList];
}

+(void)removeList:(NSMutableArray *)ingredientList
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    [dataList removeObjectsInArray:ingredientList];
}

+(Ingredient *)getIngredient:(NSInteger)ingredientID
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientID = %ld",ingredientID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID ingredientList:(NSMutableArray *)ingredientList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld",ingredientTypeID];
    NSArray *filterArray = [ingredientList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status ingredientList:(NSMutableArray *)ingredientList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld and _status = %ld",ingredientTypeID,status];
    NSArray *filterArray = [ingredientList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld and _status = %ld",ingredientTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld and _subIngredientTypeID = %ld and _status = %ld",ingredientTypeID,subIngredientTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld and _subIngredientTypeID = %ld",ingredientTypeID,subIngredientTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld",ingredientTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
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
        Ingredient *ingredient = sortArray[0];
        return ingredient.orderNo+1;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    if (copy)
    {
        ((Ingredient *)copy).ingredientID = self.ingredientID;
        ((Ingredient *)copy).ingredientTypeID = self.ingredientTypeID;
        ((Ingredient *)copy).subIngredientTypeID = self.subIngredientTypeID;
        [copy setName:[self.name copyWithZone:zone]];
        [copy setUom:[self.uom copyWithZone:zone]];
        [copy setUomSmall:[self.uomSmall copyWithZone:zone]];
        ((Ingredient *)copy).smallAmount = self.smallAmount;
        ((Ingredient *)copy).orderNo = self.orderNo;
        ((Ingredient *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((Ingredient *)copy).replaceSelf = self.replaceSelf;
        ((Ingredient *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

-(BOOL)editIngredient:(Ingredient *)editingIngredient
{
    if([self.name isEqualToString:editingIngredient.name] &&
       [self.uom isEqualToString:editingIngredient.uom] &&
       [self.uomSmall isEqualToString:editingIngredient.uomSmall] &&
       self.smallAmount == editingIngredient.smallAmount &&
       self.status == editingIngredient.status
       )
    {
        return NO;
    }
    return YES;
}

+(void)setIngredientList:(NSMutableArray *)ingredientList
{
    [SharedIngredient sharedIngredient].ingredientList = ingredientList;
}

+(NSMutableArray *)getIngredientListWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredient sharedIngredient].ingredientList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortList:(NSMutableArray *)ingredientList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [ingredientList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientListWithIngredientTypeStatus:(NSInteger)status ingredientList:(NSMutableArray *)ingredientList
{
    NSMutableArray *filterIngredientList = [[NSMutableArray alloc]init];
    for(Ingredient *item in ingredientList)
    {
        IngredientType *ingredientType = [IngredientType getIngredientType:item.ingredientTypeID];
        if(ingredientType.status == status)
        {
            [filterIngredientList addObject:item];
        }
    }
    
    return filterIngredientList;
    
}
@end
