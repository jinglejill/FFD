//
//  SubIngredientType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubIngredientType : NSObject
@property (nonatomic) NSInteger subIngredientTypeID;
@property (nonatomic) NSInteger ingredientTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(SubIngredientType *)initWithIngredientTypeID:(NSInteger)ingredientTypeID name:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(SubIngredientType *)subIngredientType;
+(void)removeObject:(SubIngredientType *)subIngredientType;
+(void)addList:(NSMutableArray *)subIngredientTypeList;
+(void)removeList:(NSMutableArray *)subIngredientTypeList;
+(SubIngredientType *)getSubIngredientType:(NSInteger)subIngredientTypeID;
+(NSMutableArray *)getSubIngredientTypeListWithIngredientTypeID:(NSInteger)ingredientTypeID status:(NSInteger)status;
+(NSMutableArray *)getSubIngredientTypeListWithIngredientTypeID:(NSInteger)ingredientTypeID;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
-(id)copyWithZone:(NSZone *)zone;
-(BOOL)editSubIngredientType:(SubIngredientType *)editingSubIngredientType;
@end
