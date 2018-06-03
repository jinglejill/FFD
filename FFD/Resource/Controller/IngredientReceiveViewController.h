//
//  IngredientReceiveViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface IngredientReceiveViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblReceiveDate;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiveDate;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredientType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredientReceive;
@property (strong, nonatomic) IBOutlet UITextField *txtHistoryStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtHistoryEndDate;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnAddIngredientReceive;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnClearData;

- (IBAction)confirmAddEdit:(id)sender;
- (IBAction)clearData:(id)sender;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)addIngredientReceive:(id)sender;

@end
