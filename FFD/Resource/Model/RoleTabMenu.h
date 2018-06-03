//
//  RoleTabMenu.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleTabMenu : NSObject
@property (nonatomic) NSInteger roleTabMenuID;
@property (nonatomic) NSInteger roleID;
@property (nonatomic) NSInteger tabMenuID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(RoleTabMenu *)initWithRoleID:(NSInteger)roleID tabMenuID:(NSInteger)tabMenuID;
+(NSInteger)getNextID;
+(void)addObject:(RoleTabMenu *)roleTabMenu;
+(void)removeObject:(RoleTabMenu *)roleTabMenu;
+(void)addList:(NSMutableArray *)roleTabMenuList;
+(void)removeList:(NSMutableArray *)roleTabMenuList;
+(RoleTabMenu *)getRoleTabMenu:(NSInteger)roleTabMenuID;
+(NSMutableArray *)createRoleTabMenuListWithRoleID:(NSInteger)roleID tabMenuType:(NSInteger)tabMenuType;
+(NSMutableArray *)getRoleTabMenuListWithRoleID:(NSInteger)roleID tabMenuType:(NSInteger)tabMenuType;
+(RoleTabMenu *)getRoleTabMenuWithRoleID:(NSInteger)roleID tabMenuID:(NSInteger)tabMenuID;


@end
