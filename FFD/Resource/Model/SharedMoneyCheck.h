//
//  SharedMoneyCheck.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMoneyCheck : NSObject
@property (retain, nonatomic) NSMutableArray *moneyCheckList;

+ (SharedMoneyCheck *)sharedMoneyCheck;
@end
