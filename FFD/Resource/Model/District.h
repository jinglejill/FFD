//
//  District.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface District : NSObject
@property (nonatomic) NSInteger districtID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) NSInteger geographyID;
@property (nonatomic) NSInteger provinceID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(District *)initWithName:(NSString *)name nameEn:(NSString *)nameEn geographyID:(NSInteger)geographyID provinceID:(NSInteger)provinceID;
+(NSInteger)getNextID;
+(void)addObject:(District *)district;
+(void)removeObject:(District *)district;
+(void)addList:(NSMutableArray *)districtList;
+(void)removeList:(NSMutableArray *)districtList;
+(District *)getDistrict:(NSInteger)districtID;
+(NSString *)getName:(NSInteger)districtID;
+(NSMutableArray *)getDistrictList;
@end
