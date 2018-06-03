//
//  ReceiptViewController.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptViewController.h"
#import "OrderTakingViewController.h"
#import "AddressViewController.h"
#import "DiscountViewController.h"
#import "FillInCreditCardViewController.h"
#import "FillInCashViewController.h"
#import "FillInTransferMoneyViewController.h"
#import "SelectCustomerTableToMergeViewController.h"
#import "SelectCustomerTableToMoveViewController.h"
#import "OrderHistoryViewController.h"
#import "DeleteOrderPasswordViewController.h"
#import "DiscountOrderPasswordViewController.h"
#import "CustomerTable.h"
#import "OrderTaking.h"
#import "OrderKitchen.h"
#import "Menu.h"
#import "OrderNote.h"
#import "Member.h"
#import "Address.h"
#import "Receipt.h"
#import "Discount.h"
#import "Setting.h"
#import "UserAccount.h"
#import "RewardProgram.h"
#import "RewardPoint.h"
#import "ReceiptNo.h"
#import "ReceiptCustomerTable.h"
#import "TableTaking.h"
#import "BillPrint.h"
#import "RoleTabMenu.h"
#import "CustomCollectionViewCellReceiptOrder.h"
#import "CustomCollectionViewCellMemberDetail.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelSegment.h"
#import "CustomCollectionViewCellAddAddress.h"
#import "CustomCollectionViewCellRemarkHeader.h"
#import "CustomCollectionViewCellRemark.h"
#import "ConfirmAndCancelView.h"
#import "CustomPrintPageRenderer.h"
#import "InvoiceComposer.h"



//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"




@interface ReceiptViewController ()
{
    NSMutableArray *_orderTakingList;
    Member *_member;
    NSInteger _memberDetailNoOfItem;
    NSMutableArray *_addressList;
    Receipt *_receipt;
    NSString *_strTotalQuantity;
    NSString *_strSubTotalAmount;
    NSString *_strDiscountAmount;
    NSString *_strAfterDiscountAmount;
    NSString *_strServiceCharge;
    NSString *_strVat;
    NSString *_strRounding;
    NSString *_strTotalAmount;
    
    float _totalAmount;
    UIWebView *_webview;
    UIView *_backgroundView;
    NSMutableArray *_receiptCustomerTableList;
    BOOL _bill;//bill or abbrReceipt
    Member *_editingMember;
    Receipt *_splitReceipt;
    Receipt *_usingReceipt;
    BOOL _splitBillStatus;
    BOOL _moveOrderStatus;
    BOOL _waitingForItemsInserted;
    BOOL _needSeparateOrder;
    NSMutableArray *_remarkReceiptList;

}
@end

@implementation ReceiptViewController
static NSString * const reuseIdentifierReceiptOrder = @"CustomCollectionViewCellReceiptOrder";
static NSString * const reuseIdentifierMemberDetail = @"CustomCollectionViewCellMemberDetail";
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelSegment = @"CustomTableViewCellLabelSegment";
static NSString * const reuseIdentifierAddAddress = @"CustomCollectionViewCellAddAddress";
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionViewCellRemarkHeader";
static NSString * const reuseIdentifierRemark = @"CustomCollectionViewCellRemark";


//static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
//static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
//static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;//216;
//static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;//162;
//CGFloat animatedDistance;



@synthesize customerTable;
@synthesize txtMemberNo;
@synthesize colVwReceiptOrder;
@synthesize colVwMemberDetail;
@synthesize btnCash;
@synthesize btnCloseTable;
@synthesize btnCredeitCard;
@synthesize btnAddMoreOrder;
@synthesize btnMergeReceipt;
@synthesize btnPrintBill;
@synthesize btnPrintWithAddress;
@synthesize vwTopLeft;
@synthesize vwBottom;
@synthesize vwTopMiddle;
@synthesize lblMemberNo;
@synthesize lblTableName;
@synthesize lblTotalQuantity;
@synthesize btnDiscount;
@synthesize lblFoodAndBeverageFigure;
@synthesize lblDiscountAmountFigure;
@synthesize lblAfterDiscountAmountFigure;
@synthesize lblServiceChargeFigure;
@synthesize lblVatFigure;
@synthesize lblRoundingFigure;
@synthesize lblTotalAmountFigure;
@synthesize btnDeleteDiscount;
@synthesize btnOrderHistory;
@synthesize btnMoveTable;
@synthesize btnSplitBill;
@synthesize lblPaidAmount;
@synthesize lblChanges;
@synthesize btnPaySplitBill;
@synthesize btnBack;
@synthesize tbvMemberRegister;
@synthesize vwConfirmAndCancel;
@synthesize dtPicker;
@synthesize txtRemark;
@synthesize colVwRemark;
@synthesize btnMoveOrder;
@synthesize btnTransfer;


- (IBAction)unwindToReceipt:(UIStoryboardSegue *)segue
{
    [self loadViewProcess];
    if([segue.sourceViewController isMemberOfClass:[SelectCustomerTableToMergeViewController class]])
    {
        if(_receipt.mergeReceiptID != 0)//merge bill
        {
            btnBack.enabled = NO;
            btnAddMoreOrder.enabled = NO;
            btnMoveTable.enabled = NO;
            btnSplitBill.enabled = NO;
            btnMoveOrder.enabled = NO;
        }
        else//normal
        {
            btnBack.enabled = YES;
            btnAddMoreOrder.enabled = YES;
            btnMoveTable.enabled = YES;
            btnSplitBill.enabled = YES;
            btnMoveOrder.enabled = YES;
        }
    }
    else if([segue.sourceViewController isMemberOfClass:[SelectCustomerTableToMoveViewController class]])
    {
        //move order
        if(_moveOrderStatus)
        {
            [self getOrderTaking];
            [self updateTotalOrderAndAmount];
            [self updatePaidAmount];
            [colVwReceiptOrder reloadData];
        }
    }
}

