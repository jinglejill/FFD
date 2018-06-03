//
//  Setting.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Setting.h"
#import "SharedSetting.h"
#import "Utility.h"


@implementation Setting

-(Setting *)initWithKeyName:(NSString *)keyName value:(NSString *)value
{
    self = [super init];
    if(self)
    {
        self.settingID = [Setting getNextID];
        self.keyName = keyName;
        self.value = value;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"settingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    
    
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

+(void)addObject:(Setting *)setting
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    [dataList addObject:setting];
}

+(void)removeObject:(Setting *)setting
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    [dataList removeObject:setting];
}

+(void)addList:(NSMutableArray *)settingList
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    [dataList addObjectsFromArray:settingList];
}

+(void)removeList:(NSMutableArray *)settingList
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    [dataList removeObjectsInArray:settingList];
}

+(Setting *)getSetting:(NSInteger)settingID
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_settingID = %ld",settingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getSettingValueWithKeyName:(NSString *)keyName
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_keyName = %@",keyName];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        Setting *setting = filterArray[0];
        return setting.value;
    }
    return nil;
}

+(Setting *)getSettingWithKeyName:(NSString *)keyName
{
    NSMutableArray *dataList = [SharedSetting sharedSetting].settingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_keyName = %@",keyName];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(BOOL)isDeleteOrderPasswordValid:(NSString *)password
{
    NSUInteger fieldHash = [password hash];
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    
    
    NSString *strDeleteOrderPassword = [Setting getSettingValueWithKeyName:@"deleteOrderPassword"];
    if([strDeleteOrderPassword isEqualToString:fieldString])
    {
        return YES;
    }
    return NO;
}
@end
