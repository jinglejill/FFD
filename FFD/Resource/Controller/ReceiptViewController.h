//
//  ReceiptViewController.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//


#import "CustomViewController.h"
#import "CustomerTable.h"
#import "RewardProgram.h"
#import "ConfirmAndCancelView.h"



@interface ReceiptViewController : CustomViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>


@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwReceiptOrder;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwMemberDetail;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwRemark;
@property (strong, nonatomic) IBOutlet UITableView *tbvMemberRegister;
@property (strong, nonatomic) IBOutlet ConfirmAndCancelView *vwConfirmAndCancel;


@property (strong, nonatomic) IBOutlet UILabel *lblTotalQuantity;
@property (strong, nonatomic) IBOutlet UIButton *btnDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblAfterDiscountAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblVat;
@property (strong, nonatomic) IBOutlet UILabel *lblRounding;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteDiscount;
- (IBAction)deleteDiscount:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *txtRemark;




@property (strong, nonatomic) IBOutlet UILabel *lblFoodAndBeverageFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountAmountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblAfterDiscountAmountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceChargeFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblVatFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblRoundingFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmountFigure;




@property (strong, nonatomic) IBOutlet UIButton *btnOrderHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMoreOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintBill;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintWithAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;




@property (strong, nonatomic) IBOutlet UILabel *lblMemberNo;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberNo;
@property (strong, nonatomic) IBOutlet UIButton *btnMemberRegister;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;


@property (strong, nonatomic) IBOutlet UILabel *lblMethodPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnCredeitCard;
@property (strong, nonatomic) IBOutlet UIButton *btnCash;


@property (strong, nonatomic) IBOutlet UIButton *btnMergeReceipt;
@property (strong, nonatomic) IBOutlet UIButton *btnCloseTable;
@property (strong, nonatomic) IBOutlet UIButton *btnMoveTable;
@property (strong, nonatomic) IBOutlet UIButton *btnSplitBill;
@property (strong, nonatomic) IBOutlet UIButton *btnPaySplitBill;
@property (strong, nonatomic) IBOutlet UIButton *btnMoveOrder;


@property (strong, nonatomic) IBOutlet UIView *vwTopLeft;
@property (strong, nonatomic) IBOutlet UIView *vwTopMiddle;
@property (strong, nonatomic) IBOutlet UIView *vwBottom;
@property (strong, nonatomic) IBOutlet UILabel *lblTableName;

@property (strong, nonatomic) IBOutlet UILabel *lblPaidAmount;

@property (strong, nonatomic) IBOutlet UILabel *lblChanges;
@property (strong, nonatomic) IBOutlet UIButton *btnTransfer;


- (IBAction)unwindToReceipt:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
- (IBAction)addDiscount:(id)sender;



- (IBAction)viewOrderHistory:(id)sender;
- (IBAction)addMoreOrder:(id)sender;
- (IBAction)printBill:(id)sender;
- (IBAction)printWithAddress:(id)sender;
- (IBAction)fillInCreditCard:(id)sender;
- (IBAction)fillInCash:(id)sender;
- (IBAction)mergeReceipt:(id)sender;
- (IBAction)closeTable:(id)sender;
- (IBAction)moveTable:(id)sender;
- (IBAction)splitBill:(id)sender;
- (IBAction)moveOrder:(id)sender;
- (IBAction)transferMoney:(id)sender;





- (IBAction)registerMember:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)paySplitBill:(id)sender;






- (void)reloadMemberDetail;
- (void)reloadReceiptOrder;
- (void)updatePaidAmount;
- (void)updateTotalOrderAndAmount;

@end