//-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
//{
//    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
//    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
//    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
//    CGFloat numerator =  midline - viewRect.origin.y  - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
//    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
//    * viewRect.size.height;
//    CGFloat heightFraction = numerator / denominator;
//    if (heightFraction < 0.0)
//    {
//        heightFraction = 0.0;
//    }
//    else if (heightFraction > 1.0)
//    {
//        heightFraction = 1.0;
//    }
//
//
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait ||
//        orientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);//+30+2*8;
//    }
//    else
//    {
//        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);//+30+2*8;
//    }
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y -= animatedDistance;
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
//    return YES;
//}
//
//- (BOOL) textFieldShouldEndEditing:(UITextField*)textField
//{
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y += animatedDistance;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:txtRemark])
    {
        [self selectReceipt];
        _usingReceipt.remark = [Utility trimString:txtRemark.text];
        _usingReceipt.modifiedUser = [Utility modifiedUser];
        _usingReceipt.modifiedDate = [Utility currentDateTime];
    }
    else if([textField isEqual:txtMemberNo])
    {
        //get member detail
        NSString *phoneNo = [Utility trimString:txtMemberNo.text];
        _member = [Member getMemberWithPhoneNo:phoneNo];
        [self selectReceipt];
        if(_member)
        {
            //update receipt
            if(_usingReceipt.memberID != _member.memberID)
            {
                RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_usingReceipt.receiptID status:0];
                if(rewardPoint)
                {
                    [RewardPoint removeObject:rewardPoint];
                }
            }
            
            _usingReceipt.memberID = _member.memberID;
            _usingReceipt.modifiedUser = [Utility modifiedUser];
            _usingReceipt.modifiedDate = [Utility currentDateTime];
        }
        else
        {
            RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_usingReceipt.receiptID status:0];
            if(rewardPoint)
            {
                [RewardPoint removeObject:rewardPoint];
            }
            
            //update receipt
            _usingReceipt.memberID = 0;
            _usingReceipt.modifiedUser = [Utility modifiedUser];
            _usingReceipt.modifiedDate = [Utility currentDateTime];
        }
        
        [self reloadMemberDetail];
        
        
        if(_member)
        {
            _remarkReceiptList = [Receipt getRemarkReceiptListWithMemeberID:_member.memberID];
            [colVwRemark reloadData];
        }
        else
        {
            _remarkReceiptList = [[NSMutableArray alloc]init];
        }
        
    }
    switch (textField.tag) {
        case 1:
            _editingMember.fullName = [Utility trimString:textField.text];
            break;
        case 2:
            _editingMember.nickname = [Utility trimString:textField.text];
            break;
        case 3:
            _editingMember.phoneNo = [Utility trimString:textField.text];
            break;
        case 4:
            _editingMember.birthDate = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 4)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            NSInteger year = [[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy"] integerValue];
            NSString *strDefaultDate = [NSString stringWithFormat:@"01/01/%ld",year-20];
            NSDate *datePeriod = [Utility stringToDate:strDefaultDate fromFormat:@"dd/MM/yyyy"];
            [dtPicker setDate:datePeriod];
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"d MMM yyyy"];
            [dtPicker setDate:datePeriod];
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:4];
    if([textField isFirstResponder])
    {
        textField.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)paySplitBill:(id)sender
{
    if(_moveOrderStatus)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        if([selectedIndexPath count] == 0)
        {
            [self showAlert:@"" message:@"กรุณาเลือกรายการที่ต้องการย้าย"];
            return;
        }
        
        
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3,@5]];
        if([orderTakingList count] == [_orderTakingList count])
        {
            _needSeparateOrder = NO;
        }
        else
        {
            _needSeparateOrder = YES;
        }
        [self performSegueWithIdentifier:@"segSelectCustomerTableToMove" sender:self];
    }
    else//pay split bill
    {
        if(![self validateReceipt])
        {
            return;
        }
        
        _waitingForItemsInserted = YES;
        [self loadingOverlayView];
        [self selectReceipt];
        
        
        //billPrint
        NSMutableArray *billPrintList = [BillPrint getBillPrintListWithReceiptID:_usingReceipt.receiptID];
        
        
        //reward point
        NSMutableArray *rewardPointList = [[NSMutableArray alloc]init];
        
        
        //insert reward collect
        RewardProgram *rewardProgramCollect = [RewardProgram getRewardProgramCollectToday];
        if(rewardProgramCollect && _member)
        {
            float point = _totalAmount/rewardProgramCollect.salesSpent*rewardProgramCollect.receivePoint;
            RewardPoint *rewardPoint = [[RewardPoint alloc]initWithMemberID:_member.memberID receiptID:0 point:point status:1];
            [RewardPoint addObject:rewardPoint];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        //update rewardpoint ใช้ไป (มีการ insert ตอนกดใช้ใน function discount)
        RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_usingReceipt.receiptID status:0];
        if(rewardPoint)
        {
            rewardPoint.status = -1;
            rewardPoint.modifiedUser = [Utility modifiedUser];
            rewardPoint.modifiedDate = [Utility currentDateTime];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        //update ordertaking
        NSMutableArray *status5OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:5];
        NSMutableArray *inDbOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
        NSMutableArray *inDbOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:inDbOrderTakingList];
        NSMutableArray *inDbOrderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:inDbOrderTakingList];
        NSMutableArray *splitOrderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *splitOrderNoteList = [[NSMutableArray alloc]init];
        NSMutableArray *splitOrderKitchenList = [[NSMutableArray alloc]init];
        if([status5OrderTakingList count] == 0)//ครั้งแรกที่ splitbill ให้ separate order ออกมาลง db
        {
            //split item one by one
            for(OrderTaking *item in inDbOrderTakingList)
            {
                for(int i=0; i<item.quantity; i++)
                {
                    OrderTaking *orderTaking = [item copy];
                    orderTaking.orderTakingID = [OrderTaking getNextID];
                    orderTaking.quantity = 1;
                    [OrderTaking addObject:orderTaking];
                    [splitOrderTakingList addObject:orderTaking];
                    
                    
                    
                    //create new orderNote
                    NSMutableArray *newOrderNoteList = [[NSMutableArray alloc]init];
                    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
                    for(OrderNote *item in orderNoteList)
                    {
                        OrderNote *orderNote = [item copy];
                        orderNote.orderNoteID = [OrderNote getNextID];
                        orderNote.orderTakingID = orderTaking.orderTakingID;
                        [OrderNote addObject:orderNote];
                        [newOrderNoteList addObject:orderNote];
                    }
                    [splitOrderNoteList addObjectsFromArray:newOrderNoteList];
                    
                    
                    
                    
                    //create new orderKitchen
                    OrderKitchen *selectedOrderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:item.orderTakingID];
                    OrderKitchen *orderKitchen = [selectedOrderKitchen copy];
                    orderKitchen.orderKitchenID = [OrderKitchen getNextID];
                    orderKitchen.orderTakingID = orderTaking.orderTakingID;
                    [OrderKitchen addObject:orderKitchen];
                    [splitOrderKitchenList addObject:orderKitchen];
                }
            }
            
            
            [OrderTaking removeList:inDbOrderTakingList];
            [OrderNote removeList:inDbOrderNoteList];
            [OrderKitchen removeList:inDbOrderKitchenList];
            
            
        }
        
        NSMutableArray *orderTakingToSplitList = [[NSMutableArray alloc]init];
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        for(NSIndexPath *indexPath in selectedIndexPath)
        {
            OrderTaking *orderTaking = _orderTakingList[indexPath.item];
            OrderTaking *orderTakingToSplit = [OrderTaking getOrderTakingWithCustomerTableID:customerTable.customerTableID menuID:orderTaking.menuID takeAway:orderTaking.takeAway noteIDListInText:orderTaking.noteIDListInText status:orderTaking.status];
            orderTakingToSplit.status = 5;
            orderTakingToSplit.receiptID = _usingReceipt.receiptID;
            orderTakingToSplit.modifiedUser = [Utility modifiedUser];
            orderTakingToSplit.modifiedDate = [Utility currentDateTime];
            [orderTakingToSplitList addObject:orderTakingToSplit];
        }
        
        
        
        
        
        
        //update receipt
        float creditCardAmount = _usingReceipt.creditCardAmount > _totalAmount?_totalAmount:_usingReceipt.creditCardAmount;
        float transferAmount = _usingReceipt.transferAmount > _totalAmount - creditCardAmount?_totalAmount - creditCardAmount:_usingReceipt.transferAmount;
        float cashAmount = _usingReceipt.cashAmount > _totalAmount - creditCardAmount - transferAmount ?_totalAmount - creditCardAmount - transferAmount:_usingReceipt.cashAmount;
        _usingReceipt.customerTableID = customerTable.customerTableID;
        _usingReceipt.servingPerson = 1;
        _usingReceipt.customerType = customerTable.type;
        _usingReceipt.status = 4;
        _usingReceipt.cashAmount = cashAmount;
        _usingReceipt.creditCardAmount = creditCardAmount;
        _usingReceipt.transferAmount = transferAmount;
        _usingReceipt.receiptDate = [Utility currentDateTime];
        _usingReceipt.modifiedUser = [Utility modifiedUser];
        _usingReceipt.modifiedDate = [Utility currentDateTime];
        
        
        
        NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
        if([status5OrderTakingList count] == 0)//firsttime
        {
            {
                //delete discount of table
                _receipt.discountType = 0;
                _receipt.discountAmount = 0;
                _receipt.discountReason = @"";
                _receipt.modifiedUser = [Utility modifiedUser];
                _receipt.modifiedDate = [Utility currentDateTime];
                
                
                
                
                RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_receipt.receiptID status:0];
                if(rewardPoint)
                {
                    [RewardPoint removeObject:rewardPoint];
                    [self.homeModel deleteItems:dbRewardPoint withData:rewardPoint actionScreen:@"delete reward point from delete button in receipt screen"];
                }
                
                
                
                //clear credit card info
                _receipt.creditCardType = 0;
                _receipt.creditCardNo = @"";
                _receipt.creditCardAmount = 0;
                
                
                //clear cash info
                _receipt.cashReceive = 0;
                
                
                //clear transfer info
                _receipt.transferAmount = 0;
            }
            
            
            if([status2OrderTakingList count] == 0)//ครั้งสุดท้าย ไม่ต้อง gen receiptnoID (เป็นครั้งแรกและครั้งสุดท้ายคือจริงๆไม่ต้อง split ก้ได้)
            {
                NSArray *dataList = @[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,splitOrderTakingList,splitOrderNoteList,splitOrderKitchenList, billPrintList, rewardPointList,_usingReceipt];
                [self.homeModel insertItems:dbPaySplitBillInsertWithoutReceipt withData:dataList actionScreen:@"pay split bill first time"];
            }
            else
            {
                NSArray *dataList = @[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,splitOrderTakingList,splitOrderNoteList,splitOrderKitchenList, billPrintList, rewardPointList,_usingReceipt,_receipt];
                [self.homeModel insertItems:dbPaySplitBillInsert withData:dataList actionScreen:@"pay split bill first time"];
            }
            
        }
        else if([status2OrderTakingList count] == 0)//ครั้งสุดท้าย ไม่ต้อง gen receiptnoID
        {
            NSArray *dataList = @[billPrintList, rewardPointList,orderTakingToSplitList,_usingReceipt];
            [self.homeModel insertItems:dbPaySplitBillInsertLastOne withData:dataList actionScreen:@"update receipt and relevant table when close table in receipt screen (split bill)(no more order to pay)"];
        }
        else
        {
            NSArray *dataList = @[billPrintList, rewardPointList,orderTakingToSplitList,_usingReceipt,_receipt];
            [self.homeModel insertItems:dbPaySplitBillInsertAfterFirstTime withData:dataList actionScreen:@"update receipt and relevant table when close table in receipt screen (split bill)"];
        }
        
        //print receipt
//        NSInteger printReceipt = [[Setting getSettingValueWithKeyName:@"printReceipt"] integerValue];
//        if(printReceipt)
        {
            [self printBill:nil];
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    {
        CGRect frame = tbvMemberRegister.frame;
        frame.size.width = 350;
        frame.size.height = 264;
        tbvMemberRegister.frame = frame;
    }
    
    {
        CGRect frame = colVwReceiptOrder.frame;
        frame.size.width = self.view.frame.size.width*0.4;
        colVwReceiptOrder.frame = frame;
    }
    
    {
        CGRect frame = colVwMemberDetail.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.size.width = self.view.frame.size.width*0.6-145-29-8;
        colVwMemberDetail.frame = frame;
    }
    
    {
        CGRect frame = colVwRemark.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.size.width = self.view.frame.size.width*0.6-145-29-8;
        colVwRemark.frame = frame;
    }
    
    {
        CGRect frame = txtRemark.frame;
        frame.origin.x = self.view.frame.size.width*0.4+8;
        frame.size.width = self.view.frame.size.width*0.6-145-29-8;
        txtRemark.frame = frame;
    }
    
    {
        CGRect frame = vwTopLeft.frame;
        frame.size.width = self.view.frame.size.width*0.4;
        vwTopLeft.frame = frame;        
    }
    
    {
        CGRect frame = vwBottom.frame;
        frame.size.width = self.view.frame.size.width*0.4 + 3;
        vwBottom.frame = frame;
    }
    
    {
        CGRect frame = vwTopMiddle.frame;
        frame.origin.x = 0;//self.view.frame.size.width*0.4 + 8;
        frame.size.width = self.view.frame.size.width*0.4 + 8 + colVwMemberDetail.frame.size.width;
        vwTopMiddle.frame = frame;
    }
    
    {
        CGRect frame = lblMemberNo.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.origin.y = txtMemberNo.frame.origin.y;
        lblMemberNo.frame = frame;
    }
    
    {
        CGRect frame = txtMemberNo.frame;
        frame.origin.x = lblMemberNo.frame.origin.x+lblMemberNo.frame.size.width+8;
        frame.size.width = colVwMemberDetail.frame.size.width - lblMemberNo.frame.size.width - 8;
        txtMemberNo.frame = frame;
    }
    
    {
        CGRect frame = lblTableName.frame;
        frame.origin.x = 0;
        frame.size.width = vwTopLeft.frame.size.width;
        lblTableName.frame = frame;
        
        
    }
    
    if(((self.view.frame.size.width*0.6-8)/-3*8)/4 >= 145)
    {
        {
            CGRect frame = btnAddMoreOrder.frame;
            frame.origin.x = self.view.frame.size.width - 145;
            frame.origin.y = 16;
            frame.size.width = 145;
            frame.size.height = 50;
            btnAddMoreOrder.frame = frame;
        }
    }
    
    
    {
        CGRect frame = _backgroundView.frame;
        frame = self.view.frame;
        _backgroundView.frame = frame;
    }
}

- (void) orientationChanged:(NSNotification *)note
{
    if([tbvMemberRegister isDescendantOfView:self.view])
    {
        tbvMemberRegister.center = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
    }
    
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _editingMember = [[Member alloc]init];
    // Do any additional setup after loading the view.
    colVwReceiptOrder.delegate = self;
    colVwReceiptOrder.dataSource = self;
    colVwMemberDetail.delegate = self;
    colVwMemberDetail.dataSource = self;
    colVwRemark.delegate = self;
    colVwRemark.dataSource = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptOrder bundle:nil];
        [colVwReceiptOrder registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptOrder];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMemberDetail bundle:nil];
        [colVwMemberDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMemberDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierAddAddress bundle:nil];
        [colVwMemberDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierAddAddress];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRemark bundle:nil];
        [colVwRemark registerNib:nib forCellWithReuseIdentifier:reuseIdentifierRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwRemark registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    
    
    [[NSBundle mainBundle] loadNibNamed:@"TableViewMemberRegister" owner:self options:nil];
    
    tbvMemberRegister.delegate = self;
    tbvMemberRegister.dataSource = self;
    CGRect frame = tbvMemberRegister.frame;
    frame.size.width = 350;
    frame.size.height = 264;
    tbvMemberRegister.frame = frame;
    tbvMemberRegister.backgroundColor = [UIColor whiteColor];
    [self setShadow:tbvMemberRegister radius:48];
    tbvMemberRegister.layer.cornerRadius = 16;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSegment bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelSegment];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMemberRegister.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmRegister:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
}

