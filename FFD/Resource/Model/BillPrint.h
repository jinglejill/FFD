//
//  BillPrint.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/14/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillPrint : NSObject
@property (nonatomic) NSInteger billPrintID;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSDate * billPrintDate;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(BillPrint *)initWithReceiptID:(NSInteger)receiptID billPrintDate:(NSDate *)billPrintDate;
+(NSInteger)getNextID;
+(void)addObject:(BillPrint *)billPrint;
+(void)removeObject:(BillPrint *)billPrint;
+(void)addList:(NSMutableArray *)billPrintList;
+(void)removeList:(NSMutableArray *)billPrintList;
+(BillPrint *)getBillPrint:(NSInteger)billPrintID;
+(NSMutableArray *)getBillPrintListWithReceiptID:(NSInteger)receiptID;
+(NSMutableArray *)sortListByBillPrintDateDesc:(NSMutableArray *)billPrintList;
@end
