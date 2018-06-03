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

-(Note *)initWithName:(NSString *)name price:(float)price noteTypeID:(NSInteger)noteTypeID type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.noteID = [Note getNextID];
        self.name = name;
        self.price = price;
        self.noteTypeID = noteTypeID;
        self.type = type;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}
+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"noteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    
    
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
//+(NSInteger)getNextID
//{
//    NSString *primaryKeyName = @"noteID";
//    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
//    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
//    
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
//    dataList = [sortArray mutableCopy];
//    
//    if([dataList count] == 0)
//    {
//        return 1;
//    }
//    else
//    {
//        id value = [dataList[0] valueForKey:primaryKeyName];
//        NSString *strMaxID = value;
//        
//        return [strMaxID intValue]+1;
//    }
//}

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

+(NSMutableArray *)getNoteListWithStatus:(NSInteger)status noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID type:(NSInteger)type noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld and _type = %ld",noteTypeID,type];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld",noteTypeID];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

@end