- (void)loadView
{
    [super loadView];
    [self setCurrentVc];
    
    
    _memberDetailNoOfItem = 6;
    txtMemberNo.delegate = self;
    txtRemark.delegate = self;
    txtRemark.text = _usingReceipt.remark;
    colVwReceiptOrder.allowsSelection = NO;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    
    
    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
    _webview.delegate = self;
    
    
    
    
    //receipt ตัวเอง
    Receipt *idInsertedReceipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    if(!idInsertedReceipt.idInserted)
    {
        [self loadingOverlayView];
    }
    
    
    
    //หากมี merge ต้องเช็ค mergereceipt ด้วย
    if(idInsertedReceipt.mergeReceiptID > 0)
    {
        Receipt *mergeReceipt = [Receipt getReceipt:idInsertedReceipt.mergeReceiptID];
        if(!mergeReceipt.idInserted)
        {
            [self loadingOverlayView];
        }
    }
    btnPaySplitBill.hidden = YES;
    
    
    
    
    
    //set member
    _receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    if(_receipt)
    {
        [self selectReceipt];
        if(_usingReceipt.memberID != 0)
        {
            Member *member = [Member getMember:_usingReceipt.memberID];
            txtMemberNo.text = member.phoneNo;
        }
    }
    

    
    //ปุ่มจ่ายเงิน
    NSInteger paymentMethodCash = [[Setting getSettingValueWithKeyName:@"paymentMethodCash"] integerValue];
    NSInteger paymentMethodCredit = [[Setting getSettingValueWithKeyName:@"paymentMethodCredit"] integerValue];
    NSInteger paymentMethodTransfer = [[Setting getSettingValueWithKeyName:@"paymentMethodTransfer"] integerValue];
    UserAccount *currentUserAccount = [UserAccount getCurrentUserAccount];
    NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:currentUserAccount.roleID tabMenuType:2];
    btnCash.hidden = !(paymentMethodCash && [roleTabMenuList count]>0);
    btnCredeitCard.hidden = !(paymentMethodCredit && [roleTabMenuList count]>0);
    btnTransfer.hidden = !(paymentMethodTransfer && [roleTabMenuList count]>0);
    
    
    
    
    [self setShadow:colVwReceiptOrder];
    [self setShadow:colVwMemberDetail];
    [self setShadow:colVwRemark];
    [self setButtonDesign:btnCash];
    [self setButtonDesign:btnCloseTable];
    [self setButtonDesign:btnCredeitCard];
    [self setButtonDesign:btnAddMoreOrder];
    [self setButtonDesign:btnMergeReceipt];
    [self setButtonDesign:btnPrintBill];
    [self setButtonDesign:btnPrintWithAddress];
    [self setButtonDesign:btnOrderHistory];
    [self setButtonDesign:btnSplitBill];
    [self setButtonDesign:btnMoveTable];
    [self setButtonDesign:btnMoveOrder];
    [self setButtonDesign:btnPaySplitBill];
    [self setButtonDesign:btnTransfer];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    _receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    
    
    if(_receipt.mergeReceiptID == 0 || _receipt.mergeReceiptID == -999)
    {
        lblTableName.text = [NSString stringWithFormat:@"บิลโต๊ะ %@",customerTable.tableName];
    }
    else//mergeReceipt
    {
        NSMutableArray *customerTableList = [ReceiptCustomerTable getCustomerTableListWithMergeReceiptID:_receipt.mergeReceiptID];
        NSString *tableNameListInText = [CustomerTable getTableNameListInTextWithCustomerTableList:customerTableList];
        lblTableName.text = [NSString stringWithFormat:@"บิลโต๊ะ %@",tableNameListInText];
    }
    
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:5];
    if([orderTakingList count]>0 && !_splitBillStatus)
    {
        //pay process = NO
        btnPrintBill.enabled = NO;
        btnPrintWithAddress.enabled = NO;
        btnCash.enabled = NO;
        btnCredeitCard.enabled = NO;
        btnMoveTable.enabled = NO;
        btnMergeReceipt.enabled = NO;
        btnDiscount.enabled = NO;
        btnMoveOrder.enabled = YES;
    }
    
    [self updateTotalOrderAndAmount];
    [self reloadMemberDetail];
    [self updatePaidAmount];
    [colVwReceiptOrder reloadData];
}

- (void)reloadMemberDetail
{
    [self selectReceipt];
    _member = [Member getMember:_usingReceipt.memberID];
    if(_member)
    {
        _addressList = [Address getAddressListWithMemberID:_member.memberID];
        _memberDetailNoOfItem = 6 + 1 + [_addressList count];//1=เพิ่มที่อยู่
    }
    else
    {
        _memberDetailNoOfItem = 6;
    }
    
    [colVwMemberDetail reloadData];
}

-(void)getOrderTaking
{
    NSLog(@"test getordertaking");
    //จัดเรียงก่อน แล้วถึงเซ็ตค่าเข้า _ordertakingList ไม่ update และ remove เหมือนตอน send to kitchen เพราะต้องการคงไว้ของ order kitchen sequence
    _orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3,@5]];
//    _orderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:_orderTakingList];
    _orderTakingList = [OrderTaking createSumUpOrderTakingGroupByNoteAndPriceFromSeveralSendToKitchen:_orderTakingList];
    NSLog(@"test getordertaking count:%ld",[_orderTakingList count]);
}

-(void)getOrderTakingWithMergeReceiptID:(NSInteger)mergeReceiptID
{
    //จัดเรียงก่อน แล้วถึงเซ็ตค่าเข้า _ordertakingList
    _receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:mergeReceiptID];
    NSMutableArray *mergeOrderTakingList = [[NSMutableArray alloc]init];
    for(ReceiptCustomerTable *item in _receiptCustomerTableList)
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:item.customerTableID statusList:@[@2,@3]];
        [mergeOrderTakingList addObjectsFromArray:orderTakingList];
    }
//    _orderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:mergeOrderTakingList];
    _orderTakingList = [OrderTaking createSumUpOrderTakingGroupByNoteAndPriceFromSeveralSendToKitchen:mergeOrderTakingList];
}

- (void)updateTotalOrderAndAmount
{
    //get ordertaking
    NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
    if(_moveOrderStatus)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        for(NSIndexPath *indexPath in selectedIndexPath)
        {
            OrderTaking *orderTaking = _orderTakingList[indexPath.item];
            [orderTakingList addObject:orderTaking];
        }
    }
    else if(_receipt.mergeReceiptID == 0)
    {
        [self getOrderTaking];
        orderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
    }
    else if(_receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999))
    {
        [self getOrderTakingWithMergeReceiptID:_receipt.mergeReceiptID];
        orderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
    }
    else if(_receipt.mergeReceiptID == -999 && _splitBillStatus)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        for(NSIndexPath *indexPath in selectedIndexPath)
        {
            OrderTaking *orderTaking = _orderTakingList[indexPath.item];
            [orderTakingList addObject:orderTaking];
        }
    }
    else if(_receipt.mergeReceiptID == -999 && !_splitBillStatus)
    {
        [self getOrderTaking];
        NSMutableArray *status2orderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
        NSMutableArray *status5orderTakingList = [OrderTaking getOrderTakingListWithStatus:5 orderTakingList:_orderTakingList];
        [orderTakingList addObjectsFromArray:status2orderTakingList];
        [orderTakingList addObjectsFromArray:status5orderTakingList];
    }
    
    
    
    //total quantity
    float totalQuantity = [OrderTaking getTotalQuantity:orderTakingList];
    
    
    //sub total amount
    float subTotalAmount = [OrderTaking getSubTotalAmount:orderTakingList];
    float subTotalAmountAllowDiscount = [OrderTaking getSubTotalAmountAllowDiscount:orderTakingList];
    
    
    //discount title
    float discountAmount = 0;
    NSString *strDiscountTitle = @"ส่วนลด";
    [self selectReceipt];
    if(_usingReceipt.discountType == 1)
    {
        if([_usingReceipt.discountReason isEqualToString:@"ใช้แต้ม"])
        {
            strDiscountTitle = [NSString stringWithFormat:@"%@ (ใช้แต้ม)",strDiscountTitle];
        }
    }
    else if(_usingReceipt.discountType == 2)
    {
        NSString *strDiscountAmount = [Utility formatDecimal:_usingReceipt.discountAmount withMinFraction:0 andMaxFraction:0];
        strDiscountTitle = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscountAmount];
        
        if([_usingReceipt.discountReason isEqualToString:@"ใช้แต้ม"])
        {
            strDiscountTitle = [NSString stringWithFormat:@"%@ (ใช้แต้ม)",strDiscountTitle];
        }
    }
    [btnDiscount setTitle:strDiscountTitle forState:UIControlStateNormal];
    
    
    
    //discount amount
    if(_usingReceipt.discountType == 1)//baht discount
    {
        discountAmount = _usingReceipt.discountAmount*-1;
    }
    else if(_usingReceipt.discountType == 2)//%discount
    {
        discountAmount = _usingReceipt.discountAmount*0.01*subTotalAmountAllowDiscount*-1;
    }
    discountAmount = discountAmount == -0?0:discountAmount;
    
    
    
    
    
    float afterDiscountAmount = subTotalAmount+discountAmount;
    afterDiscountAmount = afterDiscountAmount < 0?0:afterDiscountAmount;
    float serviceCharge = afterDiscountAmount*0;
    float vat = (afterDiscountAmount + serviceCharge) * 0.07;
    float actualTotalAmount = afterDiscountAmount + serviceCharge + vat;
    float totalAmount = roundf(actualTotalAmount);
    float rounding = totalAmount-actualTotalAmount;
    _totalAmount = totalAmount;
    
    
    _strTotalQuantity = [NSString stringWithFormat:@"%@ รายการ",[Utility formatDecimal:totalQuantity withMinFraction:0 andMaxFraction:0]];
    _strSubTotalAmount = [Utility formatDecimal:subTotalAmount withMinFraction:2 andMaxFraction:2];
    _strDiscountAmount = [Utility formatDecimal:discountAmount withMinFraction:2 andMaxFraction:2];
    btnDeleteDiscount.hidden = discountAmount == 0;
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

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)addMoreOrder:(id)sender
{
    [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
}

- (IBAction)splitBill:(id)sender
{
    if([btnSplitBill.titleLabel.text isEqualToString:@"แยกบิล"])
    {
        [btnSplitBill setTitle:@"ออกจากการแยกบิล" forState:UIControlStateNormal];
        //split bill
        _splitBillStatus = YES;
        btnPaySplitBill.hidden = NO;
        [btnPaySplitBill setTitle:@"ชำระบิลย่อย" forState:UIControlStateNormal];
        btnBack.enabled = NO;
        btnAddMoreOrder.enabled = NO;
        btnMoveTable.enabled = NO;
        btnMergeReceipt.enabled = NO;
        btnCloseTable.enabled = NO;
        btnMoveOrder.enabled = NO;
        
        
        
        //pay process
        btnPrintBill.enabled = YES;
        btnPrintWithAddress.enabled = YES;
        btnCash.enabled = YES;
        btnCredeitCard.enabled = YES;
        btnDiscount.enabled = YES;
        
        
        
        colVwReceiptOrder.layer.borderWidth = 2;
        colVwReceiptOrder.layer.borderColor = mYellowColor.CGColor;
        colVwReceiptOrder.allowsSelection = YES;
        colVwReceiptOrder.allowsMultipleSelection = YES;
        _receipt.mergeReceiptID = -999;
        _orderTakingList = [OrderTaking separateOrder:_orderTakingList];
        [colVwReceiptOrder reloadData];
        
        
        
        
        _splitReceipt = [[Receipt alloc]initWithCustomerTableID:0 memberID:0 servingPerson:0 customerType:0 openTableDate:[Utility notIdentifiedDate] cashAmount:0 cashReceive:0 creditCardType:0 creditCardNo:@"" creditCardAmount:0 transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:@"" discountType:0 discountAmount:0 discountReason:@"" status:1 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility notIdentifiedDate] mergeReceiptID:0];
        _splitReceipt.receiptNoID = _receipt.receiptNoID;
        _splitReceipt.openTableDate = _receipt.openTableDate;
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
    }
    else
    {
        [btnSplitBill setTitle:@"แยกบิล" forState:UIControlStateNormal];
        _splitBillStatus = NO;
        btnPaySplitBill.hidden = YES;
        btnBack.enabled = YES;
        btnAddMoreOrder.enabled = YES;
        btnMoveTable.enabled = YES;
        btnMergeReceipt.enabled = YES;
        btnCloseTable.enabled = YES;
        btnMoveOrder.enabled = YES;
        
        
        colVwReceiptOrder.layer.borderWidth = 0;
        colVwReceiptOrder.allowsSelection = NO;
        [self loadViewProcess];
        
        
        
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:5];
        if([orderTakingList count]>0)
        {
            //pay process = NO
            btnPrintBill.enabled = NO;
            btnPrintWithAddress.enabled = NO;
            btnCash.enabled = NO;
            btnCredeitCard.enabled = NO;
            btnMoveTable.enabled = NO;
            btnMergeReceipt.enabled = NO;
            btnDiscount.enabled = NO;
        }
        else
        {
            _receipt.mergeReceiptID = 0;
        }
    }
}

