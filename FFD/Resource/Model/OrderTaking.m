//
//  OrderTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderTaking.h"
#import "SharedOrderTaking.h"
#import "OrderNote.h"
#import "Menu.h"
#import "Utility.h"
#import "Receipt.h"
#import "MenuType.h"
#import "SubMenuType.h"
#import "OrderCancelDiscount.h"


@implementation OrderTaking

-(OrderTaking *)initWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText orderNo:(NSInteger)orderNo status:(NSInteger)status receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.orderTakingID = [OrderTaking getNextID];
        self.customerTableID = customerTableID;
        self.menuID = menuID;
        self.quantity = quantity;
        self.specialPrice = specialPrice;
        self.price = price;
        self.takeAway = takeAway;
        self.noteIDListInText = noteIDListInText;
        self.orderNo = orderNo;
        self.status = status;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
        
        
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"orderTakingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList addObject:orderTaking];
}

+(void)removeObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObject:orderTaking];
}

+(void)addList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList addObjectsFromArray:orderTakingList];
}

+(void)removeList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObjectsInArray:orderTakingList];
}

+(OrderTaking *)getOrderTaking:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText status:(NSInteger)status;
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _menuID = %ld and _takeAway = %ld and _noteIDListInText = %@ and _status = %ld",customerTableID,menuID,takeAway,noteIDListInText,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld",customerTableID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID statusList:(NSArray *)statusList
{
    NSMutableArray *allOrderTakingList = [[NSMutableArray alloc]init];
    for(NSNumber *item in statusList)
    {
        [allOrderTakingList addObjectsFromArray:[self getOrderTakingListWithCustomerTableID:customerTableID status:[item integerValue]]];
    }
    return allOrderTakingList;
}

+(NSInteger)getTotalQuantity:(NSMutableArray *)orderTakingList
{
    NSInteger sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity;
    }
    return sum;
}

+(NSInteger)getSubTotalAmount:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity*item.specialPrice;
    }
    return sum;
}

+(NSInteger)getSubTotalAmountAllowDiscount:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
        if(menuType.allowDiscount)
        {
            sum += item.quantity*item.specialPrice;
        }
    }
    return sum;
}

