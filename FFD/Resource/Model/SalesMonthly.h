//
//  SalesMonthly.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesMonthly : NSObject
@property (retain, nonatomic) NSString *month;
@property (retain, nonatomic) NSDate * salesDate;
@property (nonatomic) float sales;
@end
