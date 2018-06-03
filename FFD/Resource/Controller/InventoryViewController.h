//
//  InventoryViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface InventoryViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredientType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredient;

@property (strong, nonatomic) IBOutlet UITextField *txtExpectedSales;
@property (strong, nonatomic) IBOutlet UIButton *btnIngredientCheck;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;

@property (strong, nonatomic) IBOutlet UITextField *txtSalesConStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtSalesConEndDate;
@property (strong, nonatomic) IBOutlet UIButton *btnCustomSalesByMenu;

@property (strong, nonatomic) IBOutlet UIButton *btnIngredientReceive;
- (IBAction)inputIngredientReceive:(id)sender;
- (IBAction)inputCustomSalesByMenu:(id)sender;

- (IBAction)ingredientCheck:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

- (IBAction)unwindToMaterialInventory:(UIStoryboardSegue *)segue;
@end
