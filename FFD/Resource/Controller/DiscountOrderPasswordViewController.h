//
//  DiscountOrderPasswordViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "OrderTaking.h"
#import "OrderCancelDiscount.h"


@interface DiscountOrderPasswordViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbvDiscountOrder;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) ReceiptViewController *vc;
@property (strong, nonatomic) OrderTaking *orderTaking;
@property (nonatomic) NSInteger discountAll;
//@property (nonatomic) OrderCancelDiscount *orderCancelDiscount;
@property (nonatomic) NSMutableArray *editOrderCancelDiscountList;

@end
