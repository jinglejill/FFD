//
//  ShopOpenCloseShiftTimeViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 30/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"


@interface ShopOpenCloseShiftTimeViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvTime;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (nonatomic) NSInteger type;//1=open,2=close,3=shift
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
- (IBAction)datePickerChanged:(id)sender;


@end
