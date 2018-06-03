//
//  OrderTakingViewController.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomerTable.h"
#import "ConfirmAndCancelView.h"


@interface OrderTakingViewController : CustomViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblTableName;
@property (strong, nonatomic) IBOutlet UILabel *lblServingPerson;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet UITextField *txtTableName;
@property (strong, nonatomic) IBOutlet UITextField *txtServingPerson;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwOrderAdjust;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOrderFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceAndVat;
@property (strong, nonatomic) IBOutlet UIButton *btnMoveToTrashAll;
@property (strong, nonatomic) IBOutlet UIButton *btnSendToKitchen;
@property (strong, nonatomic) IBOutlet UIButton *btnRearrange;

@property (strong, nonatomic) IBOutlet UIView *vwTableNameAndServingPerson;
@property (strong, nonatomic) IBOutlet UIView *vwBottomLabelAndButton;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwTabMenuType;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwMenuWithTakeAway;
@property (strong, nonatomic) IBOutlet UITableView *tbvNote;
@property (strong, nonatomic) IBOutlet ConfirmAndCancelView *vwConfirmAndCancel;


- (IBAction)goBack:(id)sender;
- (IBAction)moveToTrashAll:(id)sender;
- (IBAction)sendToKitchen:(id)sender;
- (IBAction)rearrangeOrder:(id)sender;
- (IBAction)rearrangeOrderTouchDown:(id)sender;

@end
