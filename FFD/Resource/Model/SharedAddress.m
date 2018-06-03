//
//  SharedAddress.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedAddress.h"

@implementation SharedAddress
@synthesize addressList;

+(SharedAddress *)sharedAddress {
    static dispatch_once_t pred;
    static SharedAddress *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedAddress alloc] init];
        shared.addressList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
