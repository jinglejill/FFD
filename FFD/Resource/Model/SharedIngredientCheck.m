//
//  SharedIngredientCheck.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedIngredientCheck.h"

@implementation SharedIngredientCheck
@synthesize ingredientCheckList;

+(SharedIngredientCheck *)sharedIngredientCheck {
    static dispatch_once_t pred;
    static SharedIngredientCheck *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedIngredientCheck alloc] init];
        shared.ingredientCheckList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
