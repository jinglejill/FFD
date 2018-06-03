//
//  SharedBoard.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedBoard.h"

@implementation SharedBoard
@synthesize boardList;

+(SharedBoard *)sharedBoard {
    static dispatch_once_t pred;
    static SharedBoard *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedBoard alloc] init];
        shared.boardList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
