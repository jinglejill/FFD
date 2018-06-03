//
//  SharedZipCode.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedZipCode.h"

@implementation SharedZipCode
@synthesize zipCodeList;

+(SharedZipCode *)sharedZipCode {
    static dispatch_once_t pred;
    static SharedZipCode *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedZipCode alloc] init];
        shared.zipCodeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
