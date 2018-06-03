//
//  SharedRoleTabMenu.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRoleTabMenu : NSObject
@property (retain, nonatomic) NSMutableArray *roleTabMenuList;

+ (SharedRoleTabMenu *)sharedRoleTabMenu;
@end
