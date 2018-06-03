//
//  SharedZipCode.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedZipCode : NSObject
@property (retain, nonatomic) NSMutableArray *zipCodeList;

+ (SharedZipCode *)sharedZipCode;
@end
