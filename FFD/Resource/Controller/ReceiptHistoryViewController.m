//
//  ReceiptHistoryViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptHistoryViewController.h"
#import "TaxInvoiceViewController.h"
#import "CustomCollectionViewCellReceiptHistoryListHeader.h"
#import "CustomCollectionViewCellReceiptHistoryList.h"
#import "CustomCollectionViewCellReceiptOrder.h"
#import "Receipt.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "ReceiptNo.h"
#import "ReceiptCustomerTable.h"
#import "CustomerTable.h"
#import "Setting.h"
#import "Address.h"
#import "CustomerTable.h"
#import "RewardPoint.h"
#import "Member.h"
#import "OrderCancelDiscount.h"
#import "CustomPrintPageRenderer.h"
#import "InvoiceComposer.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"

@interface ReceiptHistoryViewController ()
{
    NSMutableArray *_receiptList;
    NSMutableArray *_orderTakingList;//selected receipt
    NSMutableArray *_allOrderTakingList;//in period specified
    Receipt *_receipt;
    
    
    NSString *_strTotalQuantity;
    NSString *_strSubTotalAmount;
    NSString *_strDiscountAmount;
    NSString *_strAfterDiscountAmount;
    NSString *_strServiceCharge;
    NSString *_strVat;
    NSString *_strRounding;
    NSString *_strTotalAmount;
}
@end

@implementation ReceiptHistoryViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionViewCellReceiptHistoryListHeader";
static NSString * const reuseIdentifierReceiptHistoryList = @"CustomCollectionViewCellReceiptHistoryList";
static NSString * const reuseIdentifierReceiptOrder = @"CustomCollectionViewCellReceiptOrder";



@synthesize colVwReceiptHistoryList;
@synthesize colVwReceiptHistoryDetail;
@synthesize dtPicker;
@synthesize txtReceiptStartDate;
@synthesize txtReceiptEndDate;
@synthesize btnPrintReceipt;

@synthesize lblTotalQuantity;
@synthesize lblDiscount;
@synthesize lblFoodAndBeverageFigure;
@synthesize lblDiscountAmountFigure;
@synthesize lblAfterDiscountAmountFigure;
@synthesize lblServiceChargeFigure;
@synthesize lblVatFigure;
@synthesize lblRoundingFigure;
@synthesize lblTotalAmountFigure;
@synthesize vwBottom;

