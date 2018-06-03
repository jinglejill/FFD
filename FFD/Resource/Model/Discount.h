//
//  Discount.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discount : NSObject
@property (nonatomic) NSInteger discountID;
@property (nonatomic) NSInteger discountAmount;
@property (nonatomic) NSInteger discountType;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Discount *)initWithDiscountAmount:(NSInteger)discountAmount discountType:(NSInteger)discountType remark:(NSString *)remark orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Discount *)discount;
+(void)removeObject:(Discount *)discount;
+(void)addList:(NSMutableArray *)discountList;
+(void)removeList:(NSMutableArray *)discountList;
+(NSMutableArray *)getDiscountListWithStatus:(NSInteger)status;
+(NSMutableArray *)sortList:(NSMutableArray *)discountList;

@end
