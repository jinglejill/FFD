//
//  IngredientSetUpViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "Menu.h"


@interface IngredientSetUpViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,LXReorderableCollectionViewDataSource,LXReorderableCollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwTabIngredientType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwIngredient;
@property (strong, nonatomic) IBOutlet UITableView *tbvMenuIngredient;
@property (strong, nonatomic) IBOutlet UIView *vwTop;


@property (strong, nonatomic) IBOutlet UIButton *btnAddEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnReorder;
@property (strong, nonatomic) IBOutlet UIButton *btnAddEditSubIngredientType;
@property (strong, nonatomic) IBOutlet UIButton *btnReorderSubIngredientType;
@property (strong, nonatomic) IBOutlet UIButton *btnShowAll;
@property (strong, nonatomic) IBOutlet UIButton *btnShowAllSubIngredientType;
@property (strong, nonatomic) IBOutlet UILabel *lblMenu;

@property (strong, nonatomic) Menu *editMenu;
@property (nonatomic) NSInteger edit;






- (IBAction)addEditCell:(id)sender;
- (IBAction)reorderCell:(id)sender;
- (IBAction)reorderSection:(id)sender;
- (IBAction)addEditSection:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)showAllSubIngredientType:(id)sender;
- (IBAction)goBack:(id)sender;


@end
