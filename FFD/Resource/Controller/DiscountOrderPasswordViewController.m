//
//  DiscountOrderPasswordViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DiscountOrderPasswordViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelSegment.h"
#import "OrderCancelDiscount.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "Setting.h"
#import "Menu.h"


@interface DiscountOrderPasswordViewController ()
{

    UISegmentedControl *_segConDiscountAs;
    NSString *_passwordEditing;
    OrderCancelDiscount *_editingOrderCancelDiscount;
    OrderCancelDiscount *_firstLoadOrderCancelDiscount;
    OrderTaking *_discount1OrderTaking;
}

@end

@implementation DiscountOrderPasswordViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelSegment = @"CustomTableViewCellLabelSegment";


@synthesize tbvDiscountOrder;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize orderTaking;
@synthesize discountAll;
@synthesize editOrderCancelDiscountList;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    switch (textField.tag) {
        case 2:
        {
            if([Utility floatValue:textField.text] == 0)
            {
                textField.text = @"";
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
            _passwordEditing = [Utility trimString:textField.text];
            break;
        case 2:
            _editingOrderCancelDiscount.discountAmount = [Utility floatValue:textField.text];
            break;
        case 3:
            _editingOrderCancelDiscount.reason = [Utility trimString:textField.text];
            break;
        default:
            break;
    }
}

-(void)viewDidLayoutSubviews
{

}

-(void)loadView
{
    [super loadView];

    
    if([editOrderCancelDiscountList count] > 0)
    {
        OrderCancelDiscount *orderCancelDiscount = editOrderCancelDiscountList[0];
        _firstLoadOrderCancelDiscount = [orderCancelDiscount copy];
        _editingOrderCancelDiscount = [orderCancelDiscount copy];
    }
    else
    {
        _firstLoadOrderCancelDiscount = [[OrderCancelDiscount alloc]init];
        _firstLoadOrderCancelDiscount.type = 2;
        _firstLoadOrderCancelDiscount.discountType = 1;
        _editingOrderCancelDiscount = [_firstLoadOrderCancelDiscount copy];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    tbvDiscountOrder.dataSource = self;
    tbvDiscountOrder.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvDiscountOrder registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvDiscountOrder registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSegment bundle:nil];
        [tbvDiscountOrder registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelSegment];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvDiscountOrder.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmPassword:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 0?3:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(section == 0)
    {
        switch (item)
        {
            case 0:
            {
                CustomTableViewCellLabelSegment *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelSegment];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.lblTitle.text = @"ส่วนลดเป็น:";
                _segConDiscountAs = cell.segConGender;
                [_segConDiscountAs removeAllSegments];
                [_segConDiscountAs insertSegmentWithTitle:@"บาท" atIndex:0 animated:NO];
                [_segConDiscountAs insertSegmentWithTitle:@"%" atIndex:1 animated:NO];
                _segConDiscountAs.selectedSegmentIndex = _editingOrderCancelDiscount.discountType == 0 || _editingOrderCancelDiscount.discountType == 1?0:1;
                [_segConDiscountAs addTarget:self action:@selector(segConValueChanged:) forControlEvents:UIControlEventValueChanged];
                
                
                return cell;
            }
                break;
            case 1:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
                
                
                cell.lblTitle.text = @"จำนวน:";
                cell.txtValue.tag = 2;
                cell.txtValue.delegate = self;
                cell.txtValue.text = [Utility removeComma:[Utility formatDecimal:_editingOrderCancelDiscount.discountAmount]];
                
                
                return cell;
            }
                break;
            case 2:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.txtValue.keyboardType = UIKeyboardTypeDefault;
                
                
                cell.lblTitle.text = @"เหตุผล:";
                cell.txtValue.tag = 3;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _editingOrderCancelDiscount.reason;
                cell.txtValue.placeholder = @"ใส่เหตุผล";
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else if(section == 1)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"รหัสผ่าน:";
        cell.txtValue.tag = 1;
        cell.txtValue.placeholder = @"xxxxxx";
        cell.txtValue.delegate = self;
        cell.txtValue.text = _passwordEditing;
        cell.txtValue.secureTextEntry = YES;
        
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
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (void)confirmPassword:(id)sender
{
    [self.view endEditing:YES];
    if(![self validatePassword])
    {
        return;
    }
    
    
    if([editOrderCancelDiscountList count] > 0)
    {
        if(_editingOrderCancelDiscount.discountAmount == 0)
        {
            [OrderCancelDiscount removeList:editOrderCancelDiscountList];
            [self.homeModel deleteItems:dbOrderCancelDiscountList withData:editOrderCancelDiscountList actionScreen:@"deleteList orderCancelDiscount in discount order screen"];
        }
        else
        {
            for(OrderCancelDiscount *item in editOrderCancelDiscountList)
            {
                //update status to 3
                item.discountType = _editingOrderCancelDiscount.discountType;
                item.discountAmount = _editingOrderCancelDiscount.discountAmount;
                item.reason = _editingOrderCancelDiscount.reason;
                item.modifiedUser = [Utility modifiedUser];
                item.modifiedDate = [Utility currentDateTime];
            }
            [self.homeModel updateItems:dbOrderCancelDiscountList withData:editOrderCancelDiscountList actionScreen:@"updateList orderCancelDiscount in discount order screen"];
        }
        
    }
    else
    {
//        if(orderTaking.quantity == 1)
//        {
//            OrderCancelDiscount *orderCancelDiscount = [[OrderCancelDiscount alloc]initWithOrderTakingID:orderTaking.orderTakingID type:2 discountType:_editingOrderCancelDiscount.discountType discountAmount:_editingOrderCancelDiscount.discountAmount reason:_editingOrderCancelDiscount.reason];
//            [OrderCancelDiscount addObject:orderCancelDiscount];
//            [self.homeModel insertItems:dbOrderCancelDiscount withData:orderCancelDiscount actionScreen:@"insert orderCancelDiscount in Discount order screen"];
//        
//        }
//        else
        if(discountAll)//ใส่ส่วนลดทั้งรายการ
        {
            NSMutableArray *discountOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:orderTaking.customerTableID status:orderTaking.status takeAway:orderTaking.takeAway menuID:orderTaking.menuID noteIDListInText:orderTaking.noteIDListInText specialPrice:orderTaking.specialPrice cancelDiscountReason:orderTaking.cancelDiscountReason];
            
            
            NSMutableArray *orderCancelDiscountList = [[NSMutableArray alloc]init];
            for(OrderTaking *item in discountOrderTakingList)
            {
                item.specialPrice = [self getTotalPriceDiscount];
                item.modifiedUser = [Utility modifiedUser];
                item.modifiedDate = [Utility currentDateTime];
                OrderCancelDiscount *orderCancelDiscount = [[OrderCancelDiscount alloc]initWithOrderTakingID:item.orderTakingID type:2 discountType:_editingOrderCancelDiscount.discountType discountAmount:_editingOrderCancelDiscount.discountAmount reason:_editingOrderCancelDiscount.reason];
                [OrderCancelDiscount addObject:orderCancelDiscount];
                [orderCancelDiscountList addObject:orderCancelDiscount];
            }
            [self.homeModel insertItems:dbOrderCancelDiscountOrderTakingList withData:@[orderCancelDiscountList,discountOrderTakingList] actionScreen:@"insertList orderCancelDiscount and updatelist ordertakingList in discount order screen"];
        }
        else//ใส่ส่วนลด 1 รายการ
        {
            OrderTaking *minusOneOrderTaking = [OrderTaking getOrderTakingWithCustomerTableID:orderTaking.customerTableID status:orderTaking.status takeAway:orderTaking.takeAway menuID:orderTaking.menuID noteIDListInText:orderTaking.noteIDListInText specialPrice:orderTaking.specialPrice cancelDiscountReason:orderTaking.cancelDiscountReason];
            
            
            //แบ่งเป็น 2 กรณี 1.ordertaking นั้น quantity = 1,  2.ordertaking นั้น quantity > 1
            if(minusOneOrderTaking.quantity == 1)
            {
                minusOneOrderTaking.specialPrice = [self getTotalPriceDiscount];
                minusOneOrderTaking.modifiedUser = [Utility modifiedUser];
                minusOneOrderTaking.modifiedDate = [Utility currentDateTime];
                
                
                OrderCancelDiscount *orderCancelDiscount = [[OrderCancelDiscount alloc]initWithOrderTakingID:minusOneOrderTaking.orderTakingID type:2 discountType:_editingOrderCancelDiscount.discountType discountAmount:_editingOrderCancelDiscount.discountAmount reason:_editingOrderCancelDiscount.reason];
                [OrderCancelDiscount addObject:orderCancelDiscount];
                
                NSMutableArray *orderCancelDiscountList = [[NSMutableArray alloc]init];
                NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
                [orderCancelDiscountList addObject:orderCancelDiscount];
                [orderTakingList addObject:minusOneOrderTaking];
                
                [self.homeModel insertItems:dbOrderCancelDiscountOrderTakingList withData:@[orderCancelDiscountList,orderTakingList] actionScreen:@"insertList orderCancelDiscount and updatelist ordertakingList in discount order screen(discount 1)"];
            }
            else
            {
                //split ordertaking 1.quantity=quantity-1 2.quantity=1
                //update existing one
                minusOneOrderTaking.quantity -= 1;
                minusOneOrderTaking.modifiedUser = [Utility modifiedUser];
                minusOneOrderTaking.modifiedDate = [Utility currentDateTime];
    
    
    
                //create new orderTaking
                OrderTaking *discountOrderTaking = [minusOneOrderTaking copy];
                discountOrderTaking.orderTakingID = [OrderTaking getNextID];
                discountOrderTaking.quantity = 1;
                discountOrderTaking.specialPrice = [self getTotalPriceDiscount];
                _discount1OrderTaking = discountOrderTaking;
                [OrderTaking addObject:discountOrderTaking];
    
    
    
                //create new orderNote
                //ordernote for cancelOrderTaking
                NSMutableArray *newOrderNoteList = [[NSMutableArray alloc]init];
                NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:minusOneOrderTaking.orderTakingID];
                for(OrderNote *item in orderNoteList)
                {
                    OrderNote *orderNote = [item copy];
                    orderNote.orderNoteID = [OrderNote getNextID];
                    orderNote.orderTakingID = discountOrderTaking.orderTakingID;
                    [OrderNote addObject:orderNote];
                    [newOrderNoteList addObject:orderNote];
                }
    
    
    
                //create new orderKitchen
                //orderkitchen for cancelOrderTaking
                OrderKitchen *selectedOrderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:minusOneOrderTaking.orderTakingID];
                OrderKitchen *orderKitchen = [selectedOrderKitchen copy];
                orderKitchen.orderKitchenID = [OrderKitchen getNextID];
                orderKitchen.orderTakingID = discountOrderTaking.orderTakingID;
                [OrderKitchen addObject:orderKitchen];
    
    
    
                //new orderCancelDiscount
                OrderCancelDiscount *orderCancelDiscount = [[OrderCancelDiscount alloc]initWithOrderTakingID:discountOrderTaking.orderTakingID type:2 discountType:_editingOrderCancelDiscount.discountType discountAmount:_editingOrderCancelDiscount.discountAmount reason:_editingOrderCancelDiscount.reason];
                [OrderCancelDiscount addObject:orderCancelDiscount];
                
                
                [self loadingOverlayView];
                [self.homeModel insertItems:dbOrderTakingOrderNoteOrderKitchenOrderCancelDiscount withData:@[minusOneOrderTaking,discountOrderTaking,newOrderNoteList,orderKitchen,orderCancelDiscount] actionScreen:@"discount order minus 1 in discountOrder screen"];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [vc showAlert:@"" message:@"ใส่ส่วนลดสำเร็จ"];
        [vc reloadReceiptOrder];
    }];
}

