//
//  SharedMember.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedMember.h"

@implementation SharedMember
@synthesize memberList;

+(SharedMember *)sharedMember {
    static dispatch_once_t pred;
    static SharedMember *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMember alloc] init];
        shared.memberList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
