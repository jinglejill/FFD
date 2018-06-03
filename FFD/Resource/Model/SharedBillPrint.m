//
//  SharedBillPrint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/14/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedBillPrint.h"

@implementation SharedBillPrint
@synthesize billPrintList;

+(SharedBillPrint *)sharedBillPrint {
    static dispatch_once_t pred;
    static SharedBillPrint *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedBillPrint alloc] init];
        shared.billPrintList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
