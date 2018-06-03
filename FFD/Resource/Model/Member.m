//
//  Member.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Member.h"
#import "SharedMember.h"
#import "Utility.h"


@implementation Member

-(Member *)init
{
    self = [super init];
    if(self)
    {
        self.memberID = 0;
        self.fullName = @"";
        self.nickname = @"";
        self.phoneNo = @"";
        self.birthDate = [Utility notIdentifiedDate];
        self.gender = @"";
        self.memberDate = [Utility notIdentifiedDate];
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

-(Member *)initWithFullName:(NSString *)fullName nickname:(NSString *)nickname phoneNo:(NSString *)phoneNo birthDate:(NSDate *)birthDate gender:(NSString *)gender memberDate:(NSDate *)memberDate
{
    self = [super init];
    if(self)
    {
        self.memberID = [Member getNextID];
        self.fullName = fullName;
        self.nickname = nickname;
        self.phoneNo = phoneNo;
        self.birthDate = birthDate;
        self.gender = gender;
        self.memberDate = memberDate;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"memberID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMember sharedMember].memberList;
    
    
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

+(void)addObject:(Member *)member
{
    NSMutableArray *dataList = [SharedMember sharedMember].memberList;
    [dataList addObject:member];
}

+(void)removeObject:(Member *)member
{
    NSMutableArray *dataList = [SharedMember sharedMember].memberList;
    [dataList removeObject:member];
}

+(Member *)getMember:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedMember sharedMember].memberList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(Member *)getMemberWithPhoneNo:(NSString *)phoneNo
{
    NSMutableArray *dataList = [SharedMember sharedMember].memberList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_phoneNo = %@",phoneNo];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}


@end
