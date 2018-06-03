//
//  SharedBillPrint.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/14/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedBillPrint : NSObject
@property (retain, nonatomic) NSMutableArray *billPrintList;

+ (SharedBillPrint *)sharedBillPrint;
@end
