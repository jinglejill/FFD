//
//  NoteType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "NoteType.h"
#import "SharedNoteType.h"
#import "Utility.h"


@implementation NoteType

-(NoteType *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.noteTypeID = [NoteType getNextID];
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
    NSString *primaryKeyName = @"noteTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    
    
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

+(void)addObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObject:noteType];
}

+(void)removeObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObject:noteType];
}

+(void)addList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObjectsFromArray:noteTypeList];
}

+(void)removeList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObjectsInArray:noteTypeList];
}

+(NoteType *)getNoteType:(NSInteger)noteTypeID
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld",noteTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [noteTypeList sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((NoteType *)copy).noteTypeID = self.noteTypeID;
        [copy setName:[self.name copyWithZone:zone]];
        ((NoteType *)copy).orderNo = self.orderNo;
        ((NoteType *)copy).status = self.status;
        ((NoteType *)copy).replaceSelf = self.replaceSelf;
        ((NoteType *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

@end
