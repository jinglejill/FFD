//
//  SharedIngredientReceive.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedIngredientReceive.h"

@implementation SharedIngredientReceive
@synthesize ingredientReceiveList;

+(SharedIngredientReceive *)sharedIngredientReceive {
    static dispatch_once_t pred;
    static SharedIngredientReceive *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedIngredientReceive alloc] init];
        shared.ingredientReceiveList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
