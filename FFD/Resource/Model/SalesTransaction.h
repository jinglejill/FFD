//
//  SalesTransaction.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesTransaction : NSObject
@property (retain, nonatomic) NSDate * receiptDate;
@property (retain, nonatomic) NSString *menuType;
@property (retain, nonatomic) NSString *menu;
@property (nonatomic) float quantity;
@property (nonatomic) float totalAmount;

@end
