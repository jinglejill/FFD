//
//  SharedReceiptCustomerTable.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedReceiptCustomerTable.h"

@implementation SharedReceiptCustomerTable
@synthesize receiptCustomerTableList;

+(SharedReceiptCustomerTable *)sharedReceiptCustomerTable {
    static dispatch_once_t pred;
    static SharedReceiptCustomerTable *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedReceiptCustomerTable alloc] init];
        shared.receiptCustomerTableList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