- (IBAction)moveOrder:(id)sender
{
    if([btnMoveOrder.titleLabel.text isEqualToString:@"ย้ายรายการ"])
    {
        [btnMoveOrder setTitle:@"ออกจากย้ายรายการ" forState:UIControlStateNormal];
        //split bill
        _moveOrderStatus = YES;
        btnPaySplitBill.hidden = NO;
        [btnPaySplitBill setTitle:@"เลือกโต๊ะปลายทาง" forState:UIControlStateNormal];
        btnBack.enabled = NO;
        btnAddMoreOrder.enabled = NO;
        btnMoveTable.enabled = NO;
        btnMergeReceipt.enabled = NO;
        btnCloseTable.enabled = NO;
        btnSplitBill.enabled = NO;
        
        
        
        //pay process
        btnPrintBill.enabled = NO;
        btnPrintWithAddress.enabled = NO;
        btnCash.enabled = NO;
        btnCredeitCard.enabled = NO;
        btnDiscount.enabled = NO;
        
        
        
        colVwReceiptOrder.layer.borderWidth = 2;
        colVwReceiptOrder.layer.borderColor = mYellowColor.CGColor;
        colVwReceiptOrder.allowsSelection = YES;
        colVwReceiptOrder.allowsMultipleSelection = YES;
        _orderTakingList = [OrderTaking separateOrder:_orderTakingList];
        [colVwReceiptOrder reloadData];
        
        
    
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
    }
    else
    {
        [btnMoveOrder setTitle:@"ย้ายรายการ" forState:UIControlStateNormal];
        _moveOrderStatus = NO;
        btnPaySplitBill.hidden = YES;
        btnBack.enabled = YES;
        btnAddMoreOrder.enabled = YES;
        btnMoveTable.enabled = YES;
        btnMergeReceipt.enabled = YES;
        btnCloseTable.enabled = YES;
        btnSplitBill.enabled = YES;
        
        
        //pay process
        btnPrintBill.enabled = YES;
        btnPrintWithAddress.enabled = YES;
        btnCash.enabled = YES;
        btnCredeitCard.enabled = YES;
        btnDiscount.enabled = YES;
        btnMoveTable.enabled = YES;
        btnMergeReceipt.enabled = YES;
        
        
        colVwReceiptOrder.layer.borderWidth = 0;
        colVwReceiptOrder.allowsSelection = NO;
        [self loadViewProcess];
        
    }
}

- (IBAction)transferMoney:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FillInTransferMoneyViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FillInTransferMoneyViewController"];
    controller.preferredContentSize = CGSizeMake(400, 74*2+345+58);
    controller.totalAmount = _totalAmount;
    controller.vc = self;
    [self selectReceipt];
    controller.receipt = _usingReceipt;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    // in case we don't have a bar button as reference
    UIButton *button = sender;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
}

- (IBAction)registerMember:(id)sender
{
    //show member box to fill in
    _editingMember = [[Member alloc]init];
    
    tbvMemberRegister.center = CGPointMake(colVwMemberDetail.frame.origin.x + colVwMemberDetail.frame.size.width/2, colVwMemberDetail.frame.size.height/2);
    CGRect frame = tbvMemberRegister.frame;
    frame.size.width = 350;
    frame.size.height = 264;
    tbvMemberRegister.frame = frame;
    [tbvMemberRegister reloadData];
    NSLog(@"tableview frame: (%f,%f,%f,%f)",tbvMemberRegister.frame.origin.x,tbvMemberRegister.frame.origin.y,tbvMemberRegister.frame.size.width,tbvMemberRegister.frame.size.height);
    
    
    {
        tbvMemberRegister.alpha = 0.0;
        [self.view addSubview:tbvMemberRegister];
        [UIView animateWithDuration:0.2 animations:^{
            tbvMemberRegister.alpha = 1.0;
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderTaking"])
    {
        OrderTakingViewController *vc = segue.destinationViewController;
        vc.customerTable = customerTable;
    }
    else if([[segue identifier] isEqualToString:@"segSelectCustomerTableToMerge"])
    {
        SelectCustomerTableToMergeViewController *vc = segue.destinationViewController;
        vc.selectedReceipt = _receipt;
        vc.selectedCustomerTable = customerTable;
    }
    else if([[segue identifier] isEqualToString:@"segSelectCustomerTableToMove"])
    {
        SelectCustomerTableToMoveViewController *vc = segue.destinationViewController;
        vc.selectedReceipt = _receipt;
        vc.selectedCustomerTable = customerTable;
        vc.moveOrder = _moveOrderStatus;
        if(_moveOrderStatus)
        {
            NSMutableArray *selectedOrderTakingList = [[NSMutableArray alloc]init];
            NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
            for(NSIndexPath *indexPath in selectedIndexPath)
            {
                OrderTaking *orderTaking = _orderTakingList[indexPath.item];
                [selectedOrderTakingList addObject:orderTaking];
            }
                        
            vc.selectedOrderTakingList = selectedOrderTakingList;
            vc.needSeparateOrder = _needSeparateOrder;
        }
        else
        {
            vc.selectedOrderTakingList = nil;
            vc.needSeparateOrder = NO;
        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwReceiptOrder])
    {
        NSLog(@"test numberofitemInSEction:%ld",[_orderTakingList count]);
        //load order มาโชว์
        return [_orderTakingList count];
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        return _memberDetailNoOfItem;
    }
    else if([collectionView isEqual:colVwRemark])
    {
        return [_remarkReceiptList count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptOrder])
    {
        CustomCollectionViewCellReceiptOrder *cell = (CustomCollectionViewCellReceiptOrder*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptOrder forIndexPath:indexPath];
        
        
        
        OrderTaking *orderTaking = _orderTakingList[item];
        
        cell.contentView.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
        if(!_splitBillStatus && orderTaking.status != 3)
        {
            [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressDeleteOrder:)];
            [cell addGestureRecognizer:cell.longPressGestureRecognizer];
        }
        
        
        
        
        if(orderTaking.status == 5)
        {
            cell.backgroundColor = [UIColor lightGrayColor];
        }
        
        
        
        //menu name
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
        if(orderTaking.status == 2 || orderTaking.status == 5)
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
        else if(orderTaking.status == 3)
        {
            if(orderTaking.takeAway)
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSBaselineOffsetAttributeName:@(1.5), NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ" attributes:attribute];
                
                NSDictionary *attribute2 = @{NSBaselineOffsetAttributeName:@(1.5), NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSBaselineOffsetAttributeName:@(1.5), NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:menu.titleThai attributes:attribute];
                cell.lblMenuName.attributedText = attrString;
            }
        }
        
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
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
                if(orderTaking.status == 2 || orderTaking.status == 5)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                else if(orderTaking.status == 3)
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
                if(orderTaking.status == 2 || orderTaking.status == 5)
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                else if(orderTaking.status == 3)
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
            
            
            
            CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            CGRect frame2 = cell.lblNote.frame;
            frame2.size.width = noteLabelSize.width;
            frame2.size.height = noteLabelSize.height;
            cell.lblNote.frame = frame2;
        }
        
        
//        //reason
//        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscountWithOrderTakingID:orderTaking.orderTakingID];
//        if(orderCancelDiscount)
//        {
//            cell.lblReason.text = [NSString stringWithFormat:@"เหตุผลที่ลดราคา: %@",orderCancelDiscount.reason];
//        }
//        else
//        {
//            cell.lblReason.text = @"";
//        }
        
        
        
        //total price
        NSString *strTotalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.specialPrice withMinFraction:2 andMaxFraction:2];
        if(orderTaking.status == 2 || orderTaking.status == 5)
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
        else if(orderTaking.status == 3)
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
        if(orderTaking.status == 2 || orderTaking.status == 5)
        {
            cell.lblQuantity.attributedText = nil;
            cell.lblQuantity.text = strQuantity;
        }
        else if(orderTaking.status == 3)
        {
            UIFont *font = [UIFont systemFontOfSize:14];
            NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strQuantity attributes:attribute];
            cell.lblQuantity.attributedText = attrString;
        }
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        if(_member)
        {
            if(item < 6)
            {
                CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
                
                
                switch (item) {
                    case 0:
                    {
                        cell.lblTitle.text = @"ชื่อ:";
                        cell.lblValue.text = _member.fullName;
                    }
                        break;
                    case 1:
                    {
                        cell.lblTitle.text = @"ชื่อเล่น:";
                        cell.lblValue.text = _member.nickname;
                    }
                        break;
                    case 2:
                    {
                        cell.lblTitle.text = @"เบอร์โทร:";
                        cell.lblValue.text = _member.phoneNo;
                    }
                        break;
                    case 3:
                    {
                        cell.lblTitle.text = @"วันเกิด:";
                        if(!_member.birthDate)
                        {
                            cell.lblValue.text = @"";
                        }
                        else
                        {
                            cell.lblValue.text = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                        }
                    }
                        break;
                    case 4:
                    {
                        cell.lblTitle.text = @"เพศ:";
                        cell.lblValue.text = _member.gender;
                    }
                        break;
                    case 5:
                    {
                        NSInteger totalPoint = [RewardPoint getTotalPointWithMemberID:_member.memberID];
                        NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
                        cell.lblTitle.text = @"แต้มสะสม:";
                        cell.lblValue.text = strTotalPoint;
                    }
                        break;
                    default:
                        break;
                }
                
                
                CGSize labelSize = [self suggestedSizeWithFont:cell.lblValue.font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblValue.text];
                
                
                CGRect frame = cell.lblValue.frame;
                frame.size.height = labelSize.height;
                cell.lblValue.frame = frame;
                
                
                
                [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
                return cell;
            }
            else if(item == 6)
            {
                CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAddAddress forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
                
                
                [cell.btnAddAddress addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
            }
            else if(item > 6)
            {
                CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                Address *address = _addressList[item - 1 - 6];
                if([_addressList count] == 1)
                {
                    cell.lblValue.text = [Address getFullAddress:address];
                    cell.lblTitle.text = @"ที่อยู่:";
                }
                else
                {
                    cell.lblValue.text = [Address getFullAddress:address];
                    cell.lblTitle.text = [NSString stringWithFormat:@"ที่อยู่ %ld:",item - 1 - 6 + 1];
                }
                cell.lblValue.tag = 60;
                
                NSMutableArray *colorList = [[NSMutableArray alloc]init];
                if(address.keyAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0 alpha:1]];
                }
                if(address.deliveryAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:90.0/255 green:200.0/255 blue:250.0/255 alpha:1]];
                }
                if(address.taxAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:0/255 green:122.0/255 blue:255.0/255 alpha:1]];
                }
                if([colorList count]>0)
                {
                    cell.vwColor1.backgroundColor = colorList[0];
                }
                if([colorList count]>1)
                {
                    cell.vwColor2.backgroundColor = colorList[1];
                }
                if([colorList count]>2)
                {
                    cell.vwColor3.backgroundColor = colorList[2];
                }
                cell.backgroundColor = [UIColor clearColor];
                
                CGSize labelSize = [self suggestedSizeWithFont:cell.lblValue.font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblValue.text];
                
                
                CGRect frame = cell.lblValue.frame;
                frame.size.height = labelSize.height;
                cell.lblValue.frame = frame;
                
                
                
                cell.lblValue.userInteractionEnabled = YES;
                [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
                [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPress:)];
                [cell.lblValue addGestureRecognizer:cell.longPressGestureRecognizer];
                
                
                
                return cell;
            }
        }
        else
        {
            CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            cell.backgroundColor = [UIColor clearColor];
            
            switch (item) {
                case 0:
                {
                    cell.lblTitle.text = @"ชื่อ:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 1:
                {
                    cell.lblTitle.text = @"ชื่อเล่น:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 2:
                {
                    cell.lblTitle.text = @"เบอร์โทร:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 3:
                {
                    cell.lblTitle.text = @"วันเกิด:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 4:
                {
                    cell.lblTitle.text = @"เพศ:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 5:
                {
                    cell.lblTitle.text = @"แต้มสะสม:";
                    cell.lblValue.text = @"";
                }
                    break;
                default:
                    break;
            }
            
            
            
            [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
            return cell;
        }
    }
    else if([collectionView isEqual:colVwRemark])
    {
        CustomCollectionViewCellRemark *cell = (CustomCollectionViewCellRemark*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierRemark forIndexPath:indexPath];
        cell.contentView.userInteractionEnabled = NO;
        
        Receipt *receipt = _remarkReceiptList[item];
        cell.lblDateTime.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yyyy HH:mm"];
        cell.lblRemark.text = receipt.remark;
        
        return cell;
    }
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptOrder])
    {
        OrderTaking *orderTaking = _orderTakingList[indexPath.item];
        if(orderTaking.status != 2)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptOrder])
    {
        CustomCollectionViewCellReceiptOrder *cell = (CustomCollectionViewCellReceiptOrder *)[colVwReceiptOrder cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = mYellowColor;
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwReceiptOrder])
    {
        CustomCollectionViewCellReceiptOrder *cell = (CustomCollectionViewCellReceiptOrder *)[colVwReceiptOrder cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
    }
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake(0, 0);
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptOrder])
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
                CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
                noteHeight = noteLabelSize.height;
            }
        }
        
        
        
        
        UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8 - 16)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];
        
        
        
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
        size = CGSizeMake(colVwReceiptOrder.frame.size.width,height);
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        if(!_member)
        {
            size = CGSizeMake(colVwMemberDetail.frame.size.width,44);
            return size;
        }
        //load member มาโชว์
        NSString *strValue = @"";
        if(item < 6)
        {
            switch (item) {
                case 0:
                {
                    strValue = _member.fullName;
                }
                    break;
                case 1:
                {
                    strValue = _member.nickname;
                }
                    break;
                case 2:
                {
                    strValue = _member.phoneNo;
                }
                    break;
                case 3:
                {
                    if(!_member.birthDate)
                    {
                        strValue = @"";
                    }
                    else
                    {
                        strValue = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                    }
                }
                    break;
                case 4:
                {
                    strValue = _member.gender;
                }
                    break;
                case 5:
                {
                    NSInteger totalPoint = [RewardPoint getTotalPointWithMemberID:_member.memberID];
                    NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
                    strValue = strTotalPoint;
                }
                    break;
                default:
                    break;
            }
            
            
            UIFont *font = [UIFont systemFontOfSize:15.0];
            CGSize labelSize = [self suggestedSizeWithFont:font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strValue];
            
            
            float height = labelSize.height+14*2;
            size = CGSizeMake(colVwMemberDetail.frame.size.width,height);
        }
        else if(item > 6)
        {
            Address *address = _addressList[item - 1 - 6];
            strValue = [Address getFullAddress:address];
            
            
            UIFont *font = [UIFont systemFontOfSize:15.0];
            CGSize labelSize = [self suggestedSizeWithFont:font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strValue];
            
            
            float height = labelSize.height+14*2;
            size = CGSizeMake(colVwMemberDetail.frame.size.width,height);
        }
        else
        {
            size = CGSizeMake(colVwMemberDetail.frame.size.width,100);
        }
    }
    else if([collectionView isEqual:colVwRemark])
    {
        float remarkHeight = 44;
        Receipt *receipt = _remarkReceiptList[item];
        if(![Utility isStringEmpty:receipt.remark])
        {
            UIFont *fontRemark = [UIFont systemFontOfSize:14.0];
            CGSize remarkLabelSize = [self suggestedSizeWithFont:fontRemark size:CGSizeMake(colVwRemark.frame.size.width - 125-8-2*16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:receipt.remark];
            remarkHeight = remarkLabelSize.height+2*11;
//            remarkHeight = remarkHeight<44?44:remarkHeight;
        }
        size = CGSizeMake(collectionView.frame.size.width,remarkHeight);
    }
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwReceiptOrder.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwReceiptOrder reloadData];
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwMemberDetail.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwMemberDetail reloadData];
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
        if([collectionView isEqual:colVwRemark])
        {
            CustomCollectionViewCellRemarkHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            headerView.backgroundColor = mLightBlueColor;
            reusableview = headerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerPayment" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
    if([collectionView isEqual:colVwRemark])
    {
        headerSize = CGSizeMake(collectionView.bounds.size.width, 44);
    }
    
    return headerSize;
}