- (id)copyWithZone:(NSZone *)zone
{
    // Copying code here.
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Copy NSObject subclasses
        ((OrderTaking *)copy).orderTakingID = self.orderTakingID;
        ((OrderTaking *)copy).customerTableID = self.customerTableID;
        ((OrderTaking *)copy).menuID = self.menuID;
        ((OrderTaking *)copy).quantity = self.quantity;
        ((OrderTaking *)copy).specialPrice = self.specialPrice;
        ((OrderTaking *)copy).price = self.price;
        ((OrderTaking *)copy).takeAway = self.takeAway;
        [copy setNoteIDListInText:[self.noteIDListInText copyWithZone:zone]];
        ((OrderTaking *)copy).orderNo = self.orderNo;
        ((OrderTaking *)copy).status = self.status;
        ((OrderTaking *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        ((OrderTaking *)copy).replaceSelf = self.replaceSelf;
        ((OrderTaking *)copy).idInserted = self.idInserted;
        ((OrderTaking *)copy).menuOrderNo = self.menuOrderNo;
    }
    
    return copy;
}

+(NSMutableArray *)sortOrderTakingList:(NSMutableArray *)orderTakingList
{
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
        
        
//        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscount:item.orderTakingID];
//        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor5 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSSortDescriptor *sortDescriptor6 = [[NSSortDescriptor alloc] initWithKey:@"_specialPrice" ascending:NO];
//    NSSortDescriptor *sortDescriptor7 = [[NSSortDescriptor alloc] initWithKey:@"_cancelDiscountReason" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,sortDescriptor5,sortDescriptor6,nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)sortOrderTakingListAndReason:(NSMutableArray *)orderTakingList
{
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
        
        
        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscount:item.orderTakingID];
        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor5 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSSortDescriptor *sortDescriptor6 = [[NSSortDescriptor alloc] initWithKey:@"_specialPrice" ascending:NO];
    NSSortDescriptor *sortDescriptor7 = [[NSSortDescriptor alloc] initWithKey:@"_cancelDiscountReason" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,sortDescriptor5,sortDescriptor6,sortDescriptor7,nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)createSumUpOrderTakingFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList//สำหรับใบเรียกเก็บเงิน ใบเสร็จ ใบกำกับภาษี ไม่สนตัวโน้ต สนใจราคา
{
    if([orderTakingList count] == 0)
    {
        return orderTakingList;
    }
    
    NSArray *sortArray = [OrderTaking sortOrderTakingList:orderTakingList];
    
    
    
    NSMutableArray *rearrangeList = [[NSMutableArray alloc]init];// orderTakingList ใหม่ ที่จะประกอบไปด้วย record ที่ไม่ซ้ำ และ record ที่จะ update quantity
    NSMutableArray *reservedList = [[NSMutableArray alloc]init];
    
    
    
    int i = 0;
    int j = 0;
    NSInteger previousStatus = -1;
    NSInteger previousTakeAway = -1;
    NSInteger previousMenuID = -1;
    float previousSpecialPrice = -1;
    
    
    
    for(OrderTaking *item in sortArray)
    {
        if(i == 0)
        {
            j++;
        }
        else
        {
            //เช็คว่าซ้ำกับตัวก่อนหน้าหรือไม่ ถ่้าไม่ซ้ำทำด้านล่าง
            if(item.status != previousStatus || item.takeAway != previousTakeAway || item.menuID != previousMenuID || item.specialPrice != previousSpecialPrice)
            {
                //ถ้า มี record ที่ซ้ำกัน ด้วย take away, menu, note ให้ รวม quantity
                if(j>1)
                {
                    float sumQuantity = 0;
                    for(OrderTaking *itemReserved in reservedList)
                    {
                        sumQuantity += itemReserved.quantity;
                    }
                    OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
                    orderTakingCheckIDInserted.quantity = sumQuantity;
                    [rearrangeList addObject:orderTakingCheckIDInserted];//rearrangeList เอาแค่ไปโชว์ ไม่ได้ยุ่งกับ db ไม่ต้อง check idinserted ก่อนปรับค่า quantity
                }
                else
                {
                    [rearrangeList addObject:[reservedList[0] copy]];
                }
                
                [reservedList removeAllObjects];
                j = 1;
            }
            else //ถ้าซ้ำกับตัวก่อนหน้า
            {
                j++;
            }
        }
        
        [reservedList addObject:item];
        previousStatus = item.status;
        previousTakeAway = item.takeAway;
        previousMenuID = item.menuID;
        previousSpecialPrice = item.specialPrice;

        i++;
    }
    //สำหรับตัวสุดท้าย
    if(j>1)
    {
        float sumQuantity = 0;
        for(OrderTaking *itemReserved in reservedList)
        {
            sumQuantity += itemReserved.quantity;
        }
        OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
        orderTakingCheckIDInserted.quantity = sumQuantity;
        [rearrangeList addObject:orderTakingCheckIDInserted];
    }
    else
    {
        [rearrangeList addObject:[reservedList[0] copy]];
    }
    [reservedList removeAllObjects];
    
    
    //sort
    NSMutableArray *sortOrderTakingList = [[NSMutableArray alloc]init];
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = 0 or _status = 2 or _status = 5 or _status = 6"];
        NSArray *filterArray = [rearrangeList filteredArrayUsingPredicate:predicate];
        
        
        NSArray *sortArray = [OrderTaking sortOrderTakingList:[filterArray mutableCopy]];
        [sortOrderTakingList addObjectsFromArray:sortArray];
    }
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = 3 or _status = 4"];
        NSArray *filterArray = [rearrangeList filteredArrayUsingPredicate:predicate];
        
        
        NSArray *sortArray = [OrderTaking sortOrderTakingList:[filterArray mutableCopy]];
        [sortOrderTakingList addObjectsFromArray:sortArray];
    }
    
    return sortOrderTakingList;
}

