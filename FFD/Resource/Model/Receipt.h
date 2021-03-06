//
//  Receipt.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/23/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Receipt : NSObject
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSInteger servingPerson;
@property (nonatomic) NSInteger customerType;
@property (retain, nonatomic) NSDate * openTableDate;
@property (nonatomic) float cashAmount;
@property (nonatomic) float cashReceive;
@property (nonatomic) NSInteger creditCardType;
@property (retain, nonatomic) NSString * creditCardNo;
@property (nonatomic) float creditCardAmount;
@property (retain, nonatomic) NSDate * transferDate;
@property (nonatomic) float transferAmount;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) float discountValue;
@property (retain, nonatomic) NSString * discountReason;
@property (nonatomic) float serviceChargePercent;
@property (nonatomic) float serviceChargeValue;
@property (nonatomic) NSInteger priceIncludeVat;
@property (nonatomic) float vatPercent;
@property (nonatomic) float vatValue;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * statusRoute;
@property (retain, nonatomic) NSString * receiptNoID;
@property (retain, nonatomic) NSString * receiptNoTaxID;
@property (retain, nonatomic) NSDate * receiptDate;
@property (nonatomic) NSInteger mergeReceiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;


@property (nonatomic) NSInteger branchID;



-(Receipt *)initWithCustomerTableID:(NSInteger)customerTableID memberID:(NSInteger)memberID servingPerson:(NSInteger)servingPerson customerType:(NSInteger)customerType openTableDate:(NSDate *)openTableDate cashAmount:(float)cashAmount cashReceive:(float)cashReceive creditCardType:(NSInteger)creditCardType creditCardNo:(NSString *)creditCardNo creditCardAmount:(float)creditCardAmount transferDate:(NSDate *)transferDate transferAmount:(float)transferAmount remark:(NSString *)remark discountType:(NSInteger)discountType discountAmount:(float)discountAmount discountReason:(NSString *)discountReason status:(NSInteger)status statusRoute:(NSString *)statusRoute receiptNoID:(NSString *)receiptNoID receiptNoTaxID:(NSString *)receiptNoTaxID receiptDate:(NSDate *)receiptDate mergeReceiptID:(NSInteger)mergeReceiptID;
+(NSInteger)getNextID;
+(void)addObject:(Receipt *)receipt;
+(void)removeObject:(Receipt *)receipt;
+(void)addList:(NSMutableArray *)receiptList;
+(void)removeList:(NSMutableArray *)receiptList;
+(Receipt *)getReceipt:(NSInteger)receiptID;
+(Receipt *)getReceipt:(NSInteger)receiptID branchID:(NSInteger)branchID;
+(Receipt *)getReceiptWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSString *)getStringCreditCardType:(Receipt *)receipt;
-(id)copyWithZone:(NSZone *)zone;
+(Receipt *)copyFrom:(Receipt *)fromReceipt to:(Receipt *)toReceipt;
+(NSMutableArray *)getReceiptListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate statusList:(NSArray *)statusList;
+(NSMutableArray *)getReceiptListWithReceiptNoID:(NSString *)receiptNoID;
+(NSMutableArray *)getRemarkReceiptListWithMemeberID:(NSInteger)memberID;
+(NSMutableArray *)sortList:(NSMutableArray *)receiptList;
+(NSMutableArray *)sortListDesc:(NSMutableArray *)receiptList;
+(float)getAllCashAmountWithReceiptDate:(NSDate *)date;
+(float)getAllCreditAmountWithReceiptDate:(NSDate *)date;
+(float)getAllTransferAmountWithReceiptDate:(NSDate *)date;
+(NSMutableArray *)getReceiptListWithStatus:(NSInteger)status branchID:(NSInteger)branchID;
+(NSMutableArray *)setPrintStatus:(NSMutableArray *)receiptList;
+(NSString *)getStrStatus:(Receipt *)receipt;
+(UIColor *)getStatusColor:(Receipt *)receipt;
+(float)getTotalAmount:(Receipt *)receipt;
+(void)updateStatus:(Receipt *)receipt;
+(NSInteger)getStateBeforeLast:(Receipt *)receipt;
@end