///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if(item <= 3)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (item) {
            case 0:
            {
                cell.lblTitle.text = @"ชื่อ:";
                cell.txtValue.tag = 1;
                cell.txtValue.delegate = self;
            }
                break;
            case 1:
            {
                cell.lblTitle.text = @"ชื่อเล่น:";
                cell.txtValue.tag = 2;
                cell.txtValue.delegate = self;
            }
                break;
            case 2:
            {
                cell.lblTitle.text = @"เบอร์โทร:";
                cell.txtValue.tag = 3;
                cell.txtValue.delegate = self;
            }
                break;
            case 3:
            {
                cell.lblTitle.text = @"วันเกิด:";
                cell.txtValue.tag = 4;
                cell.txtValue.delegate = self;
                
                
                cell.txtValue.inputView = dtPicker;
                cell.txtValue.text = @"";
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else if(item == 4)
    {
        CustomTableViewCellLabelSegment *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelSegment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"เพศ:";
        [cell.segConGender addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        cell.segConGender.tag = 5;
        return cell;
    }
    
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (void)confirmRegister:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateMemberRegister])
    {
        return;
    }
    
    
    //insert
    Member *member = [[Member alloc]initWithFullName:_editingMember.fullName nickname:_editingMember.nickname phoneNo:_editingMember.phoneNo birthDate:_editingMember.birthDate gender:_editingMember.gender memberDate:[Utility currentDateTime]];
    [Member addObject:member];
    [self.homeModel insertItems:dbMember withData:member actionScreen:@"Insert member in receipt screen"];
    [self showAlert:@"" message:@"สมัครสมาชิกสำเร็จ"];
    [self closeMemberRegisterBoxAndClearData];
    
}

- (void)cancelRegister:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
}

- (void)addAddress:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    //    if(!_member)
    //    {
    //        [self showAlert:@"" message:@"กรุณากรอกเลขสมาชิกเพื่อเพิ่มทีอยู่"];
    //        return;
    //    }
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*10+44*2+89+58);//count item+count header
    controller.memberID = _member.memberID;
    controller.vc = self;
    controller.firstAddressFlag = [_addressList count]==0;
    controller.editAddress = nil;
    controller.addressList = _addressList;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    // in case we don't have a bar button as reference
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:6 inSection:0];
    CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress *)[colVwMemberDetail cellForItemAtIndexPath:indexPath];
    popController.sourceView = cell.btnAddAddress;
    popController.sourceRect = cell.btnAddAddress.bounds;
}

- (BOOL)validateMemberRegister
{
    //require phone on and name
    if([Utility isStringEmpty:_editingMember.fullName])
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1];
        [self showAlert:@"" message:@"กรุณาใส่ชื่อ"];
        [textField becomeFirstResponder];
        return NO;
    }
    if([Utility isStringEmpty:_editingMember.phoneNo])
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:3];
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขโทรศัพท์"];
        [textField becomeFirstResponder];
        return NO;
    }
    
    
    
    //check phoneno exist
    Member *member = [Member getMemberWithPhoneNo:_editingMember.phoneNo];
    if(member)
    {
        [self showAlert:@"" message:@"สมาชิกนี้มีอยู่แล้ว"];
        return NO;
    }
    return YES;
}

- (void)closeMemberRegisterBoxAndClearData
{
    //clear value
    [tbvMemberRegister removeFromSuperview];
}

- (void)closeMemberRegisterBox
{
    [tbvMemberRegister removeFromSuperview];
}

-(BOOL)validatePrintBill
{
    if(_receipt.mergeReceiptID == -999)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        if([selectedIndexPath count] == 0)
        {
            [self showAlert:@"" message:@"กรุณาเลือกรายการที่ต้องการพิมพ์"];
            return NO;
        }
    }
    else if(_receipt.mergeReceiptID == 0)
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@0]];
        if([orderTakingList count] == 0)
        {
            [self showAlert:@"" message:@"ไม่มีรายการที่ต้องชำระเงิน"];
            return NO;
        }
    }
    else//mergeReceipt
    {
        NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
        NSMutableArray *status0OrderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:_orderTakingList];
        [orderTakingList addObjectsFromArray:status2OrderTakingList];
        [orderTakingList addObjectsFromArray:status0OrderTakingList];
        if([orderTakingList count] == 0)
        {
            [self showAlert:@"" message:@"ไม่มีรายการที่ต้องชำระเงิน"];
            return NO;
        }
    }
    return YES;
}

- (IBAction)printBill:(id)sender
{
    //validate
    if(![self validatePrintBill])
    {
        return;
    }
    
    
    
    //insert bill print
    [self selectReceipt];
    
    
    
    
    if(sender)//tap print bill
    {
        BillPrint *billPrint = [[BillPrint alloc]initWithReceiptID:_usingReceipt.receiptID billPrintDate:[Utility currentDateTime]];
        [BillPrint addObject:billPrint];
        
        
        [self printBillWithAddress:NO bill:1];
    }
    else//tap close table button
    {
        [self printBillWithAddress:NO bill:0];
    }
}

- (IBAction)printWithAddress:(id)sender
{
    if(_member)
    {
        Address *address = [Address getDeliveryAddressWithMemberID:_member.memberID];
        if(!address)
        {
            [self showAlert:@"" message:@"กรุณาใส่ที่อยู่จัดส่ง"];
            return;
        }
    }
    else
    {
        [self showAlert:@"" message:@"กรุณาใส่ที่อยู่จัดส่ง"];
        return;
    }
    
    [self printBillWithAddress:YES bill:1];
}

- (IBAction)fillInCreditCard:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FillInCreditCardViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FillInCreditCardViewController"];
    controller.preferredContentSize = CGSizeMake(400, 74*3+345+58);
    controller.totalAmount = _totalAmount;
    controller.vc = self;
    [self selectReceipt];
    controller.receipt = _usingReceipt;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    // in case we don't have a bar button as reference
    UIButton *button = sender;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
}

- (IBAction)fillInCash:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FillInCashViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FillInCashViewController"];
    controller.preferredContentSize = CGSizeMake(400, 92*2+345+58);
    controller.totalAmount = _totalAmount;
    controller.vc = self;
    [self selectReceipt];
    controller.receipt = _usingReceipt;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    // in case we don't have a bar button as reference
    UIButton *button = sender;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
    
    
}

