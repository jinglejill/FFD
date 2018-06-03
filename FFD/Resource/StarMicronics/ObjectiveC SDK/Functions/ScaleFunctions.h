//
//  ScaleFunctions.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSCPCBBuilder.h"

@interface ScaleFunctions : NSObject

+ (IStarIoExtDisplayedWeightFunction *)createDisplayedWeightFunction;

+ (NSData *)createZeroClear;
+ (NSData *)createUnitChange;

@end
