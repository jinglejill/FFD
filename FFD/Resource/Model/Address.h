//
//  Address.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic) NSInteger addressID;
@property (nonatomic) NSInteger memberID;
@property (retain, nonatomic) NSString * street;
@property (retain, nonatomic) NSString * postCode;
@property (retain, nonatomic) NSString * country;
@property (nonatomic) NSInteger keyAddressFlag;
@property (nonatomic) NSInteger deliveryAddressFlag;
@property (nonatomic) NSInteger taxAddressFlag;
@property (retain, nonatomic) NSString * deliveryCustomerName;
@property (retain, nonatomic) NSString * deliveryPhoneNo;
@property (retain, nonatomic) NSString * taxCustomerName;
@property (retain, nonatomic) NSString * taxPhoneNo;
@property (retain, nonatomic) NSString * taxID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(Address *)init;
-(Address *)initWithMemberID:(NSInteger)memberID street:(NSString *)street postCode:(NSString *)postCode country:(NSString *)country keyAddressFlag:(NSInteger)keyAddressFlag deliveryAddressFlag:(NSInteger)deliveryAddressFlag taxAddressFlag:(NSInteger)taxAddressFlag deliveryCustomerName:(NSString *)deliveryCustomerName deliveryPhoneNo:(NSString *)deliveryPhoneNo taxCustomerName:(NSString *)taxCustomerName taxPhoneNo:(NSString *)taxPhoneNo taxID:(NSString *)taxID;
+(NSInteger)getNextID;
+(void)addObject:(Address *)address;
+(void)removeObject:(Address *)address;
+(Address *)getAddress:(NSInteger)addressID;
+(NSMutableArray *)getAddressListWithMemberID:(NSInteger)memberID;
+(NSString *)getFullAddress:(Address *)address;
+(Address *)getDeliveryAddressWithMemberID:(NSInteger)memberID;
+(Address *)getTaxAddressWithMemberID:(NSInteger)memberID;
-(BOOL)editAddress:(Address *)editingAddress;
@end
