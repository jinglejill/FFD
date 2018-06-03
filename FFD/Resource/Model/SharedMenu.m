//
//  SharedMenu.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedMenu.h"

@implementation SharedMenu
@synthesize menuList;

+(SharedMenu *)sharedMenu {
    static dispatch_once_t pred;
    static SharedMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenu alloc] init];
        shared.menuList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
