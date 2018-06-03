//
//  Member.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic) NSInteger memberID;
@property (retain, nonatomic) NSString * fullName;
@property (retain, nonatomic) NSString * nickname;
@property (retain, nonatomic) NSString * phoneNo;
@property (retain, nonatomic) NSDate * birthDate;
@property (retain, nonatomic) NSString * gender;
@property (retain, nonatomic) NSDate * memberDate;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;
-(Member *)init;
-(Member *)initWithFullName:(NSString *)fullName nickname:(NSString *)nickname phoneNo:(NSString *)phoneNo birthDate:(NSDate *)birthDate gender:(NSString *)gender memberDate:(NSDate *)memberDate;
+(NSInteger)getNextID;
+(void)addObject:(Member *)member;
+(void)removeObject:(Member *)member;
+(Member *)getMember:(NSInteger)memberID;
+(Member *)getMemberWithPhoneNo:(NSString *)phoneNo;



@end
