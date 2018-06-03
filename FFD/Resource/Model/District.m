//
//  District.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "District.h"
#import "SharedDistrict.h"
#import "Utility.h"


@implementation District

-(District *)initWithName:(NSString *)name nameEn:(NSString *)nameEn geographyID:(NSInteger)geographyID provinceID:(NSInteger)provinceID
{
    self = [super init];
    if(self)
    {
        self.districtID = [District getNextID];
        self.name = name;
        self.nameEn = nameEn;
        self.geographyID = geographyID;
        self.provinceID = provinceID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"districtID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    
    
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

+(void)addObject:(District *)district
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    [dataList addObject:district];
}

+(void)removeObject:(District *)district
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    [dataList removeObject:district];
}

+(void)addList:(NSMutableArray *)districtList
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    [dataList addObjectsFromArray:districtList];
}

+(void)removeList:(NSMutableArray *)districtList
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    [dataList removeObjectsInArray:districtList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((District *)copy).districtID = self.districtID;
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((District *)copy).geographyID = self.geographyID;
        ((District *)copy).provinceID = self.provinceID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((District *)copy).replaceSelf = self.replaceSelf;
        ((District *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(District *)getDistrict:(NSInteger)districtID
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_districtID = %ld",districtID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getName:(NSInteger)districtID
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_districtID = %ld",districtID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        District *district = filterArray[0];
        return district.name;
    }
    return @"";
}

+(NSMutableArray *)getDistrictList
{
    NSMutableArray *dataList = [SharedDistrict sharedDistrict].districtList;
    return dataList;
}
@end
