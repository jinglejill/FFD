//
//  Note.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Note.h"
#import "SharedNote.h"
#import "Utility.h"


@implementation Note

-(Note *)initWithName:(NSString *)name price:(float)price orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.noteID = [Note getNextID];
        self.name = name;
        self.price = price;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedNote sharedNote].noteList;
    strNameID = @"noteID";
    
    NSString *strSortID = [NSString stringWithFormat:@"_%@",strNameID];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:strSortID ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else;
    {
        id value = [dataList[0] valueForKey:strNameID];
        NSString *strMaxID = value;
        
        return [strMaxID intValue]+1;
    }
}

+(void)addObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList addObject:note];
}

+(void)removeObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList removeObject:note];
}

+(Note *)getNote:(NSInteger)noteID
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteID = %ld",noteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

@end
