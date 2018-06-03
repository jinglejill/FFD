//
//  SharedIngredient.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedIngredient.h"

@implementation SharedIngredient
@synthesize ingredientList;

+(SharedIngredient *)sharedIngredient {
    static dispatch_once_t pred;
    static SharedIngredient *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedIngredient alloc] init];
        shared.ingredientList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
