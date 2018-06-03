//
//  FillInTransferMoneyViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 3/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "Receipt.h"

@interface FillInTransferMoneyViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvTransferMoney;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (nonatomic) float totalAmount;
@property (strong, nonatomic) ReceiptViewController *vc;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
- (IBAction)datePickerChanged:(id)sender;

@end
