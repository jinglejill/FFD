//
//  MenuIngredient.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuIngredient : NSObject
@property (nonatomic) NSInteger menuIngredientID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) NSInteger ingredientID;
@property (nonatomic) float amount;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(MenuIngredient *)initWithMenuID:(NSInteger)menuID ingredientID:(NSInteger)ingredientID amount:(float)amount;
+(NSInteger)getNextID;
+(void)addObject:(MenuIngredient *)menuIngredient;
+(void)removeObject:(MenuIngredient *)menuIngredient;
+(void)addList:(NSMutableArray *)menuIngredientList;
+(void)removeList:(NSMutableArray *)menuIngredientList;
+(MenuIngredient *)getMenuIngredient:(NSInteger)menuIngredientID;
+(NSMutableArray *)getMenuIngredientListWithMenuID:(NSInteger)menuID;
+(MenuIngredient *)getMenuIngredientWithMenuID:(NSInteger)menuID ingredientID:(NSInteger)ingredientID;
+(NSMutableArray *)getMenuIngredientListWithIngredientID:(NSInteger)ingredientID;
-(BOOL)editMenuIngredient:(MenuIngredient *)editingMenuIngredient;
@end
