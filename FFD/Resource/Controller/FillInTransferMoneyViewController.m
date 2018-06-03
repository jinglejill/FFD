//
//  FillInTransferMoneyViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 3/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "FillInTransferMoneyViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellPaidAmount.h"
#import "CustomTableViewCellButton.h"
#import "CustomTableViewCellLabelText.h"


@interface FillInTransferMoneyViewController ()
{
    UITextField *_txtPaidDate;
    UITextField *_txtPaidAmount;
}

@end

@implementation FillInTransferMoneyViewController
static NSString * const reuseIdentifierPaidAmount = @"CustomTableViewCellPaidAmount";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";


@synthesize tbvTransferMoney;
@synthesize receipt;
@synthesize vwConfirmAndCancel;
@synthesize totalAmount;
@synthesize vc;
@synthesize dtPicker;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtPaidDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy HH:mm"];
        [dtPicker setDate:datePeriod];
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([_txtPaidDate isFirstResponder])
    {
        _txtPaidDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy HH:mm"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:_txtPaidAmount])
    {
        [vwConfirmAndCancel.btnConfirm sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    else if([textField isEqual:_txtPaidDate])
    {
        [_txtPaidAmount becomeFirstResponder];
    }
    
    return NO;
}

- (void)loadView
{
    [super loadView];
    
    _txtPaidDate.inputView = dtPicker;
    _txtPaidDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tbvTransferMoney.dataSource = self;
    tbvTransferMoney.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPaidAmount bundle:nil];
        [tbvTransferMoney registerNib:nib forCellReuseIdentifier:reuseIdentifierPaidAmount];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvTransferMoney registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvTransferMoney registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvTransferMoney.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditTransferMoney:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelTransferMoney:) forControlEvents:UIControlEventTouchUpInside];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    
    if(item == 0)
    {
        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:0 andMaxFraction:0];
        [cell.btnValue setTitle:[NSString stringWithFormat:@"ยอดรวม %@ บาท",strTotalAmount] forState:UIControlStateNormal];
        cell.btnValue.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [cell.btnValue addTarget:self action:@selector(totalAmountTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    else if(item == 1)
    {
        //fill in transfer datetime
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text = @"วันที่โอนเงิน:";
        _txtPaidDate = cell.txtValue;
        cell.txtValue.delegate = self;
        if(receipt.transferDate)
        {
            cell.txtValue.text = [Utility dateToString:receipt.transferDate toFormat:@"d MMM yyyy HH:mm"];
        }
        else
        {
            cell.txtValue.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy HH:mm"];
        }
        
        
        return cell;
    }
    else if(item == 2)
    {
        CustomTableViewCellPaidAmount *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPaidAmount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text = @"จำนวนเงิน:";
        _txtPaidAmount = cell.txtValue;
        _txtPaidAmount.placeholder = @"0.00";
        _txtPaidAmount.delegate = self;
        _txtPaidAmount.keyboardType = UIKeyboardTypeDecimalPad;
        _txtPaidAmount.text = receipt.transferAmount == 0?@"":[Utility removeComma:[Utility formatDecimal:receipt.transferAmount]];
        _txtPaidAmount.borderStyle = UITextBorderStyleNone;
        CGRect frame = _txtPaidAmount.frame;
        frame.origin.y = frame.origin.y-15;
        frame.size.height = 66;
        _txtPaidAmount.frame = frame;
        _txtPaidAmount.font = [UIFont systemFontOfSize:24];
        
        
        cell.btn20.hidden = YES;
        cell.btn50.hidden = YES;
        cell.btn100.hidden = YES;
        cell.btn500.hidden = YES;
        cell.btn1000.hidden = YES;
        cell.btnClear.hidden = YES;
        [cell.btn1 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn0 addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDot addTarget:self action:@selector(numberTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete addTarget:self action:@selector(deleteDigit:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item==2?345:74;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

- (void)addEditTransferMoney:(id)sender
{
    if(![self validateTransferMoney])
    {
        return;
    }
    
    
    if([Utility floatValue:_txtPaidAmount.text] == 0 )
    {
        //clear transferAmount info
        receipt.transferDate = [Utility notIdentifiedDate];
        receipt.transferAmount = 0;
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             [vc updatePaidAmount];
         }];
    }
    else
    {        
        //update transferAmount info
        receipt.transferDate = [Utility stringToDate:_txtPaidDate.text fromFormat:@"d MMM yyyy HH:mm"];
        receipt.transferAmount = [Utility floatValue:_txtPaidAmount.text];
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             [vc updatePaidAmount];
         }];
    }
    
    
    //open cash drawer
    [self openCashDrawer];
}

- (void)cancelTransferMoney:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateTransferMoney
{
    if([Utility isStringEmpty:_txtPaidDate.text])
    {
        [self showAlert:@"" message:@"กรุณาระบุวันที่โอนเงิน"];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isEqual:_txtPaidAmount])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        float holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        
        //split
        BOOL twoDigit = NO;
        NSArray* foo = [textField.text componentsSeparatedByString: @"."];
        if([foo count] == 2)
        {
            NSString* lastBit = [foo objectAtIndex: 1];
            if([lastBit length]==2)
            {
                twoDigit = YES;
            }
        }
        
        return [scan scanFloat: &holder] && [scan isAtEnd] && !twoDigit;
    }
    
    return YES;
}

-(void)totalAmountTap:(id *)sender
{
    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:0 andMaxFraction:2];
    _txtPaidAmount.text = strTotalAmount;
}

- (void)numberTap:(id)sender
{
    UIButton *button = sender;
    UITextRange *selectedTextRange = _txtPaidAmount.selectedTextRange;
    NSUInteger location = (NSUInteger)[_txtPaidAmount offsetFromPosition:_txtPaidAmount.beginningOfDocument
                                                              toPosition:selectedTextRange.start];
    
    NSUInteger length = (NSUInteger)[_txtPaidAmount offsetFromPosition:selectedTextRange.start
                                                            toPosition:selectedTextRange.end];
    NSRange selectedRange = NSMakeRange(location, length);
    BOOL shouldChangeCharacter = [_txtPaidAmount.delegate textField:_txtPaidAmount shouldChangeCharactersInRange:selectedRange replacementString:button.titleLabel.text];
    if(shouldChangeCharacter)
    {
        _txtPaidAmount.text = [NSString stringWithFormat:@"%@%@",_txtPaidAmount.text,button.titleLabel.text];
        //        [self txtPaidAmountDidChange:nil];
    }
}

- (void)deleteDigit:(id)sender
{
    if([Utility isStringEmpty:_txtPaidAmount.text])
    {
        return;
    }
    NSRange needleRange = NSMakeRange(0,[_txtPaidAmount.text length]-1);
    _txtPaidAmount.text = [_txtPaidAmount.text substringWithRange:needleRange];
}

@end
