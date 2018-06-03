//
//  SharedMenuType.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedMenuType.h"

@implementation SharedMenuType
@synthesize menuTypeList;

+(SharedMenuType *)sharedMenuType {
    static dispatch_once_t pred;
    static SharedMenuType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuType alloc] init];
        shared.menuTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
