//
//  SubDistrict.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubDistrict : NSObject
@property (nonatomic) NSInteger subDistrictID;
@property (retain, nonatomic) NSString * code;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) NSInteger districtID;
@property (nonatomic) NSInteger provinceID;
@property (nonatomic) NSInteger geographyID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(SubDistrict *)initWithCode:(NSString *)code name:(NSString *)name nameEn:(NSString *)nameEn districtID:(NSInteger)districtID provinceID:(NSInteger)provinceID geographyID:(NSInteger)geographyID;
+(NSInteger)getNextID;
+(void)addObject:(SubDistrict *)subDistrict;
+(void)removeObject:(SubDistrict *)subDistrict;
+(void)addList:(NSMutableArray *)subDistrictList;
+(void)removeList:(NSMutableArray *)subDistrictList;
+(SubDistrict *)getSubDistrict:(NSInteger)subDistrictID;
+(NSString *)getName:(NSInteger)subDistrictID;
+(NSMutableArray *)getSubDistrictList;
@end