- (IBAction)unwindToReceiptHistory:(UIStoryboardSegue *)segue
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSDate *startDate = [Utility stringToDate:txtReceiptStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtReceiptEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptList withData:@[startDate,endDate]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:txtReceiptStartDate] || [textField isEqual:txtReceiptEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([txtReceiptStartDate isFirstResponder])
    {
        txtReceiptStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    if([txtReceiptEndDate isFirstResponder])
    {
        txtReceiptEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)printReceipt:(id)sender
{
    [self performSegueWithIdentifier:@"segTaxInvoice" sender:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    // Now modify bottomView's frame here
    {
        CGRect frame = colVwReceiptHistoryList.frame;
        frame.size.width = self.view.frame.size.width/3*2;
        colVwReceiptHistoryList.frame = frame;
    }
    
    {
        CGRect frame = colVwReceiptHistoryDetail.frame;
        frame.origin.x = colVwReceiptHistoryList.frame.origin.x+colVwReceiptHistoryList.frame.size.width+8;
        frame.size.width = self.view.frame.size.width/3-8;
        colVwReceiptHistoryDetail.frame = frame;
    }
    
    {
        CGRect frame = vwBottom.frame;
        frame.origin.x = colVwReceiptHistoryDetail.frame.origin.x;
        frame.size.width = colVwReceiptHistoryDetail.frame.size.width;
        vwBottom.frame = frame;
    }
}

- (void)loadView
{
    [super loadView];
    
    
    btnPrintReceipt.enabled = NO;

    
    
    txtReceiptStartDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtReceiptEndDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtReceiptStartDate.delegate = self;
    txtReceiptEndDate.delegate = self;
    txtReceiptStartDate.inputView = dtPicker;
    txtReceiptEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    [self setShadow:colVwReceiptHistoryList];
    [self setShadow:colVwReceiptHistoryDetail];
    [self setButtonDesign:btnPrintReceipt];
    
    
    
    NSDate *startDate = [Utility stringToDate:txtReceiptStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtReceiptEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    _receiptList = [Receipt getReceiptListWithStartDate:startDate endDate:endDate statusList:@[@2,@3,@4]];
    _allOrderTakingList = [OrderTaking getOrderTakingListWithReceiptList:_receiptList];
    _orderTakingList = [[NSMutableArray alloc]init];
}

- (void)loadViewProcess
{
    NSDate *startDate = [Utility stringToDate:txtReceiptStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtReceiptEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptList withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    colVwReceiptHistoryList.delegate = self;
    colVwReceiptHistoryList.dataSource = self;
    colVwReceiptHistoryDetail.delegate = self;
    colVwReceiptHistoryDetail.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptHistoryList bundle:nil];
        [colVwReceiptHistoryList registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptOrder bundle:nil];
        [colVwReceiptHistoryDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptOrder];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwReceiptHistoryList registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
 
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwReceiptHistoryList.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwReceiptHistoryList])
    {
        //load order มาโชว์
        return [_receiptList count];
    }
    else if([collectionView isEqual:colVwReceiptHistoryDetail])
    {
        return [_orderTakingList count];
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptHistoryDetail])
    {
        CustomCollectionViewCellReceiptOrder *cell = (CustomCollectionViewCellReceiptOrder*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptOrder forIndexPath:indexPath];
        
        
        cell.contentView.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
        
        
        
        //menu name
        OrderTaking *orderTaking = _orderTakingList[item];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        if(orderTaking.specialPrice == orderTaking.price)
        {
            cell.lblTotalPrice.textColor = [UIColor blackColor];
        }
        else
        {
            cell.lblTotalPrice.textColor = mRed;
        }
        //status = 3 -> strikethrough text
        if(orderTaking.status == 0 || orderTaking.status == 6)
        {
            if(orderTaking.takeAway)
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                               attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
        }
        else if(orderTaking.status == 4)
        {
            if(orderTaking.takeAway)
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSBaselineOffsetAttributeName:@(1.5),NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ" attributes:attribute];
                
                NSDictionary *attribute2 = @{NSBaselineOffsetAttributeName:@(1.5),NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSBaselineOffsetAttributeName:@(1.5),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:menu.titleThai attributes:attribute];
                cell.lblMenuName.attributedText = attrString;
            }
        }
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(colVwReceiptHistoryDetail.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
        CGRect frame = cell.lblMenuName.frame;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        //check ว่า status,takeaway,menu เดียวกัน มีที่ราคาไม่เท่ากัน ให้ใส่โน้ต
//        float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
//        if(sumNotePrice == 0)
//        {
//            cell.lblNote.text = @"";
//        }
//        else
        {
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                if(orderTaking.status == 0 || orderTaking.status == 6)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                else if(orderTaking.status == 4)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                if(orderTaking.status == 0 || orderTaking.status == 6)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                else if(orderTaking.status == 4)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            
            
            
            CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(colVwReceiptHistoryDetail.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            CGRect frame2 = cell.lblNote.frame;
            frame2.size.width = noteLabelSize.width;
            frame2.size.height = noteLabelSize.height;
            cell.lblNote.frame = frame2;
            
        }
        
        
        
        //total price
        NSString *strTotalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.specialPrice withMinFraction:2 andMaxFraction:2];
        if(orderTaking.status == 0 || orderTaking.status == 6)
        {
            if(orderTaking.specialPrice == orderTaking.price)
            {
                cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPrice];
                cell.lblTotalPrice.textColor = [UIColor blackColor];
            }
            else
            {
                OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscountWithOrderTakingID:orderTaking.orderTakingID];
                if(orderCancelDiscount)
                {
                    float totalPriceDiscount;
                    float takeAwayFee = [[Setting getSettingValueWithKeyName:@"takeAwayFee"] floatValue];
                    float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
                    takeAwayFee = orderTaking.takeAway?takeAwayFee:0;
                    if(orderCancelDiscount.discountType == 1)//baht
                    {
                        totalPriceDiscount = ((menu.price - orderCancelDiscount.discountAmount)+takeAwayFee+sumNotePrice)*orderTaking.quantity;
                    }
                    else//%
                    {
                        totalPriceDiscount = (menu.price * (1-orderCancelDiscount.discountAmount*0.01)+takeAwayFee+sumNotePrice)*orderTaking.quantity;
                    }
                    
                    NSString *strTotalPriceDiscount = [Utility formatDecimal:totalPriceDiscount withMinFraction:2 andMaxFraction:2];
                    cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPriceDiscount];
                    cell.lblTotalPrice.textColor = mGreen;
                }
                else
                {
                    cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPrice];
                    cell.lblTotalPrice.textColor = [UIColor redColor];
                }
            }
        }
        else if(orderTaking.status == 4)
        {
            if(orderTaking.specialPrice == orderTaking.price)
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"฿%@",strTotalPrice] attributes:attribute];
                cell.lblTotalPrice.attributedText = attrString;
                cell.lblTotalPrice.textColor = [UIColor blackColor];
            }
            else
            {
                OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscountWithOrderTakingID:orderTaking.orderTakingID];
                if(orderCancelDiscount)
                {
                    float totalPriceDiscount;
                    float takeAwayFee = [[Setting getSettingValueWithKeyName:@"takeAwayFee"] floatValue];
                    float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
                    takeAwayFee = orderTaking.takeAway?takeAwayFee:0;
                    if(orderCancelDiscount.discountType == 1)//baht
                    {
                        totalPriceDiscount = ((menu.price - orderCancelDiscount.discountAmount)+takeAwayFee+sumNotePrice)*orderTaking.quantity;
                    }
                    else//%
                    {
                        totalPriceDiscount = (menu.price * (1-orderCancelDiscount.discountAmount*0.01)+takeAwayFee+sumNotePrice)*orderTaking.quantity;
                    }
                    
                    NSString *strTotalPriceDiscount = [Utility formatDecimal:totalPriceDiscount withMinFraction:2 andMaxFraction:2];
                    UIFont *font = [UIFont systemFontOfSize:14];
                    NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"฿%@",strTotalPriceDiscount] attributes:attribute];
                    cell.lblTotalPrice.attributedText = attrString;
                    cell.lblTotalPrice.textColor = mGreen;
                }
                else
                {
                    UIFont *font = [UIFont systemFontOfSize:14];
                    NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"฿%@",strTotalPrice] attributes:attribute];
                    cell.lblTotalPrice.attributedText = attrString;
                    cell.lblTotalPrice.textColor = [UIColor redColor];
                }
            }
        }
        
        
        //original price
        NSString *strOriginalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.price withMinFraction:2 andMaxFraction:2];
        if(orderTaking.specialPrice == orderTaking.price)
        {
            cell.lblOriginalPrice.text = @"";
        }
        else
        {
            UIFont *font = [UIFont systemFontOfSize:14];
            NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"฿%@",strOriginalPrice] attributes:attribute];
            cell.lblOriginalPrice.attributedText = attrString;
        }
        
        
        //quantity
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        if(orderTaking.status == 0 || orderTaking.status == 6)
        {
            cell.lblQuantity.text = strQuantity;
        }
        else if(orderTaking.status == 4)
        {
            UIFont *font = [UIFont systemFontOfSize:14];
            NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strQuantity attributes:attribute];
            cell.lblQuantity.attributedText = attrString;
        }
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwReceiptHistoryList])
    {
        {
            CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            cell.backgroundColor = [UIColor clearColor];
            
            
            Receipt *receipt = _receiptList[item];
            CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
            NSString *strTotalAmount = [Utility formatDecimal:receipt.creditCardAmount + receipt.cashAmount withMinFraction:0 andMaxFraction:0];
            NSMutableArray *customerTableList = [ReceiptCustomerTable getCustomerTableListWithMergeReceiptID:receipt.receiptID];
            NSString *tableName;
            if([customerTableList count]>0)
            {
                tableName = [CustomerTable getTableNameListInTextWithCustomerTableList:customerTableList];
            }
            else
            {
                tableName = customerTable.tableName;
            }
            cell.lblDateTime.text = [Utility dateToString:receipt.receiptDate toFormat:@"dd MMM yyyy HH:mm"];
            cell.lblReceiptNo.text = [ReceiptNo makeFormatedReceiptNoWithReceiptNoID:receipt.receiptNoID];
            cell.lblTableName.text = tableName;
            cell.lblTotalAmount.text = strTotalAmount;
            
            
            return cell;
        }
    }
    
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptHistoryDetail])
    {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptHistoryList])
    {
        CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        NSInteger item = indexPath.item;
        _receipt = _receiptList[item];
        _orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:_receipt.receiptID orderTakingList:_allOrderTakingList];
        _orderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:_orderTakingList];
        
        
        
        [self setReceiptSummary];
        [colVwReceiptHistoryDetail reloadData];
        
        
        
        NSDate *startDate = [Utility currentDateTime];
        NSDate *endDate = [Utility currentDateTime];
        startDate = [Utility setStartOfTheDay:startDate];
        endDate = [Utility setEndOfTheDay:endDate];
        
        
        
        NSComparisonResult result = [startDate compare:_receipt.receiptDate];
        NSComparisonResult result2 = [_receipt.receiptDate compare:endDate];
        btnPrintReceipt.enabled = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptHistoryList])
    {
        CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptHistoryDetail])
    {
        //load order มาโชว์
        OrderTaking *orderTaking = _orderTakingList[item];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        
        NSString *strMenuName;
        if(orderTaking.takeAway)
        {
            strMenuName = [NSString stringWithFormat:@"ใส่ห่อ %@",menu.titleThai];
        }
        else
        {
            strMenuName = menu.titleThai;
        }
        
        
        
        //note
        float noteHeight = 0;
//        float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
//        if(sumNotePrice == 0)
//        {
//            noteHeight = 0;
//        }
//        else
        {
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            
            
            if(![Utility isStringEmpty:[strAllNote string]])
            {
                UIFont *fontNote = [UIFont systemFontOfSize:11.0];
                CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(colVwReceiptHistoryDetail.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
                noteHeight = noteLabelSize.height;
            }
        }
        
        
        
        
        UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(colVwReceiptHistoryDetail.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];
        
        
        
        //reason height
        float reasonHeight = 0;
        //        if(![Utility isStringEmpty:orderTaking.cancelDiscountReason])
        //        {
        //            UIFont *fontReason = [UIFont systemFontOfSize:11.0];
        //            CGSize reasonLabelSize = [self suggestedSizeWithFont:fontReason size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:orderTaking.cancelDiscountReason];
        //            reasonHeight = reasonLabelSize.height;
        //        }
        
        
        //specialPrice or discount by order
        float rightHeight = orderTaking.specialPrice != orderTaking.price?72:0;
        
        
        float leftHeight = menuNameLabelSize.height+noteHeight+reasonHeight+10*2;
        leftHeight = leftHeight < 49.83? 49.83:leftHeight;
        
        
        float height = leftHeight>=rightHeight?leftHeight:rightHeight;
        size = CGSizeMake(colVwReceiptHistoryDetail.frame.size.width,height);
    }
    else if([collectionView isEqual:colVwReceiptHistoryList])
    {
        size = CGSizeMake(colVwReceiptHistoryList.frame.size.width,44);
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwReceiptHistoryList.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwReceiptHistoryList reloadData];
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwReceiptHistoryDetail.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwReceiptHistoryDetail reloadData];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if([collectionView isEqual:colVwReceiptHistoryList])
        {
            CustomCollectionViewCellReceiptHistoryListHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            headerView.backgroundColor = mLightBlueColor;
            reusableview = headerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerPayment" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
    if([collectionView isEqual:colVwReceiptHistoryList])
    {
        headerSize = CGSizeMake(collectionView.bounds.size.width, 44);
    }
    
    return headerSize;
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbReceiptList)
    {
        _receiptList = [items[0] mutableCopy];
        _allOrderTakingList = [items[1] mutableCopy];
        [_orderTakingList removeAllObjects];
        lblTotalQuantity.text = @"0 รายการ";
        lblFoodAndBeverageFigure.text = @"0.00";
        lblDiscountAmountFigure.text = @"0.00";
        lblAfterDiscountAmountFigure.text = @"0.00";
        lblServiceChargeFigure.text = @"0.00";
        lblVatFigure.text = @"0.00";
        lblRoundingFigure.text = @"0.00";
        lblTotalAmountFigure.text = @"0.00";
        
        
        
        [self removeOverlayViews];
        
        
        [colVwReceiptHistoryList reloadData];
        [colVwReceiptHistoryDetail reloadData];
    }
}

