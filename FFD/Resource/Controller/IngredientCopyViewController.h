//
//  IngredientCopyViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "Menu.h"


@interface IngredientCopyViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,LXReorderableCollectionViewDataSource,LXReorderableCollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwTabMenuType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwMenuWithTakeAway;
@property (strong, nonatomic) IBOutlet UITableView *tbvDetail;
@property (strong, nonatomic) IBOutlet UIView *vwTop;
@property (strong, nonatomic) IBOutlet UIButton *btnAddEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnReorder;
@property (strong, nonatomic) IBOutlet UIButton *btnAddEditSubMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnReorderSubMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnShowAll;
@property (strong, nonatomic) IBOutlet UIButton *btnShowAllSubMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblMenu;
@property (strong, nonatomic) Menu *editMenu;
@property (nonatomic) BOOL flagCopyIngredient;
//@property (nonatomic) BOOL flagCopyMenu;



- (IBAction)addEditCell:(id)sender;
- (IBAction)reorderCell:(id)sender;
- (IBAction)reorderSection:(id)sender;
- (IBAction)addEditSection:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)showAllSubMenu:(id)sender;
- (void)selectMenuType;
- (IBAction)goBack:(id)sender;


@end
