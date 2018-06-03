//
//  SharedTableTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedTableTaking.h"

@implementation SharedTableTaking
@synthesize tableTakingList;

+(SharedTableTaking *)sharedTableTaking {
    static dispatch_once_t pred;
    static SharedTableTaking *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedTableTaking alloc] init];
        shared.tableTakingList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
