//
//  ZipCode.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ZipCode.h"
#import "SharedZipCode.h"
#import "Utility.h"


@implementation ZipCode

-(ZipCode *)initWithSubDistrictID:(NSInteger)subDistrictID subDistrictCode:(NSString *)subDistrictCode zipCode:(NSString *)zipCode
{
    self = [super init];
    if(self)
    {
        self.zipCodeID = [ZipCode getNextID];
        self.subDistrictID = subDistrictID;
        self.subDistrictCode = subDistrictCode;
        self.zipCode = zipCode;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"zipCodeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    
    
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

+(void)addObject:(ZipCode *)zipCode
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    [dataList addObject:zipCode];
}

+(void)removeObject:(ZipCode *)zipCode
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    [dataList removeObject:zipCode];
}

+(void)addList:(NSMutableArray *)zipCodeList
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    [dataList addObjectsFromArray:zipCodeList];
}

+(void)removeList:(NSMutableArray *)zipCodeList
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    [dataList removeObjectsInArray:zipCodeList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((ZipCode *)copy).zipCodeID = self.zipCodeID;
        ((ZipCode *)copy).subDistrictID = self.subDistrictID;
        [copy setSubDistrictCode:self.subDistrictCode];
        [copy setZipCode:self.zipCode];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((ZipCode *)copy).replaceSelf = self.replaceSelf;
        ((ZipCode *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(ZipCode *)getZipCode:(NSInteger)zipCodeID
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_zipCodeID = %ld",zipCodeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getName:(NSInteger)zipCodeID
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_zipCodeID = %ld",zipCodeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        ZipCode *zipCode = filterArray[0];
        return zipCode.zipCode;
    }
    return @"";
}

+(NSMutableArray *)getZipCodeList
{
    NSMutableArray *dataList = [SharedZipCode sharedZipCode].zipCodeList;
    return dataList;
}
@end
