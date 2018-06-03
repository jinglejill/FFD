//
//  SharedProvince.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedProvince : NSObject
@property (retain, nonatomic) NSMutableArray *provinceList;

+ (SharedProvince *)sharedProvince;
@end
