//
//  OrderTaking.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTaking : NSObject
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) float quantity;
@property (nonatomic) float specialPrice;
@property (nonatomic) float price;
@property (nonatomic) NSInteger takeAway;
@property (retain, nonatomic) NSString * noteIDListInText;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

@property (nonatomic) NSInteger menuOrderNo;





-(OrderTaking *)initWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText orderNo:(NSInteger)orderNo status:(NSInteger)status receiptID:(NSInteger)receiptID;
+(NSInteger)getNextID;
+(void)addObject:(OrderTaking *)orderTaking;
+(void)removeObject:(OrderTaking *)orderTaking;
+(void)removeList:(NSMutableArray *)orderTakingList;
+(OrderTaking *)getOrderTaking:(NSInteger)orderTakingID;
+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText status:(NSInteger)status;
+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSMutableArray *)getOrderTakingListOccupyWithCustomerTableID:(NSInteger)customerTableID;
+(NSInteger)getTotalQuantity:(NSMutableArray *)orderTakingList;
+(NSInteger)getTotalAmount:(NSMutableArray *)orderTakingList;
@end
