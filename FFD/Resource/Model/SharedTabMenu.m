//
//  SharedTabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 1/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedTabMenu.h"

@implementation SharedTabMenu
@synthesize tabMenuList;

+(SharedTabMenu *)sharedTabMenu {
    static dispatch_once_t pred;
    static SharedTabMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedTabMenu alloc] init];
        shared.tabMenuList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
