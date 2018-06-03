//
//  SSCPCBBuilder.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IStarIoExtDisplayedWeightFunction.h"

@interface SSCPCBBuilder : NSObject

@property (nonatomic, readonly) NSMutableData *commands;

+ (IStarIoExtDisplayedWeightFunction *)createDisplayedWeightFunction;

+ (SSCPCBBuilder *)createCommandBuilder;

- (void)appendZeroClear;
- (void)appendUnitChange;

@end
