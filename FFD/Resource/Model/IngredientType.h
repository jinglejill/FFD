//
//  IngredientType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientType : NSObject
@property (nonatomic) NSInteger ingredientTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(IngredientType *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(IngredientType *)ingredientType;
+(void)removeObject:(IngredientType *)ingredientType;
+(void)addList:(NSMutableArray *)ingredientTypeList;
+(void)removeList:(NSMutableArray *)ingredientTypeList;
+(IngredientType *)getIngredientType:(NSInteger)ingredientTypeID;
+(NSMutableArray *)sort:(NSMutableArray *)ingredientTypeList;
+(NSMutableArray *)getIngredientTypeListWithStatus:(NSInteger)status;
+(NSMutableArray *)getIngredientTypeListWithStatus:(NSInteger)status ingredientTypeList:(NSMutableArray *)ingredientTypeList;
+(NSMutableArray *)getIngredientTypeList;
+(void)setIngredientTypeList:(NSMutableArray *)ingredientTypeList;
-(BOOL)editIngredientType:(IngredientType *)editingIngredientType;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
@end
