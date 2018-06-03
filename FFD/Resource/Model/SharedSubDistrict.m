//
//  SharedSubDistrict.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedSubDistrict.h"

@implementation SharedSubDistrict
@synthesize subDistrictList;

+(SharedSubDistrict *)sharedSubDistrict {
    static dispatch_once_t pred;
    static SharedSubDistrict *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSubDistrict alloc] init];
        shared.subDistrictList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
