//
//  SharedDiscount.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedDiscount.h"

@implementation SharedDiscount
@synthesize discountList;

+(SharedDiscount *)sharedDiscount {
    static dispatch_once_t pred;
    static SharedDiscount *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDiscount alloc] init];
        shared.discountList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
