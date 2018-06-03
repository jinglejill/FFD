//
//  SharedNoteType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedNoteType.h"

@implementation SharedNoteType
@synthesize noteTypeList;

+(SharedNoteType *)sharedNoteType {
    static dispatch_once_t pred;
    static SharedNoteType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedNoteType alloc] init];
        shared.noteTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
