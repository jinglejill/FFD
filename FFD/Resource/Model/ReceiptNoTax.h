//
//  ReceiptNoTax.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptNoTax : NSObject
@property (retain, nonatomic) NSString * receiptNoTaxID;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger runningNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(ReceiptNoTax *)init;
+(NSString *)getNextID;
+(void)addObject:(ReceiptNoTax *)receiptNoTax;
+(void)removeObject:(ReceiptNoTax *)receiptNoTax;
+(void)addList:(NSMutableArray *)receiptNoTaxList;
+(void)removeList:(NSMutableArray *)receiptNoTaxList;
+(ReceiptNoTax *)getReceiptNoTax:(NSInteger)receiptNoTaxID;
+(NSString *)makeFormatedReceiptNoTaxWithReceiptNoTaxID:(NSString *)receiptNoTaxID;
+(NSInteger)getReceiptNoTaxCountToday;


@end
