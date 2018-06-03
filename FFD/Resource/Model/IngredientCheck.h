//
//  IngredientCheck.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientCheck : NSObject
@property (nonatomic) NSInteger ingredientCheckID;
@property (nonatomic) NSInteger ingredientID;
@property (nonatomic) float amount;
@property (nonatomic) float amountSmall;
@property (retain, nonatomic) NSDate * checkDate;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

@property (nonatomic) NSInteger ingredientTypeID;
-(IngredientCheck *)initWithIngredientID:(NSInteger)ingredientID amount:(float)amount amountSmall:(float)amountSmall checkDate:(NSDate *)checkDate;
+(NSInteger)getNextID;
+(void)addObject:(IngredientCheck *)ingredientCheck;
+(void)removeObject:(IngredientCheck *)ingredientCheck;
+(void)addList:(NSMutableArray *)ingredientCheckList;
+(void)removeList:(NSMutableArray *)ingredientCheckList;
+(IngredientCheck *)getIngredientCheck:(NSInteger)ingredientCheckID;
+(IngredientCheck *)getIngredientCheckWithIngredientID:(NSInteger)ingredientID ingredientCheckList:(NSMutableArray *)ingredientCheckList;
+(NSMutableArray *)copy:(NSMutableArray *)ingredientCheckList;
+(void)copyFrom:(NSMutableArray *)fromIngredientReceiveList to:(NSMutableArray *)toIngredientReceiveList;

@end
