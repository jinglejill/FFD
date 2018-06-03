//
//  SharedSubIngredientType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedSubIngredientType.h"

@implementation SharedSubIngredientType
@synthesize subIngredientTypeList;

+(SharedSubIngredientType *)sharedSubIngredientType {
    static dispatch_once_t pred;
    static SharedSubIngredientType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSubIngredientType alloc] init];
        shared.subIngredientTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
