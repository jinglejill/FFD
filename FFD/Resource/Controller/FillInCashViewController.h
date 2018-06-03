//
//  FillInCashViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "Receipt.h"



@interface FillInCashViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvCash;
@property (strong, nonatomic) Receipt *receipt;
@property (nonatomic) float totalAmount;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) ReceiptViewController *vc;

@end
