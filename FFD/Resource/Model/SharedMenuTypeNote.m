//
//  SharedMenuTypeNote.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedMenuTypeNote.h"

@implementation SharedMenuTypeNote
@synthesize menuTypeNoteList;

+(SharedMenuTypeNote *)sharedMenuTypeNote {
    static dispatch_once_t pred;
    static SharedMenuTypeNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuTypeNote alloc] init];
        shared.menuTypeNoteList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
