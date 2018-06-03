//
//  OrderNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNote : NSObject
@property (nonatomic) NSInteger orderNoteID;
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (nonatomic) NSInteger replaceSelf;
@property (nonatomic) NSInteger idInserted;

-(OrderNote *)initWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID;
+(NSInteger)getNextID;
+(void)addObject:(OrderNote *)orderNote;
+(void)removeObject:(OrderNote *)orderNote;
+(void)removeList:(NSMutableArray *)orderNoteList;
+(OrderNote *)getOrderNote:(NSInteger)orderNoteID;
+(OrderNote *)getOrderNoteWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID;
+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderNoteListWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderNoteListWithCustomerTableID:(NSInteger)customerTableID;
+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID;
+(NSString *)getNoteIDListInTextWithOrderTakingID:(NSInteger)orderTakingID;
+(float)getSumNotePriceWithOrderTakingID:(NSInteger)orderTakingID;
@end
