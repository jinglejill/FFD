//
//  SharedRewardPoint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedRewardPoint.h"

@implementation SharedRewardPoint
@synthesize rewardPointList;

+(SharedRewardPoint *)sharedRewardPoint {
    static dispatch_once_t pred;
    static SharedRewardPoint *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRewardPoint alloc] init];
        shared.rewardPointList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
