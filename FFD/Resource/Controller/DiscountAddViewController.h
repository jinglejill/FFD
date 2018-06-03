//
//  DiscountAddViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "Discount.h"


@interface DiscountAddViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbvDiscountAdd;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) Discount *editDiscount;
- (IBAction)goBack:(id)sender;
@end
