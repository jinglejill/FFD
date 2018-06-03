//
//  Ingredient.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject
@property (nonatomic) NSInteger ingredientID;
@property (nonatomic) NSInteger ingredientTypeID;
@property (nonatomic) NSInteger subIngredientTypeID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * uom;
@property (retain, nonatomic) NSString * uomSmall;
@property (nonatomic) float smallAmount;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Ingredient *)initWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID name:(NSString *)name uom:(NSString *)uom uomSmall:(NSString *)uomSmall smallAmount:(float)smallAmount orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Ingredient *)ingredient;
+(void)removeObject:(Ingredient *)ingredient;
+(void)addList:(NSMutableArray *)ingredientList;
+(void)removeList:(NSMutableArray *)ingredientList;
+(Ingredient *)getIngredient:(NSInteger)ingredientID;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID ingredientList:(NSMutableArray *)ingredientList;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status ingredientList:(NSMutableArray *)ingredientList;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID status:(NSInteger)status;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID subIngredientTypeID:(NSInteger)subIngredientTypeID;
+(NSMutableArray *)getIngredientListWithIngredientTypeID:(NSInteger)ingredientTypeID;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
-(BOOL)editIngredient:(Ingredient *)editingIngredient;
+(void)setIngredientList:(NSMutableArray *)ingredientList;
+(NSMutableArray *)getIngredientListWithStatus:(NSInteger)status;
+(NSMutableArray *)sortList:(NSMutableArray *)ingredientList;
+(NSMutableArray *)getIngredientListWithIngredientTypeStatus:(NSInteger)status ingredientList:(NSMutableArray *)ingredientList;
@end
