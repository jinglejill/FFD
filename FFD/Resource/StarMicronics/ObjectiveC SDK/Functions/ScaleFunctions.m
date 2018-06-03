//
//  ScaleFunctions.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleFunctions.h"

@implementation ScaleFunctions

+ (IStarIoExtDisplayedWeightFunction *)createDisplayedWeightFunction {
    return [SSCPCBBuilder createDisplayedWeightFunction];
}

+ (NSData *)createZeroClear {
    SSCPCBBuilder *builder = [SSCPCBBuilder createCommandBuilder];
    
    [builder appendZeroClear];
    
    return [builder.commands copy];
}

+ (NSData *)createUnitChange {
    SSCPCBBuilder *builder = [SSCPCBBuilder createCommandBuilder];
    
    [builder appendUnitChange];
    
    return [builder.commands copy];
}

@end
