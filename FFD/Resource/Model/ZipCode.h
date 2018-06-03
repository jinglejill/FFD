//
//  ZipCode.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipCode : NSObject
@property (nonatomic) NSInteger zipCodeID;
@property (nonatomic) NSInteger subDistrictID;
@property (retain, nonatomic) NSString * subDistrictCode;
@property (retain, nonatomic) NSString * zipCode;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(ZipCode *)initWithSubDistrictID:(NSInteger)subDistrictID subDistrictCode:(NSString *)subDistrictCode zipCode:(NSString *)zipCode;
+(NSInteger)getNextID;
+(void)addObject:(ZipCode *)zipCode;
+(void)removeObject:(ZipCode *)zipCode;
+(void)addList:(NSMutableArray *)zipCodeList;
+(void)removeList:(NSMutableArray *)zipCodeList;
+(ZipCode *)getZipCode:(NSInteger)zipCodeID;
+(NSString *)getName:(NSInteger)zipCodeID;
+(NSMutableArray *)getZipCodeList;
@end
