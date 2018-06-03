//
//  MenuViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/11/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "ConfirmAndCancelView.h"
#import "Menu.h"

@interface MenuViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,LXReorderableCollectionViewDataSource,LXReorderableCollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>
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
@property (strong, nonatomic) IBOutlet UIButton *btnIngredientSetUp;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) NSMutableArray *selectedMenuList;
@property (nonatomic) BOOL selectMenu;



- (IBAction)addEditCell:(id)sender;
- (IBAction)reorderCell:(id)sender;
- (IBAction)reorderSection:(id)sender;
- (IBAction)addEditSection:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)showAllSubMenu:(id)sender;
- (IBAction)showIngredientSetUp:(id)sender;
- (IBAction)unwindToMenu:(UIStoryboardSegue *)segue;
- (void)selectMenuType;
@end
