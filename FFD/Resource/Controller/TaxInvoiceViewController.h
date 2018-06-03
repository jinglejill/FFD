//
//  TaxInvoiceViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "Receipt.h"


@interface TaxInvoiceViewController : CustomViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvMemberRegister;
@property (strong, nonatomic) IBOutlet ConfirmAndCancelView *vwConfirmAndCancel;

@property (strong, nonatomic) IBOutlet UICollectionView *colVwMemberDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintTaxInvoice;
@property (strong, nonatomic) IBOutlet UILabel *lblMemberNo;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberNo;
@property (strong, nonatomic) IBOutlet UIButton *btnMemberRegister;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) NSMutableArray *orderTakingList;
@property (strong, nonatomic) NSString *strTotalQuantity;
@property (strong, nonatomic) NSString *strSubTotalAmount;
@property (strong, nonatomic) NSString *strDiscountAmount;
@property (strong, nonatomic) NSString *strAfterDiscountAmount;
@property (strong, nonatomic) NSString *strServiceCharge;
@property (strong, nonatomic) NSString *strVat;
@property (strong, nonatomic) NSString *strRounding;
@property (strong, nonatomic) NSString *strTotalAmount;
- (IBAction)goBack:(id)sender;
- (IBAction)printTaxInvoice:(id)sender;
- (IBAction)registerMember:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

@end
