//
//  UserTabMenu.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTabMenu : NSObject
@property (nonatomic) NSInteger userTabMenuID;
@property (nonatomic) NSInteger userAccountID;
@property (nonatomic) NSInteger tabMenuID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(UserTabMenu *)initWithUserAccountID:(NSInteger)userAccountID tabMenuID:(NSInteger)tabMenuID;
+(NSInteger)getNextID;
+(void)addObject:(UserTabMenu *)userTabMenu;
+(void)removeObject:(UserTabMenu *)userTabMenu;
+(void)addList:(NSMutableArray *)userTabMenuList;
+(void)removeList:(NSMutableArray *)userTabMenuList;
+(UserTabMenu *)getUserTabMenu:(NSInteger)userTabMenuID;
+(NSMutableArray *)getUserTabMenuListWithUserAccountID:(NSInteger)userAccountID;
+(UserTabMenu *)getUserTabMenuWithUserAccountID:(NSInteger)userAccountID tabMenuID:(NSInteger)tabMenuID;
@end
