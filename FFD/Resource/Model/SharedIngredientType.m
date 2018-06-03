//
//  SharedIngredientType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedIngredientType.h"

@implementation SharedIngredientType
@synthesize ingredientTypeList;

+(SharedIngredientType *)sharedIngredientType {
    static dispatch_once_t pred;
    static SharedIngredientType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedIngredientType alloc] init];
        shared.ingredientTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
