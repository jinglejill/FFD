//
//  PromotionViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 3/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSettingViewController.h"

@interface PromotionViewController : CustomSettingViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwPromotion;
@property (strong, nonatomic) IBOutlet UIView *lblStartDate;
@property (strong, nonatomic) IBOutlet UIView *lblEndDate;
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtEndDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)addPromotion:(id)sender;
- (IBAction)selectItems:(id)sender;
- (IBAction)doAction:(id)sender;
- (IBAction)unwindToPromotion:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;
- (void)getDataList;
- (IBAction)goBack:(id)sender;
@end

