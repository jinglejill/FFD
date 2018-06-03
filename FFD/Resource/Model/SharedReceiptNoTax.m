//
//  SharedReceiptNoTax.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedReceiptNoTax.h"

@implementation SharedReceiptNoTax
@synthesize receiptNoTaxList;

+(SharedReceiptNoTax *)sharedReceiptNoTax {
    static dispatch_once_t pred;
    static SharedReceiptNoTax *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedReceiptNoTax alloc] init];
        shared.receiptNoTaxList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
