//
//  IngredientCheckOver.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientCheckOver : NSObject
@property (nonatomic) NSInteger ingredientID;
@property (retain, nonatomic) NSString * ingredientName;
@property (nonatomic) float amountBeforePeriod;
@property (nonatomic) float amountReceivePeriod;
@property (nonatomic) float amountEndDay;
@property (nonatomic) float amountSmallEndDay;
@property (nonatomic) float amountSupposedToUse;
@property (nonatomic) float amountSupposedToBeLeft;
@property (nonatomic) float amountActualUse;
@property (nonatomic) float amountDiff;
@property (retain, nonatomic) NSString * uom;
@property (retain, nonatomic) NSString * uomSmall;
@property (nonatomic) float smallAmount;
@property (nonatomic) NSInteger checkStockAtBeforePeriod;

+(NSMutableArray *)getIngredientCheckOverListWithAmountDiffLessThanZero:(NSMutableArray *)ingredientCheckOverList;
@end
