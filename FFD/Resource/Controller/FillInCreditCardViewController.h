//
//  FillInCreditCardViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "Receipt.h"


@interface FillInCreditCardViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvCreditCard;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (nonatomic) float totalAmount;
@property (strong, nonatomic) ReceiptViewController *vc;
@end
