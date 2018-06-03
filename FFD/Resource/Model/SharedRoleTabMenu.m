//
//  SharedRoleTabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedRoleTabMenu.h"

@implementation SharedRoleTabMenu
@synthesize roleTabMenuList;

+(SharedRoleTabMenu *)sharedRoleTabMenu {
    static dispatch_once_t pred;
    static SharedRoleTabMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRoleTabMenu alloc] init];
        shared.roleTabMenuList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
