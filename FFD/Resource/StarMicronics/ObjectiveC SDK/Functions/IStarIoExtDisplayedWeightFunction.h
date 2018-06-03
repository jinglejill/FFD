//
//  IStarIoExtDisplayedWeightFunction.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "IStarIoExtFunction.h"

typedef NS_ENUM(NSInteger, StarIoExtDisplayedWeightStatus) {
    StarIoExtDisplayedWeightStatusInvalid = 0,
    StarIoExtDisplayedWeightStatusZero,
    StarIoExtDisplayedWeightStatusNotInMotion,
    StarIoExtDisplayedWeightStatusMotion
};

@interface IStarIoExtDisplayedWeightFunction : IStarIoExtFunction

@property (nonatomic, readonly) StarIoExtDisplayedWeightStatus status;

@property (nonatomic, readonly) NSString *weight;

- (NSData *)createCommands;

@end
