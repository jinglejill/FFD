//
//  SharedReceiptNo.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedReceiptNo : NSObject
@property (retain, nonatomic) NSMutableArray *receiptNoList;

+ (SharedReceiptNo *)sharedReceiptNo;

@end
