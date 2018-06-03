//
//  SharedMenuIngredient.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedMenuIngredient.h"

@implementation SharedMenuIngredient
@synthesize menuIngredientList;

+(SharedMenuIngredient *)sharedMenuIngredient {
    static dispatch_once_t pred;
    static SharedMenuIngredient *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuIngredient alloc] init];
        shared.menuIngredientList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
