//
//  SharedOrderCancelDiscount.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedOrderCancelDiscount.h"

@implementation SharedOrderCancelDiscount
@synthesize orderCancelDiscountList;

+(SharedOrderCancelDiscount *)sharedOrderCancelDiscount {
    static dispatch_once_t pred;
    static SharedOrderCancelDiscount *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedOrderCancelDiscount alloc] init];
        shared.orderCancelDiscountList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
