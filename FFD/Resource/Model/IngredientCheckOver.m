//
//  IngredientCheckOver.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientCheckOver.h"

@implementation IngredientCheckOver


+(NSMutableArray *)getIngredientCheckOverListWithAmountDiffLessThanZero:(NSMutableArray *)ingredientCheckOverList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_amountDiff < 0"];
    NSArray *filterArray = [ingredientCheckOverList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
