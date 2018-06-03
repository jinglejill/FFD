//
//  OrderNote.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderNote.h"
#import "SharedOrderNote.h"
#import "Note.h"
#import "OrderTaking.h"
#import "Utility.h"


@implementation OrderNote

-(OrderNote *)initWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID
{
    self = [super init];
    if(self)
    {
        self.orderNoteID = [OrderNote getNextID];
        self.orderTakingID = orderTakingID;
        self.noteID = noteID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    strNameID = @"orderNoteID";
    
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

+(void)addObject:(OrderNote *)orderNote
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    [dataList addObject:orderNote];
}

+(void)removeObject:(OrderNote *)orderNote
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    [dataList removeObject:orderNote];
}

+(void)removeList:(NSMutableArray *)orderNoteList
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    [dataList removeObjectsInArray:orderNoteList];
}

+(OrderNote *)getOrderNote:(NSInteger)orderNoteID
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderNoteID = %ld",orderNoteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(OrderNote *)getOrderNoteWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld and _noteID = %ld",orderTakingID,noteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(OrderNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        [noteList addObject:note];
    }
    
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    NSArray *sortArray = [noteList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getOrderNoteListWithOrderTakingID:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderNoteListWithCustomerTableID:(NSInteger)customerTableID
{
    NSMutableArray *orderNoteList = [[NSMutableArray alloc]init];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTableID status:1];
    for(OrderTaking *item in orderTakingList)
    {
        NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",item.orderTakingID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        [orderNoteList addObjectsFromArray:filterArray];
    }
    
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"_orderNoteID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    NSArray *sortArray = [orderNoteList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID
{
    int i=0;
    NSString *strNote = @"";
    NSMutableArray *noteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID];
    if([noteList count] > 0)
    {
        for(Note *item in noteList)
        {
            if(i == [noteList count]-1)
            {
                strNote = [NSString stringWithFormat:@"%@%@",strNote,item.name];
            }
            else
            {
                strNote = [NSString stringWithFormat:@"%@%@,",strNote,item.name];
            }
            i++;
        }
    }
    return strNote;
}

+(NSString *)getNoteIDListInTextWithOrderTakingID:(NSInteger)orderTakingID
{
    int i=0;
    NSString *strNote = @"";
    NSMutableArray *noteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID];
    if([noteList count] > 0)
    {
        for(Note *item in noteList)
        {
            if(i == [noteList count]-1)
            {
                strNote = [NSString stringWithFormat:@"%@%ld",strNote,item.noteID];
            }
            else
            {
                strNote = [NSString stringWithFormat:@"%@%ld,",strNote,item.noteID];
            }
            i++;
        }
    }
    return strNote;
}

+(float)getSumNotePriceWithOrderTakingID:(NSInteger)orderTakingID
{
    float sum = 0;
    NSMutableArray *noteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID];
    for(Note *item in noteList)
    {
        sum += item.price;
    }
    return sum;
}
@end