-(void)printBillWithAddress:(BOOL)printAddressFlag bill:(NSInteger)bill
{
    [self loadingOverlayView];
    
    
    //prepare data to print main
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *phoneNo = [Setting getSettingValueWithKeyName:@"restaurantPhoneNo"];
    NSString *customerType = customerTable.tableName;
    NSString *cashierName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    
    
    NSString *receiptNoID = _usingReceipt.receiptNoID;
    NSString *receiptNo = [ReceiptNo makeFormatedReceiptNoWithReceiptNoID:receiptNoID];
    NSString *receiptTime = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy-MM-dd HH:mm"];
    NSString *memberCode = _member?_member.phoneNo:@"-";
    NSInteger totalPoint = _member?[RewardPoint getTotalPointWithMemberID:_member.memberID]:0;
    NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
    NSString *thankYou = [Setting getSettingValueWithKeyName:@"thankYou"];
    
    
    
    //items
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSMutableArray *printOrderTakingList = [[NSMutableArray alloc]init];
    if(_receipt.mergeReceiptID == -999)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        for(NSIndexPath *indexPath in selectedIndexPath)
        {
            OrderTaking *orderTaking = _orderTakingList[indexPath.item];
            [printOrderTakingList addObject:orderTaking];
        }
        printOrderTakingList = [OrderTaking sortOrderTakingList:printOrderTakingList];
    }
    else
    {
        if(bill)
        {
//            printOrderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
            if(_receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999))
            {
                _receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_receipt.mergeReceiptID];
                NSMutableArray *mergeOrderTakingList = [[NSMutableArray alloc]init];
                for(ReceiptCustomerTable *item in _receiptCustomerTableList)
                {
                    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:item.customerTableID statusList:@[@2,@3]];
                    [mergeOrderTakingList addObjectsFromArray:orderTakingList];
                }
                
                printOrderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:mergeOrderTakingList];
            }
            else
            {
                printOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3,@5]];
                printOrderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:printOrderTakingList];
            }
            
            printOrderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:printOrderTakingList];
        }
        else
        {
            printOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3,@5]];
            printOrderTakingList = [OrderTaking createSumUpOrderTakingFromSeveralSendToKitchen:printOrderTakingList];
            printOrderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:_orderTakingList];
        }
    }
    for(OrderTaking *item in printOrderTakingList)
    {
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        NSString *strQuantity = [Utility formatDecimal:item.quantity withMinFraction:0 andMaxFraction:0];
        
        Menu *menu = [Menu getMenu:item.menuID];
        NSString *strTotalPricePerItem = [Utility formatDecimal:item.specialPrice*item.quantity withMinFraction:0 andMaxFraction:0];
        
        
        
        NSString *removeTypeNote;
        NSString *addTypeNote;
        //check ว่า status,takeaway,menu เดียวกัน มีที่ราคาไม่เท่ากัน ให้ใส่โน้ต
        float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:item.orderTakingID];
        if(sumNotePrice == 0)
        {
            removeTypeNote = @"";
            addTypeNote = @"";
        }
        else
        {
            removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
            addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        }
        
        
        
        //promotion item
        NSString *strPro;
        if(item.specialPrice == item.price)
        {
            strPro = @"";
        }
        else
        {
            strPro = @"P";
        }
        
        
        //take away
        NSString *strTakeAway = @"";
        if(item.takeAway)
        {
            strTakeAway = @"ใส่ห่อ";
        }
        
        [dicItem setValue:strQuantity forKey:@"quantity"];
        [dicItem setValue:strTakeAway forKey:@"takeAway"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:strPro forKey:@"pro"];
        [dicItem setValue:strTotalPricePerItem forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
    }
    
    
    
    //pay by cash and credit card
    float cashReceive;
    float cashChanges;
    NSString *strCashReceive;
    NSString *strCashChanges;
    NSString *strCreditCardType;
    NSString *strLast4Digits;
    NSString *strCreditCardAmount;
    NSString *strTransferDate;
    NSString *strTransferAmount;
    //pay by cash
    cashReceive = _usingReceipt.cashReceive;
    cashChanges = _usingReceipt.cashReceive-_usingReceipt.cashAmount;
    strCashReceive = [Utility formatDecimal:cashReceive withMinFraction:2 andMaxFraction:2];
    strCashChanges = [Utility formatDecimal:cashChanges withMinFraction:2 andMaxFraction:2];
    
    
    //pay by credit card
    strCreditCardType = [Receipt getStringCreditCardType:_usingReceipt];
    strLast4Digits = _usingReceipt.creditCardNo;
    strCreditCardAmount = [Utility formatDecimal:_usingReceipt.creditCardAmount withMinFraction:2 andMaxFraction:2];
    
    
    //pay by transfer
    strTransferDate = [Utility dateToString:_usingReceipt.transferDate toFormat:@"d MMM yyyy HH:mm"];
    strTransferAmount = [Utility formatDecimal:_usingReceipt.transferAmount withMinFraction:2 andMaxFraction:2];
    
    
    
    
    
    //if print with delivery address
    NSString *nameAndPhoneNo = @"";
    NSString *fullAddress = @"";
    if(printAddressFlag)
    {
        if(_member)
        {
            
            Address *address = [Address getDeliveryAddressWithMemberID:_member.memberID];
            nameAndPhoneNo = [NSString stringWithFormat:@"%@ (%@)",address.deliveryCustomerName,[Utility setPhoneNoFormat:address.deliveryPhoneNo]];
            fullAddress = [Address getFullAddress:address];
        }
    }
    
    
    
    
    //create html invoice
    NSString *invoiceHtml = @"";
    _bill = bill;
    if(bill)
    {
        InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
        invoiceHtml = [invoiceComposer renderBillWithRestaurantName:restaurantName phoneNo:phoneNo customerType:customerType cashierName:cashierName receiptNo:receiptNo receiptTime:receiptTime totalQuantity:_strTotalQuantity subTotalAmount:_strSubTotalAmount discountAmount:_strDiscountAmount afterDiscountAmount:_strAfterDiscountAmount serviceChargeAmount:_strServiceCharge vatAmount:_strVat roundingAmount:_strRounding totalAmount:_strTotalAmount memberCode:memberCode totalPoint:strTotalPoint thankYou:thankYou items:items nameAndPhoneNo:nameAndPhoneNo address:fullAddress];
    }
    else
    {
        InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
        invoiceHtml = [invoiceComposer renderInvoiceWithRestaurantName:restaurantName phoneNo:phoneNo customerType:customerType cashierName:cashierName receiptNo:receiptNo receiptTime:receiptTime totalQuantity:_strTotalQuantity subTotalAmount:_strSubTotalAmount discountAmount:_strDiscountAmount afterDiscountAmount:_strAfterDiscountAmount serviceChargeAmount:_strServiceCharge vatAmount:_strVat roundingAmount:_strRounding totalAmount:_strTotalAmount cashReceive:strCashReceive cashChanges:strCashChanges creditCardType:strCreditCardType last4Digits:strLast4Digits creditCardAmount:strCreditCardAmount transferDate:strTransferDate transferAmount:strTransferAmount memberCode:memberCode totalPoint:strTotalPoint thankYou:thankYou items:items nameAndPhoneNo:nameAndPhoneNo address:fullAddress];
    }
    
    
    
    
    
    //load into webview in order to calculate height of content to prepare pdf
    [_webview loadHTMLString:invoiceHtml baseURL:NULL];
    if(![_webview isDescendantOfView:self.view])
    {
        [self.view insertSubview:_webview atIndex:0];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    
    
    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:@"bill.pdf"];
    
    
    
    //convert pdf to image
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
    UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
    NSLog(@"pdf fileName: %@",pdfFileName);
    
    
    //        //test remove after finish test
    //        return;
    
    
    
    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
    if(![printBill integerValue])
    {
        if(_receipt.mergeReceiptID == -999)
        {
            [self removeOverlayViews];
        }
        else
        {
            if(!_bill)
            {
                [self removeOverlayViews];
                [self showAlert:@"" message:@"ปิดโต๊ะสำเร็จ" method:@selector(segueBackToCustomerTable)];
            }
            else
            {
                [self removeOverlayViews];
            }
        }
    }
    else
    {
        //print process
        NSString *portName = [Setting getSettingValueWithKeyName:@"printerPortCashier"];
        NSLog(@"portName receipt: %@",portName);
        [self doPrintProcess:pdfImagePrint portName:portName];
    }
}

-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName
{
    NSData *commands = nil;
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:[AppDelegate getEmulation]];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    commands = [builder.commands copy];
    
    
    //    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    [Communication sendCommands:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message)
     {     // 10000mS!!!
         if(![message isEqualToString:@"พิมพ์สำเร็จ"])
         {
             
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self removeOverlayViews];
                                                 if(_receipt.mergeReceiptID != -999)
                                                 {
                                                     if(!_bill)
                                                     {
                                                         [self showAlert:@"" message:@"ปิดโต๊ะสำเร็จ" method:@selector(segueBackToCustomerTable)];
                                                     }
                                                 }
                                             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             [self removeOverlayViews];
             if(_receipt.mergeReceiptID != -999)
             {
                 if(!_bill)
                 {
                     [self showAlert:@"" message:@"ปิดโต๊ะสำเร็จ" method:@selector(segueBackToCustomerTable)];
                 }
             }
         }
     }];
}
# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return NO;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

- (IBAction)viewOrderHistory:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderHistoryViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
    controller.preferredContentSize = CGSizeMake(300, self.view.frame.size.height - 100);
    controller.customerTable = customerTable;
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    // in case we don't have a bar button as reference
    UIButton *button = sender;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
}

-(void)reloadReceiptOrder
{
    [self updateTotalOrderAndAmount];
    [colVwReceiptOrder reloadData];
}