- (void)cancelPassword:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validatePassword
{
    if([editOrderCancelDiscountList count] == 0 && _editingOrderCancelDiscount.discountAmount == 0)
    {
        [self showAlert:@"" message:@"กรุณาใส่ส่วนลด"];
        return NO;
    }
    if(_editingOrderCancelDiscount.discountType == 2 && (_editingOrderCancelDiscount.discountAmount > 100 || _editingOrderCancelDiscount.discountAmount < 0))
    {
        [self showAlert:@"" message:@"ส่วนลดเป็นเปอร์เซ็นต์ต้องอยู่ระหว่าง 0-100"];
        return NO;
    }
    if(_editingOrderCancelDiscount.discountType == 1)
    {
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        if(_editingOrderCancelDiscount.discountAmount < 0)
        {
            [self showAlert:@"" message:@"ส่วนลดต้องมากกว่า 0"];
            return NO;
        }
        if(_editingOrderCancelDiscount.discountAmount > menu.price)
        {
            [self showAlert:@"" message:@"ส่วนลดต้องไม่มากกว่าราคาอาหาร"];
            return NO;
        }
    }
    if(![Setting isDeleteOrderPasswordValid:_passwordEditing])
    {
        [self showAlert:@"" message:@"รหัสผ่านไม่ถูกต้อง"];
        return NO;
    }
    
    return YES;
}

- (IBAction)segConValueChanged:(id)sender
{
    _editingOrderCancelDiscount.discountType = _segConDiscountAs.selectedSegmentIndex == 0?1:2;
}

-(float)getTotalPriceDiscount
{
    float totalPriceDiscount;
    float takeAwayFee = [[Setting getSettingValueWithKeyName:@"takeAwayFee"] floatValue];
    float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
    takeAwayFee = orderTaking.takeAway?takeAwayFee:0;
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    if(_editingOrderCancelDiscount.discountType == 1)//baht
    {
        totalPriceDiscount = (menu.price - _editingOrderCancelDiscount.discountAmount)+takeAwayFee+sumNotePrice;
    }
    else//%
    {
        totalPriceDiscount = menu.price * (1-_editingOrderCancelDiscount.discountAmount*0.01)+takeAwayFee+sumNotePrice;
    }
    return totalPriceDiscount;
}

- (void)itemsInsertedWithReturnID:(NSString *)strID;
{
    if(self.homeModel.propCurrentDBInsert == dbOrderTakingOrderNoteOrderKitchenOrderCancelDiscount)
    {
        _discount1OrderTaking.orderTakingID = [strID integerValue];
        [self loadViewProcess];
    }
}
@end
