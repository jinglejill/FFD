//
//  Province.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property (nonatomic) NSInteger provinceID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) NSInteger geographyID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Province *)initWithName:(NSString *)name nameEn:(NSString *)nameEn geographyID:(NSInteger)geographyID;
+(NSInteger)getNextID;
+(void)addObject:(Province *)province;
+(void)removeObject:(Province *)province;
+(void)addList:(NSMutableArray *)provinceList;
+(void)removeList:(NSMutableArray *)provinceList;
+(Province *)getProvince:(NSInteger)provinceID;
+(NSString *)getName:(NSInteger)provinceID;
+(NSMutableArray *)getProvinceList;
+(NSInteger)getSelectedIndexWithName:(NSString *)name provinceList:(NSMutableArray *)provinceList;
@end
