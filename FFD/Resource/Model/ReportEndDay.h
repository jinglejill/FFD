//
//  ReportEndDay.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/25/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportEndDay : NSObject
@property (retain, nonatomic) NSString *customerType;
@property (retain, nonatomic) NSString *menuType;
@property (retain, nonatomic) NSString *subMenuType;
@property (nonatomic) NSInteger countSubMenuType;
@property (nonatomic) NSInteger countReceipt;
@property (nonatomic) NSInteger servingPerson;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) float sales;
@property (nonatomic) float discountValue;
@property (nonatomic) float vat;
@property (nonatomic) float round;



@property (nonatomic) NSInteger customerTypeID;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger creditCardTypeID;
@property (retain, nonatomic) NSString *creditCardType;
@property (nonatomic) float cashAmount;
@property (nonatomic) float creditCardAmount;






+(NSInteger)getSumQuantityWithCustomerTypeID:(NSInteger)customerTypeID menuTypeID:(NSInteger)menuTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumSalesWithCustomerTypeID:(NSInteger)customerTypeID menuTypeID:(NSInteger)menuTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(NSInteger)getSumQuantityWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumSalesWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(NSInteger)getSumQuantityWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumSalesWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumCreditCardAmountWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getDiscountValueWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumDiscountValueWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumVatWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumRoundWithReportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumDiscountValueWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumVatWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;
+(float)getSumRoundWithCustomerTypeID:(NSInteger)customerTypeID reportEndDayList:(NSMutableArray *)reportEndDayList;

@end
