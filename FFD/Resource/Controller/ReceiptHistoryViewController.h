//
//  ReceiptHistoryViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface ReceiptHistoryViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwReceiptHistoryList;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwReceiptHistoryDetail;
@property (strong, nonatomic) IBOutlet UIView *lblReceiptStartDate;
@property (strong, nonatomic) IBOutlet UIView *lblReceiptEndDate;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiptStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiptEndDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnPrintReceipt;



@property (strong, nonatomic) IBOutlet UILabel *lblTotalQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblAfterDiscountAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblVat;
@property (strong, nonatomic) IBOutlet UILabel *lblRounding;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;


@property (strong, nonatomic) IBOutlet UILabel *lblFoodAndBeverageFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountAmountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblAfterDiscountAmountFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceChargeFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblVatFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblRoundingFigure;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmountFigure;

@property (strong, nonatomic) IBOutlet UIView *vwBottom;


- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)printReceipt:(id)sender;
- (IBAction)unwindToReceiptHistory:(UIStoryboardSegue *)segue;

@end
