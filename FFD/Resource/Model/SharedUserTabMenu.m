//
//  SharedUserTabMenu.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedUserTabMenu.h"

@implementation SharedUserTabMenu
@synthesize userTabMenuList;

+(SharedUserTabMenu *)sharedUserTabMenu {
    static dispatch_once_t pred;
    static SharedUserTabMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedUserTabMenu alloc] init];
        shared.userTabMenuList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
