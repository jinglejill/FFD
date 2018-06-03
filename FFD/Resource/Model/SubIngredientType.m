//
//  SubIngredientType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SubIngredientType.h"
#import "SharedSubIngredientType.h"
#import "Utility.h"


@implementation SubIngredientType

-(SubIngredientType *)initWithIngredientTypeID:(NSInteger)ingredientTypeID name:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.subIngredientTypeID = [SubIngredientType getNextID];
        self.ingredientTypeID = ingredientTypeID;
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
    NSString *primaryKeyName = @"subIngredientTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    
    
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

+(void)addObject:(SubIngredientType *)subIngredientType
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    [dataList addObject:subIngredientType];
}

+(void)removeObject:(SubIngredientType *)subIngredientType
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    [dataList removeObject:subIngredientType];
}

+(void)addList:(NSMutableArray *)subIngredientTypeList
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    [dataList addObjectsFromArray:subIngredientTypeList];
}

+(void)removeList:(NSMutableArray *)subIngredientTypeList
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    [dataList removeObjectsInArray:subIngredientTypeList];
}

+(SubIngredientType *)getSubIngredientType:(NSInteger)subIngredientTypeID
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_subIngredientTypeID = %ld",subIngredientTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getSubIngredientTypeListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld and _status = %ld",ingredientTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getSubIngredientTypeListWithIngredientTypeID:(NSInteger)ingredientTypeID
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ingredientTypeID = %ld",ingredientTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedSubIngredientType sharedSubIngredientType].subIngredientTypeList;
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
        SubIngredientType *subIngredientType = sortArray[0];
        return subIngredientType.orderNo+1;
    }
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((SubIngredientType *)copy).subIngredientTypeID = self.subIngredientTypeID;
        ((SubIngredientType *)copy).ingredientTypeID = self.ingredientTypeID;
        [copy setName:[self.name copyWithZone:zone]];
        ((SubIngredientType *)copy).orderNo = self.orderNo;
        ((SubIngredientType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((SubIngredientType *)copy).replaceSelf = self.replaceSelf;
        ((SubIngredientType *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

-(BOOL)editSubIngredientType:(SubIngredientType *)editingSubIngredientType
{
    if([self.name isEqualToString:editingSubIngredientType.name] &&
       self.status == editingSubIngredientType.status
       )
    {
        return NO;
    }
    return YES;
}

@end
