//
//  DiscountViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptViewController.h"
#import "Discount.h"
#import "Receipt.h"
#import "CustomerTable.h"
#import "Member.h"
#import "RewardProgram.h"
#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"



@interface DiscountViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvDiscount;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) NSMutableArray *discountList;
@property (strong, nonatomic) NSMutableArray *rewardProgramList;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) ReceiptViewController *vc;
@property (strong, nonatomic) Member *member;
@property (strong, nonatomic) RewardProgram *selectedRewardProgram;
@end
