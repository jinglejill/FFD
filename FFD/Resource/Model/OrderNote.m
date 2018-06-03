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
    NSString *primaryKeyName = @"orderNoteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    
    
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
//    NSString *primaryKeyName = @"orderNoteID";
//    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
//    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
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

+(void)addObject:(OrderNote *)orderNote
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    [dataList addObject:orderNote];
}

+(void)addList:(NSMutableArray *)orderNoteList
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    [dataList addObjectsFromArray:orderNoteList];
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
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
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
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNoteID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderNoteList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType
{
    int i=0;
    NSString *strNote = @"";
    NSMutableArray *noteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID noteType:noteType];
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
+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID
{
    int i=0;
    NSString *strAllNote = @"";
    NSString *strRemoveTypeNote = @"";
    NSString *strAddTypeNote = @"";
    NSMutableArray *removeTypeNoteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID noteType:-1];
    NSMutableArray *addTypeNoteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID noteType:1];
    if([removeTypeNoteList count] > 0)
    {
        for(Note *item in removeTypeNoteList)
        {
            if(i == [removeTypeNoteList count]-1)
            {
                strRemoveTypeNote = [NSString stringWithFormat:@"%@%@",strRemoveTypeNote,item.name];
            }
            else
            {
                strRemoveTypeNote = [NSString stringWithFormat:@"%@%@,",strRemoveTypeNote,item.name];
            }
            i++;
        }
    }
    
    if([addTypeNoteList count] > 0)
    {
        for(Note *item in addTypeNoteList)
        {
            if(i == [addTypeNoteList count]-1)
            {
                strAddTypeNote = [NSString stringWithFormat:@"%@%@",strAddTypeNote,item.name];
            }
            else
            {
                strAddTypeNote = [NSString stringWithFormat:@"%@%@,",strAddTypeNote,item.name];
            }
            i++;
        }
    }
    
    strAllNote = strRemoveTypeNote;
    return strAllNote;
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

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((OrderNote *)copy).orderNoteID = self.orderNoteID;
        ((OrderNote *)copy).orderTakingID = self.orderTakingID;
        ((OrderNote *)copy).noteID = self.noteID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((OrderNote *)copy).replaceSelf = self.replaceSelf;
        ((OrderNote *)copy).idInserted = self.idInserted;
    }
    
    return copy;
}

+(OrderNote *)getOrderNoteWithNoteID:(NSInteger)noteID orderNoteList:(NSMutableArray *)orderNoteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteID = %ld",noteID];
    NSArray *filterArray = [orderNoteList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(OrderNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        if(note.type == noteType)
        {
            [noteList addObject:note];
        }        
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [noteList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getOrderNoteListWithOrderTakingList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *orderNoteList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in orderTakingList)
    {
        NSMutableArray *orderNoteListWithOrderTakingID = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
        [orderNoteList addObjectsFromArray:orderNoteListWithOrderTakingID];
    }
    
    
    return orderNoteList;
}

+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType branchID:(NSInteger)branchID
{
    int i=0;
    NSString *strNote = @"";
    NSMutableArray *noteList = [OrderNote getNoteListWithOrderTakingID:orderTakingID noteType:noteType branchID:branchID];
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

+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedOrderNote sharedOrderNote].orderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld and _branchID = %ld",orderTakingID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(OrderNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        if(note.type == noteType)
        {
            [noteList addObject:note];
        }
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [noteList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

@end
