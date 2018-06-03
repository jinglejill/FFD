//
//  SharedDistrict.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedDistrict.h"

@implementation SharedDistrict
@synthesize districtList;

+(SharedDistrict *)sharedDistrict {
    static dispatch_once_t pred;
    static SharedDistrict *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDistrict alloc] init];
        shared.districtList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
