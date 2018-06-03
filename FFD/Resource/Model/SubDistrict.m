//
//  SubDistrict.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SubDistrict.h"
#import "SharedSubDistrict.h"
#import "Utility.h"


@implementation SubDistrict

-(SubDistrict *)initWithCode:(NSString *)code name:(NSString *)name nameEn:(NSString *)nameEn districtID:(NSInteger)districtID provinceID:(NSInteger)provinceID geographyID:(NSInteger)geographyID
{
    self = [super init];
    if(self)
    {
        self.subDistrictID = [SubDistrict getNextID];
        self.code = code;
        self.name = name;
        self.nameEn = nameEn;
        self.districtID = districtID;
        self.provinceID = provinceID;
        self.geographyID = geographyID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"subDistrictID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    
    
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

+(void)addObject:(SubDistrict *)subDistrict
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    [dataList addObject:subDistrict];
}

+(void)removeObject:(SubDistrict *)subDistrict
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    [dataList removeObject:subDistrict];
}

+(void)addList:(NSMutableArray *)subDistrictList
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    [dataList addObjectsFromArray:subDistrictList];
}

+(void)removeList:(NSMutableArray *)subDistrictList
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    [dataList removeObjectsInArray:subDistrictList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((SubDistrict *)copy).subDistrictID = self.subDistrictID;
        [copy setCode:self.code];
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((SubDistrict *)copy).districtID = self.districtID;
        ((SubDistrict *)copy).provinceID = self.provinceID;
        ((SubDistrict *)copy).geographyID = self.geographyID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((SubDistrict *)copy).replaceSelf = self.replaceSelf;
        ((SubDistrict *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(SubDistrict *)getSubDistrict:(NSInteger)subDistrictID
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_subDistrictID = %ld",subDistrictID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getName:(NSInteger)subDistrictID;
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_subDistrictID = %ld",subDistrictID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        SubDistrict *subDistrict = filterArray[0];
        return subDistrict.name;
    }
    return @"";
}

+(NSMutableArray *)getSubDistrictList
{
    NSMutableArray *dataList = [SharedSubDistrict sharedSubDistrict].subDistrictList;
    return dataList;
}
@end
