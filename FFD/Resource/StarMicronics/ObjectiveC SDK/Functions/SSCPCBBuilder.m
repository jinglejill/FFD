//
//  SSCPCBBuilder.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "SSCPCBBuilder.h"

@interface DisplayedWeightFunction : IStarIoExtDisplayedWeightFunction

- (NSData *)createCommands;

@end

@implementation DisplayedWeightFunction

@synthesize status = _status;
@synthesize weight = _weight;

- (id)init {
    self = [super init];
    
    if (!self){
        return nil;
    }
    
    StarIoExtFunctionCompletionHandler handler = ^(uint8_t *buffer, int *length) {
        uint8_t *work = buffer;
        
        if (*length >= 20) {
            while (*length >= 20) {
                if (* work       == 0x0a &&
                    *(work + 19) == 0x0d) {
                    if (*(work + 1) == 'Z') {
                        _status = StarIoExtDisplayedWeightStatusZero;
                    }
                    else if (*(work + 4) == 'M') {
                        _status = StarIoExtDisplayedWeightStatusMotion;
                    }
                    else {
                        _status = StarIoExtDisplayedWeightStatusNotInMotion;
                    }
                    
                    NSMutableString *weight = [NSMutableString stringWithString:@""];
                    
                    for (int i = 6; i < 19; i++) {
//                      if (*(work + i) >= 0x20 && *(work + i) <= 0x7f) {
                        if (*(work + i) >= 0x21 && *(work + i) <= 0x7f) {
                            [weight appendFormat:@"%c", *(work + i)];
                        }
                    }
                    
                    _weight = weight;
                    
                    return YES;
                }
        
                work++;
        
                *length -= 1;
            }
            
            memmove(buffer, work, 20 - 1);
        }
        
        return NO;
    };
    
    self.completionHandler = handler;
    
    _status = StarIoExtDisplayedWeightStatusInvalid;
    _weight = @"";
    
    return self;
}

- (NSData *)createCommands {
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    unsigned char data[] = {0x0a, 'W', 0x0d};
    
    [commands appendBytes:data length:sizeof(data)];
    
    return commands;
}

@end

@implementation SSCPCBBuilder

+ (IStarIoExtDisplayedWeightFunction *)createDisplayedWeightFunction {
    return [[DisplayedWeightFunction alloc] init];
}

+ (SSCPCBBuilder *)createCommandBuilder {
    return [[SSCPCBBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _commands = [[NSMutableData alloc] init];
    
    return self;
}

- (void)appendZeroClear {
    unsigned char data[] = {0x0a, 'Z', 0x0d};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendUnitChange {
    unsigned char data[] = {0x0a, 'U', 0x0d};
    
    [_commands appendBytes:data length:sizeof(data)];
}

@end
