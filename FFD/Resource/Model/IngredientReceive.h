//
//  IngredientReceive.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientReceive : NSObject
@property (nonatomic) NSInteger ingredientReceiveID;
@property (nonatomic) NSInteger ingredientID;
@property (nonatomic) float amount;
@property (nonatomic) float amountSmall;
@property (nonatomic) float price;
@property (retain, nonatomic) NSDate * receiveDate;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;



-(IngredientReceive *)initWithIngredientID:(NSInteger)ingredientID amount:(float)amount amountSmall:(float)amountSmall price:(float)price receiveDate:(NSDate *)receiveDate;
+(NSInteger)getNextID;
+(void)addObject:(IngredientReceive *)ingredientReceive;
+(void)removeObject:(IngredientReceive *)ingredientReceive;
+(void)addList:(NSMutableArray *)ingredientReceiveList;
+(void)removeList:(NSMutableArray *)ingredientReceiveList;
+(IngredientReceive *)getIngredientReceive:(NSInteger)ingredientReceiveID;
+(NSMutableArray *)getIngredientReceiveList;

+(NSMutableArray *)getIngredientReceiveListWithIngredientTypeID:(NSInteger)ingredientTypeID ingredientReceiveList:(NSMutableArray *)ingredientReceiveList;
+(NSMutableArray *)copy:(NSMutableArray *)ingredientReceiveList;
+(NSMutableArray *)getIngredientReceiveListWithReceiveDate:(NSDate *)receiveDate ingredientReceiveList:(NSMutableArray *)ingredientReceiveList;
+(NSMutableArray *)sortList:(NSMutableArray *)ingredientReceiveList;
+(NSMutableArray *)sortListByReceiveDate:(NSMutableArray *)ingredientReceiveList;
+(IngredientReceive *)getIngredientReceiveWithIngredientID:(NSInteger)ingredientID ingredientReceiveList:(NSMutableArray *)ingredientReceiveList;
+(void)copyFrom:(NSMutableArray *)fromIngredientReceiveList to:(NSMutableArray *)toIngredientReceiveList;
@end
