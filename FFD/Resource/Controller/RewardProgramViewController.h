//
//  RewardProgramViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 8/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomSettingViewController.h"


@interface RewardProgramViewController : CustomSettingViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwRewardProgram;
@property (strong, nonatomic) IBOutlet UIView *lblStartDate;
@property (strong, nonatomic) IBOutlet UIView *lblEndDate;
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtEndDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segConType;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)addRewardProgram:(id)sender;
- (IBAction)segConValueChanged:(id)sender;
- (IBAction)unwindToRewardProgram:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;



@end
