//
//  Board.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Board.h"
#import "SharedBoard.h"
#import "Utility.h"


@implementation Board

-(Board *)initWithContent:(NSString *)content
{
    self = [super init];
    if(self)
    {
        self.boardID = [Board getNextID];
        self.content = content;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"boardID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    
    
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

+(void)addObject:(Board *)board
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    [dataList addObject:board];
}

+(void)removeObject:(Board *)board
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    [dataList removeObject:board];
}

+(void)addList:(NSMutableArray *)boardList
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    [dataList addObjectsFromArray:boardList];
}

+(void)removeList:(NSMutableArray *)boardList
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    [dataList removeObjectsInArray:boardList];
}

+(Board *)getBoard:(NSInteger)boardID
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_boardID = %ld",boardID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getContent
{
    NSMutableArray *dataList = [SharedBoard sharedBoard].boardList;
    if([dataList count]>0)
    {
        Board *board = dataList[0];
        return board.content;
    }
    return @"";
}

@end