- (void)handleLongPressDeleteOrder:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    CGPoint point = [gestureRecognizer locationInView:colVwReceiptOrder];
    NSIndexPath * tappedIP = [colVwReceiptOrder indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwReceiptOrder cellForItemAtIndexPath:tappedIP];
    NSInteger item = tappedIP.item;
    OrderTaking *orderTaking = _orderTakingList[item];
    NSMutableArray *orderCancelDiscountList = [OrderCancelDiscount getOrderCancelDiscountListWithOrderTaking:orderTaking];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบทั้งรายการ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {

          // grab the view controller we want to show
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          DeleteOrderPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DeleteOrderPasswordViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
          controller.orderTaking = orderTaking;
          controller.customerTable = customerTable;
          controller.cancelAll = 1;
          controller.vc = self;
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
          
          
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลดจำนวนลง 1 รายการ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          
          
          
          // grab the view controller we want to show
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          DeleteOrderPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DeleteOrderPasswordViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
          controller.orderTaking = orderTaking;
          controller.customerTable = customerTable;
          controller.cancelAll = 0;
          controller.vc = self;
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
          
          
          
      }]];
    
    if([orderCancelDiscountList count]==0)
    {
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ลดราคาทั้งรายการ"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
              
              // grab the view controller we want to show
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              DiscountOrderPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DiscountOrderPasswordViewController"];
              controller.preferredContentSize = CGSizeMake(300, 44*(3+1+1)+58+60);
              controller.orderTaking = orderTaking;
              controller.editOrderCancelDiscountList = orderCancelDiscountList;
              controller.discountAll = 1;
              controller.vc = self;
              
              
              // present the controller
              // on iPad, this will be a Popover
              // on iPhone, this will be an action sheet
              controller.modalPresentationStyle = UIModalPresentationPopover;
              [self presentViewController:controller animated:YES completion:nil];
              
              
              // configure the Popover presentation controller
              UIPopoverPresentationController *popController = [controller popoverPresentationController];
              popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
              popController.delegate = self;
              
              
              CGRect frame = cell.bounds;
              frame.origin.y = frame.origin.y-15;
              popController.sourceView = cell;
              popController.sourceRect = frame;
              
          }]];
        
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ลดราคา 1 รายการ"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
              // grab the view controller we want to show
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              DiscountOrderPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DiscountOrderPasswordViewController"];
              controller.preferredContentSize = CGSizeMake(300, 44*(3+1+1)+58+60);
              controller.orderTaking = orderTaking;
              controller.editOrderCancelDiscountList = orderCancelDiscountList;
              controller.discountAll = 0;
              controller.vc = self;
              
              
              // present the controller
              // on iPad, this will be a Popover
              // on iPhone, this will be an action sheet
              controller.modalPresentationStyle = UIModalPresentationPopover;
              [self presentViewController:controller animated:YES completion:nil];
              
              
              // configure the Popover presentation controller
              UIPopoverPresentationController *popController = [controller popoverPresentationController];
              popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
              popController.delegate = self;
              
              
              CGRect frame = cell.bounds;
              frame.origin.y = frame.origin.y-15;
              popController.sourceView = cell;
              popController.sourceRect = frame;
              
          }]];
    }
    else
    {
        [alert addAction:
         [UIAlertAction actionWithTitle:@"แก้ไขการลดราคา"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
              
              // grab the view controller we want to show
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              DiscountOrderPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DiscountOrderPasswordViewController"];
              controller.preferredContentSize = CGSizeMake(300, 44*(3+1+1)+58+60);
              controller.orderTaking = orderTaking;
              controller.editOrderCancelDiscountList = orderCancelDiscountList;
//              controller.discountAll = 1;
              controller.vc = self;
              
              
              // present the controller
              // on iPad, this will be a Popover
              // on iPhone, this will be an action sheet
              controller.modalPresentationStyle = UIModalPresentationPopover;
              [self presentViewController:controller animated:YES completion:nil];
              
              
              // configure the Popover presentation controller
              UIPopoverPresentationController *popController = [controller popoverPresentationController];
              popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
              popController.delegate = self;
              
              
              CGRect frame = cell.bounds;
              frame.origin.y = frame.origin.y-15;
              popController.sourceView = cell;
              popController.sourceRect = frame;
              
          }]];
    }
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {}]];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
        CGRect frame = cell.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    
    CGPoint point = [gestureRecognizer locationInView:colVwMemberDetail];
    NSIndexPath * tappedIP = [colVwMemberDetail indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwMemberDetail cellForItemAtIndexPath:tappedIP];
    NSInteger item = tappedIP.item;
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          
          
          
          // grab the view controller we want to show
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          AddressViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*10+44*2+89+58);
          controller.memberID = _member.memberID;
          controller.vc = self;
          controller.firstAddressFlag = [_addressList count]==0;
          controller.editAddress = _addressList[item - 1 - 6];
          controller.addressList = _addressList;
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationFormSheet;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
          
          
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                
                                Address *address = _addressList[item - 1 - 6];
                                [Address removeObject:address];
                                [self.homeModel deleteItems:dbAddress withData:address actionScreen:@"Delete address in receipt screen"];
                                [self reloadMemberDetail];
                            }]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
        CGRect frame = cell.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addDiscount:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    //get discountList
    NSMutableArray *discountList = [Discount getDiscountListWithStatus:1];
    
    //get rewardProgramList
    NSMutableArray *rewardProgramList = [RewardProgram getRewardProgramUseListToday];
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DiscountViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DiscountViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*[discountList count]+44*[rewardProgramList count]+44*3+44*3+58); //58= confirmAndCancel footer
    controller.discountList = discountList;
    controller.rewardProgramList = rewardProgramList;
    controller.customerTable = customerTable;
    controller.member = _member;
    controller.vc = self;
    [self selectReceipt];
    controller.receipt = _usingReceipt;
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    // in case we don't have a bar button as reference
    UIButton *button = sender;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
    
}

- (IBAction)deleteDiscount:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบส่วนลด"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          [self selectReceipt];
          _usingReceipt.discountType = 0;
          _usingReceipt.discountAmount = 0;
          _usingReceipt.discountReason = @"";
          _usingReceipt.modifiedUser = [Utility modifiedUser];
          _usingReceipt.modifiedDate = [Utility currentDateTime];
          
          
          
          
          RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_usingReceipt.receiptID status:0];
          if(rewardPoint)
          {
              [RewardPoint removeObject:rewardPoint];
              [self.homeModel deleteItems:dbRewardPoint withData:rewardPoint actionScreen:@"delete reward point from delete button in receipt screen"];
          }
          
          [self loadViewProcess];
      }]];
    
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {}]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        UIButton *button = sender;
        CGRect frame = button.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = button;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)mergeReceipt:(id)sender
{
    [self performSegueWithIdentifier:@"segSelectCustomerTableToMerge" sender:self];
}

- (IBAction)closeTable:(id)sender
{
    //check credit and cash
    if(![self validateReceipt])
    {
        return;
    }
    
    
    if(_receipt.mergeReceiptID == 0)
    {
        //billPrint
        NSMutableArray *billPrintList = [BillPrint getBillPrintListWithReceiptID:_receipt.receiptID];
        
        
        //reward point
        NSMutableArray *rewardPointList = [[NSMutableArray alloc]init];
        
        
        //insert reward collect
        RewardProgram *rewardProgramCollect = [RewardProgram getRewardProgramCollectToday];
        if(rewardProgramCollect && _member)
        {
            float point = _totalAmount/rewardProgramCollect.salesSpent*rewardProgramCollect.receivePoint;
            RewardPoint *rewardPoint = [[RewardPoint alloc]initWithMemberID:_member.memberID receiptID:0 point:point status:1];
            [RewardPoint addObject:rewardPoint];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        //update rewardpoint ใช้ไป (มีการ insert ตอนกดใช้ใน function discount)
        RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:_receipt.receiptID status:0];
        if(rewardPoint)
        {
            rewardPoint.status = -1;
            rewardPoint.modifiedUser = [Utility modifiedUser];
            rewardPoint.modifiedDate = [Utility currentDateTime];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        //update tabletaking
        NSMutableArray *tableTakingList = [[NSMutableArray alloc]init];
        TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
        //update tabletaking
        tableTaking.receiptID = _receipt.receiptID;
        tableTaking.modifiedUser = [Utility modifiedUser];
        tableTaking.modifiedDate = [Utility currentDateTime];
        [tableTakingList addObject:tableTaking];
        
        
        
        //update ordertaking
        //in db
        NSMutableArray *inDbOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
        
        
        //display (data from create sum)
        NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
        NSMutableArray *status3OrderTakingList = [OrderTaking getOrderTakingListWithStatus:3 orderTakingList:_orderTakingList];
        [orderTakingList addObjectsFromArray:status2OrderTakingList];
        [orderTakingList addObjectsFromArray:status3OrderTakingList];
        
        
        //db
        for(OrderTaking *item in inDbOrderTakingList)
        {
            item.status = item.status == 2?0:4;//2->0,3->4
            item.receiptID = _receipt.receiptID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        
        
        //display
        for(OrderTaking *item in orderTakingList)
        {
            item.status = item.status == 2?0:4;//2->0,3->4
            item.receiptID = _receipt.receiptID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        
        
        
        
        //update receipt
        float creditCardAmount = _usingReceipt.creditCardAmount > _totalAmount?_totalAmount:_usingReceipt.creditCardAmount;
        float transferAmount = _usingReceipt.transferAmount > _totalAmount - creditCardAmount?_totalAmount - creditCardAmount:_usingReceipt.transferAmount;
        float cashAmount = _usingReceipt.cashAmount > _totalAmount - creditCardAmount - transferAmount ?_totalAmount - creditCardAmount - transferAmount:_usingReceipt.cashAmount;
        
        
        NSMutableArray *status0OrderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:_orderTakingList];
        _receipt.status = [status0OrderTakingList count]==0?3:2;
        _receipt.cashAmount = cashAmount;
        _receipt.creditCardAmount = creditCardAmount;
        _receipt.transferAmount = transferAmount;
        _receipt.receiptDate = [Utility currentDateTime];
        _receipt.modifiedUser = [Utility modifiedUser];
        _receipt.modifiedDate = [Utility currentDateTime];
        
        
        NSArray *dataList = @[billPrintList, rewardPointList,tableTakingList,inDbOrderTakingList,_receipt];
        [self.homeModel updateItems:dbReceiptCloseTable withData:dataList actionScreen:@"update receipt and relevant table when close table in receipt screen"];
        
        
        //print receipt
        if(_receipt.status == 2)
        {
//            NSInteger printReceipt = [[Setting getSettingValueWithKeyName:@"printReceipt"] integerValue];
//            if(printReceipt)
            {
                [self printBill:nil];
            }
        }
        else
        {
            [self showAlert:@"" message:@"ปิดโต๊ะสำเร็จ" method:@selector(segueBackToCustomerTable)];
        }
    }
    else if(_receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999))//mergeReceipt
    {
        //billPrint
        NSMutableArray *billPrintList = [BillPrint getBillPrintListWithReceiptID:_receipt.receiptID];
        
        
        
        //reward point
        NSMutableArray *rewardPointList = [[NSMutableArray alloc]init];
        
        
        
        //update rewardpoint ใช้ไป (มีการ insert ตอนกดใช้ใน function discount)
        Receipt *mergeReceipt = [Receipt getReceipt:_receipt.mergeReceiptID];
        RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:mergeReceipt.receiptID status:0];
        if(rewardPoint)
        {
            rewardPoint.status = -1;
            rewardPoint.modifiedUser = [Utility modifiedUser];
            rewardPoint.modifiedDate = [Utility currentDateTime];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        //insert reward collect
        RewardProgram *rewardProgramCollect = [RewardProgram getRewardProgramCollectToday];
        if(rewardProgramCollect && _member)
        {
            float point = _totalAmount/rewardProgramCollect.salesSpent*rewardProgramCollect.receivePoint;
            RewardPoint *rewardPoint = [[RewardPoint alloc]initWithMemberID:_member.memberID receiptID:0 point:point status:1];
            [RewardPoint addObject:rewardPoint];
            [rewardPointList addObject:rewardPoint];
        }
        
        
        
        
        
        //delete ongoing and insert current to db
        NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_receipt.mergeReceiptID];
        
        
        
        
        
        //update tabletaking
        NSMutableArray *customerTableList = [ReceiptCustomerTable getCustomerTableListWithMergeReceiptID:_receipt.mergeReceiptID];
        NSMutableArray *tableTakingList = [TableTaking getTableTakingListWithCustomerTableList:customerTableList receiptID:0];
        for(TableTaking *item in tableTakingList)
        {
            item.receiptID = mergeReceipt.receiptID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        
        
        
        
        
        //update OrderTaking
        //part inDB
        NSMutableArray *allOrderTakingList = [[NSMutableArray alloc]init];
        for(ReceiptCustomerTable *item in receiptCustomerTableList)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:item.customerTableID statusList:@[@2,@3]];
            [allOrderTakingList addObjectsFromArray:orderTakingList];
        }
        for(OrderTaking *item in allOrderTakingList)
        {
            item.status = item.status == 2?0:4;//2->0,3->4
            item.receiptID = _receipt.mergeReceiptID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        
        
        
        
        //part display
        NSMutableArray *disPlayAllOrderTakingList = [[NSMutableArray alloc]init];
        {
            NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
            NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithStatus:2 orderTakingList:_orderTakingList];
            NSMutableArray *status3OrderTakingList = [OrderTaking getOrderTakingListWithStatus:3 orderTakingList:_orderTakingList];
            [orderTakingList addObjectsFromArray:status2OrderTakingList];
            [orderTakingList addObjectsFromArray:status3OrderTakingList];
            [disPlayAllOrderTakingList addObjectsFromArray:orderTakingList];
        }
        for(OrderTaking *item in disPlayAllOrderTakingList)
        {
            item.status = item.status == 2?0:4;//2->0,3->4
            item.receiptID = _receipt.mergeReceiptID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        
        
        
        
        
        
        //หากเป็น merge receipt ให้ delete receipt ของ table เดี่ยวๆไปเลย
        NSMutableArray *receiptList = [ReceiptCustomerTable getReceiptListWithMergeReceiptID:_receipt.mergeReceiptID];
        [Receipt removeList:receiptList];
        
        
        
        
        
        {
            //sum serving person to receipt
            NSInteger sum = [TableTaking getSumServingPersonWithCustomerTableList:customerTableList receiptID:0];
            float creditCardAmount = _usingReceipt.creditCardAmount > _totalAmount?_totalAmount:_usingReceipt.creditCardAmount;
            float transferAmount = _usingReceipt.transferAmount > _totalAmount - creditCardAmount?_totalAmount - creditCardAmount:_usingReceipt.transferAmount;
            float cashAmount = _usingReceipt.cashAmount > _totalAmount - creditCardAmount - transferAmount ?_totalAmount - creditCardAmount - transferAmount:_usingReceipt.cashAmount;
            
            
            NSMutableArray *status0OrderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:_orderTakingList];
            mergeReceipt.customerTableID = customerTable.customerTableID;
            mergeReceipt.servingPerson = sum;
            mergeReceipt.customerType = customerTable.type;
            mergeReceipt.status = [status0OrderTakingList count]==0?3:2;
            mergeReceipt.cashAmount = cashAmount;
            mergeReceipt.creditCardAmount = creditCardAmount;
            mergeReceipt.receiptDate = [Utility currentDateTime];
            mergeReceipt.modifiedUser = [Utility modifiedUser];
            mergeReceipt.modifiedDate = [Utility currentDateTime];
        }
        
        
        
        
        //insert
        NSArray *dataList = @[billPrintList, rewardPointList,receiptCustomerTableList,tableTakingList,allOrderTakingList,receiptList,mergeReceipt];
        
        
        [self loadingOverlayView];
        [self.homeModel insertItems:dbMergeReceiptCloseTable withData:dataList actionScreen:@"insert relevant table when close table"];
        
        
        //print receipt
        if(mergeReceipt.status == 2)
        {
//            NSInteger printReceipt = [[Setting getSettingValueWithKeyName:@"printReceipt"] integerValue];
//            if(printReceipt)
            {
                [self printBill:nil];
            }
        }
        else
        {
            [self showAlert:@"" message:@"ปิดโต๊ะสำเร็จ" method:@selector(segueBackToCustomerTable)];
        }
    }
    else if(_receipt.mergeReceiptID == -999)
    {
        //update tabletaking
        TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
        Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:4];
        tableTaking.receiptID = receipt?receipt.receiptID:-998;//can be any number ที่ไม่เท่ากับ 0, หลังจากมี receipt ไม่จำเป็นต้อง refer data จาก table นี้
        tableTaking.modifiedUser = [Utility modifiedUser];
        tableTaking.modifiedDate = [Utility currentDateTime];
        
        
        NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *status3OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:3];
        NSMutableArray *status5OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:5];
        for(OrderTaking *item in status5OrderTakingList)
        {
            item.status = 6;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        [orderTakingList addObjectsFromArray:status5OrderTakingList];
        
        
        if([status3OrderTakingList count] > 0)
        {
            //update orderTaking
            for(OrderTaking *item in status3OrderTakingList)
            {
                item.receiptID = _receipt.receiptID;
                item.status = 4;
                item.modifiedUser = [Utility modifiedUser];
                item.modifiedDate = [Utility currentDateTime];
            }
            [orderTakingList addObjectsFromArray:status3OrderTakingList];
            
            
            
            //update receipt
            _receipt.status = 3;
            _receipt.receiptDate = [Utility currentDateTime];
            _receipt.modifiedUser = [Utility modifiedUser];
            _receipt.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbTableTakingReceiptOrderTakingListUpdate withData:@[tableTaking,_receipt,orderTakingList] actionScreen:@"update tabletaking, receipt and ordertakinglist when close table"];
        }
        else
        {
            //update orderTaking
            
            
            //delete receipt
            [Receipt removeObject:_receipt];
            [self.homeModel updateItems:dbTableTakingOrderTakingReceiptUpdateDelete withData:@[tableTaking,orderTakingList,_receipt] actionScreen:@"update tabletaking,orderTaking and delete receipt when close table"];
        }
        
        
        [self segueBackToCustomerTable];
    }
    
    
}

