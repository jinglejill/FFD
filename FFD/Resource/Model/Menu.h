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
@property (retain, nonatomic) NSString * menuCode;
@property (retain, nonatomic) NSString * titleThai;
@property (nonatomic) float price;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger subMenuTypeID;
@property (nonatomic) NSInteger subMenuType2ID;
@property (nonatomic) NSInteger subMenuType3ID;
@property (retain, nonatomic) NSString * color;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Menu *)initWithMenuCode:(NSString *)menuCode titleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID subMenuType2ID:(NSInteger)subMenuType2ID subMenuType3ID:(NSInteger)subMenuType3ID color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark;
+(NSInteger)getNextID;
+(void)addObject:(Menu *)menu;
+(void)removeObject:(Menu *)menu;
+(Menu *)getMenu:(NSInteger)menuID;
+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID;
+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status;
+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID status:(NSInteger)status;
+(NSMutableArray *)getMenuListWithMenuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
-(BOOL)editMenu:(Menu *)editingMenu;
+(void)setMenuList:(NSMutableArray *)menuList;
+(NSMutableArray *)sortList:(NSMutableArray *)menuList;
@end
