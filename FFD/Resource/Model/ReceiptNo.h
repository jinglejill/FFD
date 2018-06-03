//
//  ReceiptNo.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptNo : NSObject
@property (retain, nonatomic) NSString * receiptNoID;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger runningNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

//-(ReceiptNo *)init;
+(NSString *)getNextID;
+(void)addObject:(ReceiptNo *)receiptNo;
+(void)removeObject:(ReceiptNo *)receiptNo;
+(void)addList:(NSMutableArray *)receiptNoList;
+(void)removeList:(NSMutableArray *)receiptNoList;
+(ReceiptNo *)getReceiptNo:(NSInteger)receiptNoID;
+(NSString *)makeFormatedReceiptNoWithReceiptNoID:(NSString *)receiptNoID;


@end
