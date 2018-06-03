//
//  SharedReceiptNo.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedReceiptNo.h"

@implementation SharedReceiptNo
@synthesize receiptNoList;

+(SharedReceiptNo *)sharedReceiptNo {
    static dispatch_once_t pred;
    static SharedReceiptNo *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedReceiptNo alloc] init];
        shared.receiptNoList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
