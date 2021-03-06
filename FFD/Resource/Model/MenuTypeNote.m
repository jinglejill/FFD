//
//  MenuTypeNote.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MenuTypeNote.h"
#import "SharedMenuTypeNote.h"
#import "Note.h"
#import "Utility.h"


@implementation MenuTypeNote

-(MenuTypeNote *)initWithMenuTypeID:(NSInteger)menuTypeID noteID:(NSInteger)noteID
{
    self = [super init];
    if(self)
    {
        self.menuTypeNoteID = [MenuTypeNote getNextID];
        self.menuTypeID = menuTypeID;
        self.noteID = noteID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuTypeNoteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    
    
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

+(void)addObject:(MenuTypeNote *)menuTypeNote
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList addObject:menuTypeNote];
}

+(void)removeObject:(MenuTypeNote *)menuTypeNote
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList removeObject:menuTypeNote];
}

+(MenuTypeNote *)getMenuTypeNote:(NSInteger)menuTypeNoteID
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeNoteID = %ld",menuTypeNoteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getNoteListWithMenuTypeID:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(MenuTypeNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        [noteList addObject:note];
    }
    
    
    noteList = [Note getNoteListWithStatus:1 noteList:noteList];
    return noteList;
}

@end
