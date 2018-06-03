//
//  TabMenu.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabMenu : NSObject
@property (nonatomic) NSInteger tabMenuID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(TabMenu *)initWithName:(NSString *)name type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(TabMenu *)tabMenu;
+(void)removeObject:(TabMenu *)tabMenu;
+(void)addList:(NSMutableArray *)tabMenuList;
+(void)removeList:(NSMutableArray *)tabMenuList;
+(TabMenu *)getTabMenu:(NSInteger)tabMenuID;
+(NSMutableArray *)getTabMenuListWithType:(NSInteger)type;


@end
