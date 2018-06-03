//
//  SharedReceiptCustomerTable.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedReceiptCustomerTable : NSObject
@property (retain, nonatomic) NSMutableArray *receiptCustomerTableList;

+ (SharedReceiptCustomerTable *)sharedReceiptCustomerTable;
@end