+(NSMutableArray *)createSumUpOrderTakingGroupByNoteAndPriceFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList//สำหรับแสดงที่หน้า app (receipt screen and receipt history screen)
{
    if([orderTakingList count] == 0)
    {
        return orderTakingList;
    }
    
    
    
    NSArray *sortArray = [OrderTaking sortOrderTakingListAndReason:orderTakingList];
    
    
    
    NSMutableArray *rearrangeList = [[NSMutableArray alloc]init];// orderTakingList ใหม่ ที่จะประกอบไปด้วย record ที่ไม่ซ้ำ และ record ที่จะ update quantity
    NSMutableArray *reservedList = [[NSMutableArray alloc]init];
    
    
    
    int i = 0;
    int j = 0;
    NSInteger previousStatus = -1;
    NSInteger previousTakeAway = -1;
    NSInteger previousMenuID = -1;
    NSString *previousNoteIDListInText = @"-";
    float previousSpecialPrice = -1;
    NSString *previousReason = @"-";
    
    
    for(OrderTaking *item in sortArray)
    {
        if(i == 0)
        {
            j++;
        }
        else
        {
            //เช็คว่าซ้ำกับตัวก่อนหน้าหรือไม่ ถ่้าไม่ซ้ำทำด้านล่าง
            if(item.status != previousStatus || item.takeAway != previousTakeAway || item.menuID != previousMenuID || item.noteIDListInText != previousNoteIDListInText || item.specialPrice != previousSpecialPrice || item.cancelDiscountReason != previousReason)
            {
                //ถ้า มี record ที่ซ้ำกัน ด้วย take away, menu, note ให้ รวม quantity
                if(j>1)
                {
                    float sumQuantity = 0;
                    for(OrderTaking *itemReserved in reservedList)
                    {
                        sumQuantity += itemReserved.quantity;
                    }
                    OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
                    orderTakingCheckIDInserted.quantity = sumQuantity;
                    [rearrangeList addObject:orderTakingCheckIDInserted];//rearrangeList เอาแค่ไปโชว์ ไม่ได้ยุ่งกับ db ไม่ต้อง check idinserted ก่อนปรับค่า quantity
                }
                else
                {
                    [rearrangeList addObject:[reservedList[0] copy]];
                }
                
                [reservedList removeAllObjects];
                j = 1;
            }
            else //ถ้าซ้ำกับตัวก่อนหน้า
            {
                j++;
            }
        }
        
        [reservedList addObject:item];
        previousStatus = item.status;
        previousTakeAway = item.takeAway;
        previousMenuID = item.menuID;
        previousNoteIDListInText = item.noteIDListInText;
        previousSpecialPrice = item.specialPrice;
        previousReason = item.cancelDiscountReason;
        
        i++;
    }
    //สำหรับตัวสุดท้าย
    if(j>1)
    {
        float sumQuantity = 0;
        for(OrderTaking *itemReserved in reservedList)
        {
            sumQuantity += itemReserved.quantity;
        }
        OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
        orderTakingCheckIDInserted.quantity = sumQuantity;
        [rearrangeList addObject:orderTakingCheckIDInserted];
    }
    else
    {
        [rearrangeList addObject:[reservedList[0] copy]];
    }
    [reservedList removeAllObjects];
    
    
    //sort
    NSMutableArray *sortOrderTakingList = [[NSMutableArray alloc]init];
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = 0 or _status = 2 or _status = 5 or _status = 6"];
        NSArray *filterArray = [rearrangeList filteredArrayUsingPredicate:predicate];
        
        
        NSArray *sortArray = [OrderTaking sortOrderTakingListAndReason:[filterArray mutableCopy]];
        [sortOrderTakingList addObjectsFromArray:sortArray];
    }
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = 3 or _status = 4"];
        NSArray *filterArray = [rearrangeList filteredArrayUsingPredicate:predicate];
        
        
        NSArray *sortArray = [OrderTaking sortOrderTakingListAndReason:[filterArray mutableCopy]];
        [sortOrderTakingList addObjectsFromArray:sortArray];
    }
    
    return sortOrderTakingList;
}

