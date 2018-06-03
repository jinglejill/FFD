//
//  MenuType.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuType : NSObject
@property (nonatomic) NSInteger menuTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger allowDiscount;
@property (retain, nonatomic) NSString * color;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(MenuType *)initWithName:(NSString *)name allowDiscount:(NSInteger)allowDiscount color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(MenuType *)menuType;
+(void)removeObject:(MenuType *)menuType;
+(MenuType *)getMenuType:(NSInteger)menuTypeID;
+(NSMutableArray *)getMenuTypeListWithStatus:(NSInteger)status;
+(NSMutableArray *)getMenuTypeList;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
-(BOOL)editMenuType:(MenuType *)editingMenuType;
+(void)setMenuTypeList:(NSMutableArray *)menuTypeList;
+(NSMutableArray *)sort:(NSMutableArray *)menuTypeList;
+(NSInteger)getCountMenuType;
@end
