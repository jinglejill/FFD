//
//  Province.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Province.h"
#import "SharedProvince.h"
#import "Utility.h"


@implementation Province

-(Province *)initWithName:(NSString *)name nameEn:(NSString *)nameEn geographyID:(NSInteger)geographyID
{
    self = [super init];
    if(self)
    {
        self.provinceID = [Province getNextID];
        self.name = name;
        self.nameEn = nameEn;
        self.geographyID = geographyID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"provinceID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    
    
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

+(void)addObject:(Province *)province
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    [dataList addObject:province];
}

+(void)removeObject:(Province *)province
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    [dataList removeObject:province];
}

+(void)addList:(NSMutableArray *)provinceList
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    [dataList addObjectsFromArray:provinceList];
}

+(void)removeList:(NSMutableArray *)provinceList
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    [dataList removeObjectsInArray:provinceList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Province *)copy).provinceID = self.provinceID;
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((Province *)copy).geographyID = self.geographyID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((Province *)copy).replaceSelf = self.replaceSelf;
        ((Province *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(Province *)getProvince:(NSInteger)provinceID
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_provinceID = %ld",provinceID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getName:(NSInteger)provinceID
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_provinceID = %ld",provinceID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        Province *province = filterArray[0];
        return province.name;
    }
    return @"";
}

+(NSMutableArray *)getProvinceList
{
    NSMutableArray *dataList = [SharedProvince sharedProvince].provinceList;
    return dataList;
}

+(NSInteger)getSelectedIndexWithName:(NSString *)name provinceList:(NSMutableArray *)provinceList
{    
    for(int i=0; i<[provinceList count]; i++)
    {
        Province *province = provinceList[i];
        if([province.name isEqualToString:name])
        {
            return i;
        }
    }
    return 0;
}
@end