+(NSMutableArray *)createSumUpOrderTakingGroupByNoteFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList//for orderhistory ไม่สนราคา สนแต่ตัวอาหารที่ต้องปรุง
{
    if([orderTakingList count] == 0)
    {
        return orderTakingList;
    }
    
    NSArray *sortArray = [OrderTaking sortOrderTakingList:orderTakingList];
    
    
    
    NSMutableArray *rearrangeList = [[NSMutableArray alloc]init];// orderTakingList ใหม่ ที่จะประกอบไปด้วย record ที่ไม่ซ้ำ และ record ที่จะ update quantity
    NSMutableArray *reservedList = [[NSMutableArray alloc]init];
    
    
    
    int i = 0;
    int j = 0;
    NSInteger previousStatus = -1;
    NSInteger previousTakeAway = -1;
    NSInteger previousMenuID = -1;
    NSString *previousNoteIDListInText = @"-";
    
    
    
    for(OrderTaking *item in sortArray)
    {
        if(i == 0)
        {
            j++;
        }
        else
        {
            //เช็คว่าซ้ำกับตัวก่อนหน้าหรือไม่ ถ่้าไม่ซ้ำทำด้านล่าง
            if(item.status != previousStatus || item.takeAway != previousTakeAway || item.menuID != previousMenuID || item.noteIDListInText != previousNoteIDListInText)
            {
                //ถ้า มี record ที่ซ้ำกัน ด้วย take away, menu, note ให้ รวม quantity
                if(j>1)
                {
                    float sumQuantity = 0;
                    for(OrderTaking *itemReserved in reservedList)
                    {
                        sumQuantity += itemReserved.quantity;
                    }
                    OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
                    orderTakingCheckIDInserted.quantity = sumQuantity;
                    [rearrangeList addObject:orderTakingCheckIDInserted];//rearrangeList เอาแค่ไปโชว์ ไม่ได้ยุ่งกับ db ไม่ต้อง check idinserted ก่อนปรับค่า quantity
                }
                else
                {
                    [rearrangeList addObject:[reservedList[0] copy]];
                }
                
                [reservedList removeAllObjects];
                j = 1;
            }
            else //ถ้าซ้ำกับตัวก่อนหน้า
            {
                j++;
            }
        }
        
        [reservedList addObject:item];
        previousStatus = item.status;
        previousTakeAway = item.takeAway;
        previousMenuID = item.menuID;
        previousNoteIDListInText = item.noteIDListInText;
        i++;
    }
    //สำหรับตัวสุดท้าย
    if(j>1)
    {
        float sumQuantity = 0;
        for(OrderTaking *itemReserved in reservedList)
        {
            sumQuantity += itemReserved.quantity;
        }
        OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
        orderTakingCheckIDInserted.quantity = sumQuantity;
        [rearrangeList addObject:orderTakingCheckIDInserted];
    }
    else
    {
        [rearrangeList addObject:[reservedList[0] copy]];
    }
    [reservedList removeAllObjects];
    
    
    
    //sort
    for(OrderTaking *item in rearrangeList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,nil];
    NSArray *sortRearrangeList = [rearrangeList sortedArrayUsingDescriptors:sortDescriptors];
    

    return [sortRearrangeList mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithReceiptList:(NSMutableArray *)receiptList
{
    NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
    
    for(Receipt *item in receiptList)
    {
        NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",item.receiptID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        [orderTakingList addObjectsFromArray:filterArray];
    }
    
    return orderTakingList;
}

+(NSMutableArray *)getOrderTakingListWithMenuID:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(void)updateIdInserted:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTaking.orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        OrderTaking *updateOrderTaking = filterArray[0];
        updateOrderTaking.idInserted = 1;
    }
}

+(void)deleteOrderTakingDuplicateKey:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTaking.orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    for(int i=0; i<[filterArray count]; i++)
    {
        OrderTaking *deleteOrderTaking = filterArray[i];
        if([orderTaking.modifiedUser isEqualToString:deleteOrderTaking.modifiedUser])
        {
            [dataList removeObject:deleteOrderTaking];
            return;
        }
    }
}

+(void)insertOrderTakingDuplicateKey:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld and _idInserted = 1",orderTaking.orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return;
    }
    else
    {
        [dataList addObject:orderTaking];
    }
}

