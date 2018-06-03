//
//  BranchAddViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"


@interface BranchAddViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwBranchAdd;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
@property (strong, nonatomic) Branch *editBranch;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goToSetting:(id)sender;
- (IBAction)confirmBranch:(id)sender;
- (IBAction)cancelBranch:(id)sender;

@end
