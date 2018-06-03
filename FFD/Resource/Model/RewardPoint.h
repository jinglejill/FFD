//
//  RewardPoint.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardPoint : NSObject
@property (nonatomic) NSInteger rewardPointID;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) float point;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(RewardPoint *)initWithMemberID:(NSInteger)memberID receiptID:(NSInteger)receiptID point:(float)point status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(RewardPoint *)rewardPoint;
+(void)removeObject:(RewardPoint *)rewardPoint;
+(void)addList:(NSMutableArray *)rewardPointList;
+(void)removeList:(NSMutableArray *)rewardPointList;
+(RewardPoint *)getRewardPoint:(NSInteger)rewardPointID;
+(NSInteger)getTotalPointWithMemberID:(NSInteger)memberID;
+(RewardPoint *)getRewardPointWithReceiptID:(NSInteger)receiptID status:(NSInteger)status;
@end
