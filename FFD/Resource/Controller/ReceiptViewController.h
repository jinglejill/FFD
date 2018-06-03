//
//  ReceiptViewController.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "CustomerTable.h"
#import "ConfirmAndCancelView.h"


@interface ReceiptViewController : CustomViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwReceiptOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblNetTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblVat;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodAndBeverage;
@property (strong, nonatomic) IBOutlet UILabel *lblNetTotalFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblVatFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceChargeFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherDiscountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodDiscountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodAndBeverageFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblMemberNo;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberNo;

@property (strong, nonatomic) IBOutlet UICollectionView *colVwMemberDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMoreOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintTempReceipt;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintReceipt;
@property (strong, nonatomic) IBOutlet UILabel *lblMethodPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnCredeitCard;
@property (strong, nonatomic) IBOutlet UIButton *btnCash;
@property (strong, nonatomic) IBOutlet UIButton *btnMergeReceipt;
@property (strong, nonatomic) IBOutlet UIButton *btnCloseTable;
@property (strong, nonatomic) IBOutlet UIView *vwTopLeft;
@property (strong, nonatomic) IBOutlet UIView *vwTopMiddle;
@property (strong, nonatomic) IBOutlet UIView *vwBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnMemberRegister;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UITableView *tbvMemberRegister;
@property (strong, nonatomic) IBOutlet UILabel *lblTableName;
- (IBAction)goBack:(id)sender;
- (IBAction)addMoreOrder:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
@property (strong, nonatomic) IBOutlet ConfirmAndCancelView *vwConfirmAndCancel;
- (IBAction)registerMember:(id)sender;
@end
