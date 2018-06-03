//
//  Menu.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSString * titleThai;
@property (nonatomic) float price;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Menu *)initWithTitleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark;
+(NSInteger)getNextID;
+(void)addObject:(Menu *)menu;
+(Menu *)getMenu:(NSInteger)menuID;
+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status;
+(NSMutableArray *)reorganizeToTwoColumn:(NSMutableArray *)menuList;
@end
