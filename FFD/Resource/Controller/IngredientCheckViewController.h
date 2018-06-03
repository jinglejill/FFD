//
//  IngredientCheckViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface IngredientCheckViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtEndDate;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredientType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredient;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnIngredientOver;
@property (strong, nonatomic) IBOutlet UIButton *btnInventory;
- (IBAction)inventory:(id)sender;
- (IBAction)ingredientOver:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnFillInAmountEndDay;
- (IBAction)fillInAmountEndDay:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@end
