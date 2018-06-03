//
//  SharedMoneyCheck.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMoneyCheck.h"

@implementation SharedMoneyCheck
@synthesize moneyCheckList;

+(SharedMoneyCheck *)sharedMoneyCheck {
    static dispatch_once_t pred;
    static SharedMoneyCheck *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMoneyCheck alloc] init];
        shared.moneyCheckList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
