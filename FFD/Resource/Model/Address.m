//
//  Address.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Address.h"
#import "SharedAddress.h"
#import "Utility.h"


@implementation Address

-(Address *)init
{
    self = [super init];
    if(self)
    {
        self.addressID = 0;
        self.memberID = 0;
        self.street = @"";
        self.postCode = @"";
        self.country = @"";
        self.keyAddressFlag = 0;
        self.deliveryAddressFlag = 0;
        self.taxAddressFlag = 0;
        self.deliveryCustomerName = @"";
        self.deliveryPhoneNo = @"";
        self.taxCustomerName = @"";
        self.taxPhoneNo = @"";
        self.taxID = @"";
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

-(Address *)initWithMemberID:(NSInteger)memberID street:(NSString *)street postCode:(NSString *)postCode country:(NSString *)country keyAddressFlag:(NSInteger)keyAddressFlag deliveryAddressFlag:(NSInteger)deliveryAddressFlag taxAddressFlag:(NSInteger)taxAddressFlag deliveryCustomerName:(NSString *)deliveryCustomerName deliveryPhoneNo:(NSString *)deliveryPhoneNo taxCustomerName:(NSString *)taxCustomerName taxPhoneNo:(NSString *)taxPhoneNo taxID:(NSString *)taxID
{
    self = [super init];
    if(self)
    {
        self.addressID = [Address getNextID];
        self.memberID = memberID;
        self.street = street;
        self.postCode = postCode;
        self.country = country;
        self.keyAddressFlag = keyAddressFlag;
        self.deliveryAddressFlag = deliveryAddressFlag;
        self.taxAddressFlag = taxAddressFlag;
        self.deliveryCustomerName = deliveryCustomerName;
        self.deliveryPhoneNo = deliveryPhoneNo;
        self.taxCustomerName = taxCustomerName;
        self.taxPhoneNo = taxPhoneNo;
        self.taxID = taxID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"addressID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        NSString *strMaxID = value;
        
        return [strMaxID intValue]+1;
    }
}

+(void)addObject:(Address *)address
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    [dataList addObject:address];
}

+(void)removeObject:(Address *)address
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    [dataList removeObject:address];
}

+(Address *)getAddress:(NSInteger)addressID
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_addressID = %ld",addressID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getAddressListWithMemberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_keyAddressFlag" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_deliveryAddressFlag" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSString *)getFullAddress:(Address *)address
{
    if(address)
    {
        NSString *strStreet = [Utility isStringEmpty:address.street]?@"":[NSString stringWithFormat:@" %@",address.street];
        NSString *strPostCode = [Utility isStringEmpty:address.postCode]?@"":[NSString stringWithFormat:@" %@",address.postCode];
        NSString *strCountry = [Utility isStringEmpty:address.country]?@"":[NSString stringWithFormat:@" %@",address.country];
        NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@",strStreet,strPostCode,strCountry];
        return [Utility trimString:fullAddress];
    }
    else
    {
        return @"";
    }    
}

+(Address *)getDeliveryAddressWithMemberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld and _deliveryAddressFlag = 1",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(Address *)getTaxAddressWithMemberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedAddress sharedAddress].addressList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld and _taxAddressFlag = 1",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Address *)copy).addressID = self.addressID;
        ((Address *)copy).memberID = self.memberID;
        [copy setStreet:[self.street copyWithZone:zone]];
        [copy setPostCode:[self.postCode copyWithZone:zone]];
        [copy setCountry:[self.country copyWithZone:zone]];
        ((Address *)copy).keyAddressFlag = self.keyAddressFlag;
        ((Address *)copy).deliveryAddressFlag = self.deliveryAddressFlag;
        ((Address *)copy).taxAddressFlag = self.taxAddressFlag;
        [copy setDeliveryCustomerName:[self.deliveryCustomerName copyWithZone:zone]];
        [copy setDeliveryPhoneNo:[self.deliveryPhoneNo copyWithZone:zone]];
        [copy setTaxCustomerName:[self.taxCustomerName copyWithZone:zone]];
        [copy setTaxPhoneNo:[self.taxPhoneNo copyWithZone:zone]];
        [copy setTaxID:[self.taxID copyWithZone:zone]];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((Address *)copy).replaceSelf = self.replaceSelf;
        ((Address *)copy).idInserted = self.idInserted;
        
    }
    
    return copy;
}

-(BOOL)editAddress:(Address *)editingAddress
{
    if([self.street isEqualToString:editingAddress.street] &&
       self.postCode == editingAddress.postCode &&
       self.country == editingAddress.country &&
       self.keyAddressFlag == editingAddress.keyAddressFlag &&
       self.deliveryAddressFlag == editingAddress.deliveryAddressFlag &&
       self.taxAddressFlag == editingAddress.taxAddressFlag &&
       self.deliveryCustomerName == editingAddress.deliveryCustomerName &&
       self.deliveryPhoneNo == editingAddress.deliveryPhoneNo &&
       self.taxCustomerName == editingAddress.taxCustomerName &&
       self.taxPhoneNo == editingAddress.taxPhoneNo &&
       self.taxID == editingAddress.taxID
       )
    {
        return NO;
    }
    return YES;
}
@end
