//
//  RewardProgramAddViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 8/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "RewardProgram.h"


@interface RewardProgramAddViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UITableView *tbvRewardProgramAdd;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) RewardProgram *editRewardProgram;
@property (nonatomic) NSInteger type;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goBack:(id)sender;

@end