//+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID specialPrice:(float)specialPrice
//{
//    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld and _takeAway = %ld and _menuID = %ld and _specialPrice = %f",customerTableID,status,takeAway,menuID,specialPrice];
//    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
//    
//    return [filterArray mutableCopy];
//}
//
//+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID specialPrice:(float)specialPrice
//{
//    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld and _takeAway = %ld and _menuID = %ld and _specialPrice = %f",customerTableID,status,takeAway,menuID,specialPrice];
//    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
//    
//    
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_quantity" ascending:YES];
//    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderTakingID" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
//    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
//    
//    
//    if([sortArray count]>0)
//    {
//        return sortArray[0];
//    }
//    
//    return nil;
//}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID noteIDListInText:(NSString *)noteIDListInText specialPrice:(float)specialPrice cancelDiscountReason:(NSString *)cancelDiscountReason
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    for (OrderTaking *item in dataList)
    {
        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscountWithOrderTakingID:item.orderTakingID];
        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld and _takeAway = %ld and _menuID = %ld and _noteIDListInText = %@ and _specialPrice = %f and _cancelDiscountReason = %@",customerTableID,status,takeAway,menuID,noteIDListInText,specialPrice,cancelDiscountReason];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID noteIDListInText:(NSString *)noteIDListInText specialPrice:(float)specialPrice cancelDiscountReason:(NSString *)cancelDiscountReason
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    for (OrderTaking *item in dataList)
    {
        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscountWithOrderTakingID:item.orderTakingID];
        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld and _takeAway = %ld and _menuID = %ld and _noteIDListInText = %@ and _specialPrice = %f and _cancelDiscountReason = %@",customerTableID,status,takeAway,menuID,noteIDListInText,specialPrice,cancelDiscountReason];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_quantity" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderTakingID" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    if([sortArray count]>0)
    {
        return sortArray[0];
    }
    
    return nil;
}

+(BOOL)checkIdInserted:(NSMutableArray *)orderTakingList
{
    for(OrderTaking *item in orderTakingList)
    {
        if(!item.idInserted)
        {
            return NO;
        }
    }
    return YES;
}

+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld and _takeAway = %ld and _menuID = %ld",status,takeAway,menuID];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortListByNoteIDListInText:(NSMutableArray *)orderTakingList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)sortListByModifiedDateDesc:(NSMutableArray *)orderTakingList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)separateOrder:(NSMutableArray *)orderTakingList
{
    NSMutableArray *separateOrderTakingList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in orderTakingList)
    {
        for(int i=0; i<item.quantity; i++)
        {
            OrderTaking *orderTaking = [item copy];
            orderTaking.quantity = 1;
            [separateOrderTakingList addObject:orderTaking];
        }
    }
    return separateOrderTakingList;
}

+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and _branchID = %ld",receiptID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)createSumUpOrderTakingWithTheSameMenuAndNote:(NSMutableArray *)orderTakingList
{
    
    NSArray *sortArray = [OrderTaking sortOrderTakingList:orderTakingList];
    NSMutableArray *newOrderTakingList = [[NSMutableArray alloc]init];
    
    
    NSInteger countQuantity = 0;
    NSInteger previousMenuID = -1;
    NSString *strPreviousNoteIDListInText = @"-";
    
    
    for(OrderTaking *item in sortArray)
    {
        if(item.menuID != previousMenuID || ![item.noteIDListInText isEqualToString:strPreviousNoteIDListInText])
        {
            if([newOrderTakingList count]>0)
            {
                OrderTaking *lastOrderTaking = newOrderTakingList[[newOrderTakingList count]-1];
                lastOrderTaking.quantity = countQuantity;
            }
            OrderTaking *copyOrderTaking = [item copy];
            [newOrderTakingList addObject:copyOrderTaking];
            countQuantity = 1;
        }
        else
        {
            countQuantity++;
        }
        previousMenuID = item.menuID;
        strPreviousNoteIDListInText = item.noteIDListInText;
    }
    
    if([newOrderTakingList count]>0)
    {
        OrderTaking *lastOrderTaking = newOrderTakingList[[newOrderTakingList count]-1];
        lastOrderTaking.quantity = countQuantity;
    }
    
    return newOrderTakingList;
    
}

+(float)getSumSpecialPrice:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity*item.specialPrice;
    }
    return sum;
}
@end