-(void)setReceiptSummary//same as receipt vc
{
    NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
    NSMutableArray *status0orderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:_orderTakingList];
    NSMutableArray *status6orderTakingList = [OrderTaking getOrderTakingListWithStatus:6 orderTakingList:_orderTakingList];
    [orderTakingList addObjectsFromArray:status0orderTakingList];
    [orderTakingList addObjectsFromArray:status6orderTakingList];
    
    
    
    //total quantity
    float totalQuantity = [OrderTaking getTotalQuantity:orderTakingList];
    
    
    //sub total amount
    float subTotalAmount = [OrderTaking getSubTotalAmount:orderTakingList];
    float subTotalAmountAllowDiscount = [OrderTaking getSubTotalAmountAllowDiscount:orderTakingList];
    
    
    //discount title
    NSString *strDiscountTitle = @"ส่วนลด";
    if(_receipt.discountType == 1)
    {
        if([_receipt.discountReason isEqualToString:@"ใช้แต้ม"])
        {
            strDiscountTitle = [NSString stringWithFormat:@"%@ (ใช้แต้ม)",strDiscountTitle];
        }
    }
    else if(_receipt.discountType == 2)
    {
        NSString *strDiscountAmount = [Utility formatDecimal:_receipt.discountAmount withMinFraction:0 andMaxFraction:0];
        strDiscountTitle = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscountAmount];
        
        if([_receipt.discountReason isEqualToString:@"ใช้แต้ม"])
        {
            strDiscountTitle = [NSString stringWithFormat:@"%@ (ใช้แต้ม)",strDiscountTitle];
        }
    }
    lblDiscount.text = strDiscountTitle;
    
    
    
    //discount amount
    float discountAmount = 0;
    if(_receipt.discountType == 1)
    {
        discountAmount = _receipt.discountAmount*-1;
    }
    else if(_receipt.discountType == 2)
    {
        discountAmount = _receipt.discountAmount*0.01*subTotalAmountAllowDiscount*-1;
    }
    discountAmount = discountAmount == -0?0:discountAmount;
    
    
    float afterDiscountAmount = subTotalAmount+discountAmount;
    afterDiscountAmount = afterDiscountAmount < 0?0:afterDiscountAmount;
    float serviceCharge = afterDiscountAmount*0;
    float vat = (afterDiscountAmount + serviceCharge) * 0.07;
    float actualTotalAmount = afterDiscountAmount + serviceCharge + vat;
    float totalAmount = roundf(actualTotalAmount);
    float rounding = totalAmount-actualTotalAmount;
    
    
    _strTotalQuantity = [NSString stringWithFormat:@"%@ รายการ",[Utility formatDecimal:totalQuantity withMinFraction:0 andMaxFraction:0]];
    _strSubTotalAmount = [Utility formatDecimal:subTotalAmount withMinFraction:2 andMaxFraction:2];
    _strDiscountAmount = [Utility formatDecimal:discountAmount withMinFraction:2 andMaxFraction:2];
    _strAfterDiscountAmount = [Utility formatDecimal:afterDiscountAmount withMinFraction:2 andMaxFraction:2];
    _strServiceCharge = [Utility formatDecimal:serviceCharge withMinFraction:2 andMaxFraction:2];
    _strVat = [Utility formatDecimal:vat withMinFraction:2 andMaxFraction:2];
    _strRounding = [Utility formatDecimal:rounding withMinFraction:2 andMaxFraction:2];
    _strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
    
    
    lblTotalQuantity.text = _strTotalQuantity;
    lblFoodAndBeverageFigure.text = _strSubTotalAmount;
    lblDiscountAmountFigure.text = _strDiscountAmount;
    lblAfterDiscountAmountFigure.text = _strAfterDiscountAmount;
    lblServiceChargeFigure.text = _strServiceCharge;
    lblVatFigure.text = _strVat;
    lblRoundingFigure.text = _strRounding;
    lblTotalAmountFigure.text = _strTotalAmount;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"segTaxInvoice"])
    {
        _orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:_receipt.receiptID orderTakingList:_allOrderTakingList];
//        _orderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:_orderTakingList];
        _orderTakingList = [OrderTaking createSumUpOrderTakingGroupByNoteAndPriceFromSeveralSendToKitchen:_orderTakingList];
        
        TaxInvoiceViewController *vc = segue.destinationViewController;
        vc.receipt = _receipt;
        vc.orderTakingList = _orderTakingList;
        vc.strTotalQuantity = _strTotalQuantity;
        vc.strSubTotalAmount = _strSubTotalAmount;
        vc.strDiscountAmount = _strDiscountAmount;
        vc.strAfterDiscountAmount = _strAfterDiscountAmount;
        vc.strServiceCharge = _strServiceCharge;
        vc.strVat = _strVat;
        vc.strRounding = _strRounding;
        vc.strTotalAmount = _strTotalAmount;
    }
}
@end

