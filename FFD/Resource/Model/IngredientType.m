//
//  IngredientType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientType.h"
#import "SharedIngredientType.h"
#import "Utility.h"


@implementation IngredientType

-(IngredientType *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.ingredientTypeID = [IngredientType getNextID];
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
    NSString *primaryKeyName = @"ingredientTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    
    
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

+(void)addObject:(IngredientType *)ingredientType
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    [dataList addObject:ingredientType];
}

+(void)removeObject:(IngredientType *)ingredientType
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    [dataList removeObject:ingredientType];
}

+(void)addList:(NSMutableArray *)ingredientTypeList
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    [dataList addObjectsFromArray:ingredientTypeList];
}

+(void)removeList:(NSMutableArray *)ingredientTypeList
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    [dataList removeObjectsInArray:ingredientTypeList];
}

+(IngredientType *)getIngredientType:(NSInteger)ingredientTypeID
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld",ingredientTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}
//
+(NSMutableArray *)sort:(NSMutableArray *)ingredientTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [ingredientTypeList sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientTypeListWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getIngredientTypeListWithStatus:(NSInteger)status ingredientTypeList:(NSMutableArray *)ingredientTypeList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [ingredientTypeList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getIngredientTypeList
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;

    return dataList;
}

+(void)setIngredientTypeList:(NSMutableArray *)ingredientTypeList
{
    [SharedIngredientType sharedIngredientType].ingredientTypeList = ingredientTypeList;
}

-(BOOL)editIngredientType:(IngredientType *)editingIngredientType
{
    if([self.name isEqualToString:editingIngredientType.name] &&
       self.status == editingIngredientType.status
       )
    {
        return NO;
    }
    return YES;
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedIngredientType sharedIngredientType].ingredientTypeList;
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
        IngredientType *ingredientType = sortArray[0];
        return ingredientType.orderNo+1;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((IngredientType *)copy).ingredientTypeID = self.ingredientTypeID;
        
        [copy setName:[self.name copyWithZone:zone]];
        ((IngredientType *)copy).orderNo = self.orderNo;
        ((IngredientType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((IngredientType *)copy).replaceSelf = self.replaceSelf;
        ((IngredientType *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}
@end

