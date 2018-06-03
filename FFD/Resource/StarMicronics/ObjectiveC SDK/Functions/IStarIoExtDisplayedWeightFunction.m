//
//  IStarIoExtDisplayedWeightFunction.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "IStarIoExtDisplayedWeightFunction.h"

@implementation IStarIoExtDisplayedWeightFunction

@synthesize completionHandler = _completionHandler;

- (id)init {
    self = [super init];
    
    if (!self){
        return nil;
    }
    
    _completionHandler = nil;
    
    _status = StarIoExtDisplayedWeightStatusInvalid;
    
    _weight = @"";
    
    return self;
}

- (NSData *)createCommands {
    return nil;
}

@end