- (IBAction)moveTable:(id)sender
{
    [self performSegueWithIdentifier:@"segSelectCustomerTableToMove" sender:self];
}

-(void)segueBackToCustomerTable
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (BOOL)validateReceipt//close table for normal or merge or paysplitbill
{
    [self selectReceipt];
    
    if(_receipt.mergeReceiptID == -999  && _splitBillStatus)
    {
        NSArray *selectedIndexPath =  colVwReceiptOrder.indexPathsForSelectedItems;
        if([selectedIndexPath count] == 0)
        {
            [self showAlert:@"" message:@"กรุณาเลือกรายการที่ต้องการชำระบิลย่อย"];
            return NO;
        }
    }
    
    
    
    
    
    OrderTaking *lastOrderTaking;
    NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    if(_receipt.mergeReceiptID == 0 || (_receipt.mergeReceiptID == -999  && _splitBillStatus && [status2OrderTakingList count]>0))//normal or paysplitbill(exclude close table)
    {
        NSMutableArray *inDbOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
        inDbOrderTakingList = [OrderTaking sortListByModifiedDateDesc:inDbOrderTakingList];
        lastOrderTaking = inDbOrderTakingList[0];
    }
    else if(_receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999))//mergeReceipt
    {
        NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_receipt.mergeReceiptID];
        NSMutableArray *allOrderTakingList = [[NSMutableArray alloc]init];
        for(ReceiptCustomerTable *item in receiptCustomerTableList)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:item.customerTableID statusList:@[@2,@3]];
            [allOrderTakingList addObjectsFromArray:orderTakingList];
        }
        
        allOrderTakingList = [OrderTaking sortListByModifiedDateDesc:allOrderTakingList];
        lastOrderTaking = allOrderTakingList[0];
    }
    
    
    
    if(_receipt.mergeReceiptID == 0 || _receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999) || (_receipt.mergeReceiptID == -999  && _splitBillStatus))
    {
        NSInteger printInvoice = [[Setting getSettingValueWithKeyName:@"printInvoice"] integerValue];
        if(printInvoice)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
            if([orderTakingList count] > 0)
            {
                NSMutableArray *billPrintList = [BillPrint getBillPrintListWithReceiptID:_usingReceipt.receiptID];
                billPrintList = [BillPrint sortListByBillPrintDateDesc:billPrintList];
                if([billPrintList count] == 0)
                {
                    [self showAlert:@"" message:@"กรุณาพิมพ์ใบเรียกเก็บเงินก่อนชำระเงิน"];
                    return NO;
                }
                else
                {
                    BillPrint *lastBillPrint = billPrintList[0];
                    NSComparisonResult result = [lastOrderTaking.modifiedDate compare:lastBillPrint.billPrintDate];
                    if(!(result == NSOrderedAscending))
                    {
                        [self showAlert:@"" message:@"กรุณาพิมพ์ใบเรียกเก็บเงินก่อนชำระเงิน"];
                        return NO;
                    }
                }
            }
        }
        
        
        if(_usingReceipt.creditCardAmount + _usingReceipt.cashReceive + _usingReceipt.transferAmount < _totalAmount)
        {
            [self showAlert:@"" message:@"ชำระเงินไม่ครบ"];
            return NO;
        }
    }
    else if(_receipt.mergeReceiptID == -999 && !_splitBillStatus)//เช็คว่าชำระเงิน(บิลย่อย)ครบทุกรายการแล้ว
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
        if([orderTakingList count] != 0)
        {
            [self showAlert:@"" message:@"ไม่สามารถปิดโต๊ะได้ กรุณาชำระบิลย่อยให้ครบก่อนปิดโต๊ะ"];
            return NO;
        }
    }
    
    return YES;
}

- (void)updatePaidAmount
{
    [self selectReceipt];
    float changesAmount = _usingReceipt.cashReceive + _usingReceipt.creditCardAmount + _usingReceipt.transferAmount - _totalAmount;
    lblPaidAmount.text = [Utility formatDecimal:_usingReceipt.cashReceive + _usingReceipt.creditCardAmount + _usingReceipt.transferAmount withMinFraction:2 andMaxFraction:2];
    lblChanges.text = [Utility formatDecimal:changesAmount withMinFraction:2 andMaxFraction:2];
}

-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    [self.view endEditing:YES];
    _editingMember.gender = segment.selectedSegmentIndex == 0?@"M":segment.selectedSegmentIndex == 1?@"F":@"N";
}

- (void)alertMsg:(NSString *)msg
{
    [self removeOverlayViews];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self loadingOverlayView];
                                        [self.homeModel downloadItems:dbMaster];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)itemsDownloaded:(NSArray *)items
{
    [Utility itemsDownloaded:items];
    [self loadViewProcess];
    [self removeOverlayViews];
}

-(void)selectReceipt
{
    if(_receipt.mergeReceiptID == 0)
    {
        _usingReceipt = _receipt;
    }
    else if(_receipt.mergeReceiptID == -999)
    {
        _usingReceipt = _splitReceipt;
    }
    else if(_receipt.mergeReceiptID > 0 || (_receipt.mergeReceiptID < 0 && _receipt.mergeReceiptID != -999))
    {
        _usingReceipt = [Receipt getReceipt:_receipt.mergeReceiptID];
    }
}

- (void)itemsInsertedWithReturnID:(NSString *)strID;
{
    if(self.homeModel.propCurrentDBInsert == dbPaySplitBillInsert || self.homeModel.propCurrentDBInsert == dbPaySplitBillInsertAfterFirstTime)
    {
        
        [self showAlert:@"" message:@"ชำระบิลย่อยสำเร็จ"];
        
        
        _splitReceipt = [[Receipt alloc]initWithCustomerTableID:0 memberID:0 servingPerson:0 customerType:0 openTableDate:[Utility notIdentifiedDate] cashAmount:0 cashReceive:0 creditCardType:0 creditCardNo:@"" creditCardAmount:0 transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:@"" discountType:0 discountAmount:0 discountReason:@"" status:1 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility notIdentifiedDate] mergeReceiptID:0];
        _receipt.receiptNoID = strID;
        _splitReceipt.receiptNoID = _receipt.receiptNoID;
        _splitReceipt.openTableDate = _receipt.openTableDate;
        [self getOrderTaking];
        _orderTakingList = [OrderTaking separateOrder:_orderTakingList];
        [colVwReceiptOrder reloadData];
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
        [self removeOverlayViews];
        _waitingForItemsInserted = NO;
    }
    else if(self.homeModel.propCurrentDBInsert == dbPaySplitBillInsertLastOne || self.homeModel.propCurrentDBInsert == dbPaySplitBillInsertWithoutReceipt)
    {
        _splitReceipt = nil;
        [self getOrderTaking];
        _orderTakingList = [OrderTaking separateOrder:_orderTakingList];
        [colVwReceiptOrder reloadData];
        [self updateTotalOrderAndAmount];
        [self updatePaidAmount];
        [self removeOverlayViews];
    }
}

-(void) removeOverlayViews
{
    [super removeOverlayViews];
    if (_waitingForItemsInserted)
    {
        [self loadingOverlayView];
    }
}

@end

