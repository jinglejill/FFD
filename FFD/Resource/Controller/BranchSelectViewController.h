//
//  BranchSelectViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 7/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface BranchSelectViewController : CustomViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UITextField *txtBranch;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
@property (strong, nonatomic) NSMutableArray *credentialsDbList;
- (IBAction)okAction:(id)sender;
@end
