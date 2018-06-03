//
//  SharedProvince.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedProvince.h"

@implementation SharedProvince
@synthesize provinceList;

+(SharedProvince *)sharedProvince {
    static dispatch_once_t pred;
    static SharedProvince *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedProvince alloc] init];
        shared.provinceList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
