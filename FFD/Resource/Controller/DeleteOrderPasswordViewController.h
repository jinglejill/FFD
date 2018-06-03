//
//  DeleteOrderPasswordViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/11/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "OrderTaking.h"
#import "CustomerTable.h"



@interface DeleteOrderPasswordViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) ReceiptViewController *vc;
@property (strong, nonatomic) IBOutlet UITableView *tbvPassword;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) OrderTaking *orderTaking;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (nonatomic) NSInteger cancelAll;
@end
