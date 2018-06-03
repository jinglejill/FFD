//
//  RewardProgram.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/5/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardProgram : NSObject
@property (nonatomic) NSInteger rewardProgramID;
@property (nonatomic) NSInteger type;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (nonatomic) NSInteger salesSpent;
@property (nonatomic) float receivePoint;
@property (nonatomic) NSInteger pointSpent;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(RewardProgram *)initWithType:(NSInteger)type startDate:(NSDate *)startDate endDate:(NSDate *)endDate salesSpent:(NSInteger)salesSpent receivePoint:(float)receivePoint pointSpent:(NSInteger)pointSpent discountType:(NSInteger)discountType discountAmount:(float)discountAmount;
+(NSInteger)getNextID;
+(void)addObject:(RewardProgram *)rewardProgram;
+(void)removeObject:(RewardProgram *)rewardProgram;
+(void)addList:(NSMutableArray *)rewardProgramList;
+(void)removeList:(NSMutableArray *)rewardProgramList;
+(RewardProgram *)getRewardProgram:(NSInteger)rewardProgramID;
+(RewardProgram *)getRewardProgramCollectToday;
+(NSMutableArray *)getRewardProgramUseListToday;
+(NSInteger)getSelectedIndexWithRewardProgramList:(NSMutableArray *)rewardProgramList pointSpent:(NSInteger)pointSpent discountType:(NSInteger)discountType discountAmount:(float)discountAmount;
+(NSMutableArray *)getRewardProgramListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate  type:(NSInteger)type;

@end
