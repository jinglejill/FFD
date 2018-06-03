//
//  ReceiptCustomerTable.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptCustomerTable : NSObject
@property (nonatomic) NSInteger receiptCustomerTableID;
@property (nonatomic) NSInteger mergeReceiptID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger customerTableID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(ReceiptCustomerTable *)initWithMergeReceiptID:(NSInteger)mergeReceiptID receiptID:(NSInteger)receiptID customerTableID:(NSInteger)customerTableID;
+(NSInteger)getNextID;
+(void)addObject:(ReceiptCustomerTable *)receiptCustomerTable;
+(void)removeObject:(ReceiptCustomerTable *)receiptCustomerTable;
+(void)addList:(NSMutableArray *)receiptCustomerTableList;
+(void)removeList:(NSMutableArray *)receiptCustomerTableList;
+(ReceiptCustomerTable *)getReceiptCustomerTable:(NSInteger)receiptCustomerTableID;
+(NSMutableArray *)getReceiptCustomerTableListWithMergeReceiptID:(NSInteger)mergeReceiptID;
+(NSMutableArray *)getCustomerTableListWithMergeReceiptID:(NSInteger)mergeReceiptID;
+(NSMutableArray *)getReceiptListWithMergeReceiptID:(NSInteger)mergeReceiptID;
+(ReceiptCustomerTable *)getReceiptCustomerTableWithReceiptID:(NSInteger)receiptID customerTableID:(NSInteger)customerTableID;
@end
