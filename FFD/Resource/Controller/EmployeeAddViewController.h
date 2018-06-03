//
//  EmployeeAddViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface EmployeeAddViewController : CustomViewController
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwEmployeeAdd;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goToSetting:(id)sender;
- (IBAction)confirmEmployee:(id)sender;
- (IBAction)cancelEmployee:(id)sender;

@end
