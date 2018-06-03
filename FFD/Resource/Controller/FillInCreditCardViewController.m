//
//  FillInCreditCardViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "FillInCreditCardViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellCreditCardType.h"
#import "CustomTableViewCellPaidAmount.h"
#import "CustomTableViewCellButton.h"


@interface FillInCreditCardViewController ()
{
    UITextField *_txtCreditCardNo;
    UITextField *_txtPaidAmount;
    UIButton *_btnAmericanExpress;
    UIButton *_btnJCB;
    UIButton *_btnMasterCard;
    UIButton *_btnUnionPay;
    UIButton *_btnVisa;
    UIButton *_btnOther;
    NSInteger _selectedCreditCardType;
}

@end

@implementation FillInCreditCardViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierCreditCardType = @"CustomTableViewCellCreditCardType";
static NSString * const reuseIdentifierPaidAmount = @"CustomTableViewCellPaidAmount";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";


@synthesize tbvCreditCard;
@synthesize receipt;
@synthesize vwConfirmAndCancel;
@synthesize totalAmount;
@synthesize vc;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:_txtPaidAmount])
    {
        [vwConfirmAndCancel.btnConfirm sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    else if([textField isEqual:_txtCreditCardNo])
    {
        [_txtPaidAmount becomeFirstResponder];
    }
    
    return NO;
}

- (void)loadView
{
    [super loadView];
    _selectedCreditCardType = receipt.creditCardType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tbvCreditCard.dataSource = self;
    tbvCreditCard.delegate = self;

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvCreditCard registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCreditCardType bundle:nil];
        [tbvCreditCard registerNib:nib forCellReuseIdentifier:reuseIdentifierCreditCardType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPaidAmount bundle:nil];
        [tbvCreditCard registerNib:nib forCellReuseIdentifier:reuseIdentifierPaidAmount];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvCreditCard registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }


    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvCreditCard.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditCreditCard:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelCreditCard:) forControlEvents:UIControlEventTouchUpInside];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 4;
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
        CustomTableViewCellCreditCardType *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCreditCardType];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _btnAmericanExpress = cell.btnAmericanExpress;
        _btnJCB = cell.btnJCB;
        _btnMasterCard = cell.btnMasterCard;
        _btnUnionPay = cell.btnUnionPay;
        _btnVisa = cell.btnVisa;
        _btnOther = cell.btnOther;
        [_btnAmericanExpress addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        [_btnJCB addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        [_btnMasterCard addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        [_btnUnionPay addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        [_btnVisa addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        [_btnOther addTarget:self action:@selector(tapCreditCard:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (receipt.creditCardType)
        {
            case 0:
            {
                [self setSelectedButton:_btnOther];
            }
                break;
            case 1:
            {
                [self setSelectedButton:_btnAmericanExpress];
            }
                break;
            case 2:
            {
                [self setSelectedButton:_btnJCB];
            }
                break;
            case 3:
            {
                [self setSelectedButton:_btnMasterCard];
            }
                break;
            case 4:
            {
                [self setSelectedButton:_btnUnionPay];
            }
                break;
            case 5:
            {
                [self setSelectedButton:_btnVisa];
            }
                break;
            default:
                break;
        }
        
        
        return cell;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"หมายเลขบัตร:";
        _txtCreditCardNo = cell.txtValue;
        _txtCreditCardNo.placeholder = @"xxxxxxxxxxxxxxxx";
        _txtCreditCardNo.delegate = self;
        _txtCreditCardNo.keyboardType = UIKeyboardTypeNumberPad;
        _txtCreditCardNo.text = receipt.creditCardNo;
        _txtCreditCardNo.borderStyle = UITextBorderStyleNone;
        CGRect frame = _txtCreditCardNo.frame;
        frame.origin.y = frame.origin.y-15;
        frame.size.height = 66;
        _txtCreditCardNo.frame = frame;
        _txtCreditCardNo.font = [UIFont systemFontOfSize:24];
        

        return cell;
    }
    else if(item == 3)
    {
        CustomTableViewCellPaidAmount *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPaidAmount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text = @"จำนวนเงิน:";
        _txtPaidAmount = cell.txtValue;
        _txtPaidAmount.placeholder = @"0.00";
        _txtPaidAmount.delegate = self;
        _txtPaidAmount.keyboardType = UIKeyboardTypeDecimalPad;
        _txtPaidAmount.text = receipt.creditCardAmount == 0?@"":[Utility removeComma:[Utility formatDecimal:receipt.creditCardAmount]];
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
    return indexPath.item==3?345:74;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

- (void)addEditCreditCard:(id)sender
{
    if(![self validateCreditCard])
    {
        return;
    }
    

    if([Utility floatValue:_txtPaidAmount.text] == 0 )
    {
        //clear credit card info
        receipt.creditCardType = 0;
        receipt.creditCardNo = @"";
        receipt.creditCardAmount = 0;
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             [vc updatePaidAmount];
         }];
    }
    else
    {

        //update credit card info
        receipt.creditCardType = _selectedCreditCardType;
        receipt.creditCardNo = _txtCreditCardNo.text;
        receipt.creditCardAmount = [Utility floatValue:_txtPaidAmount.text];
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

- (void)cancelCreditCard:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateCreditCard
{
    //require phone on
    if([_txtCreditCardNo.text length] != 16)
    {
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขบัตร 16 หลัก"];
        return NO;
    }
    
    return YES;
}

- (void)tapCreditCard:(id)sender
{
    
    _btnAmericanExpress.selected = 0;
    _btnJCB.selected = 0;
    _btnMasterCard.selected = 0;
    _btnUnionPay.selected = 0;
    _btnVisa.selected = 0;
    _btnOther.selected = 0;
    
    
    _btnAmericanExpress.layer.borderWidth = 0;
    _btnJCB.layer.borderWidth = 0;
    _btnMasterCard.layer.borderWidth = 0;
    _btnUnionPay.layer.borderWidth = 0;
    _btnVisa.layer.borderWidth = 0;
    _btnOther.layer.borderWidth = 0;
    
    
    [self setSelectedButton:sender];
    
    
    if([sender isEqual:_btnAmericanExpress])
    {
        _selectedCreditCardType = 1;
    }
    else if([sender isEqual:_btnJCB])
    {
        _selectedCreditCardType = 2;
    }
    else if([sender isEqual:_btnMasterCard])
    {
        _selectedCreditCardType = 3;
    }
    else if([sender isEqual:_btnUnionPay])
    {
        _selectedCreditCardType = 4;
    }
    else if([sender isEqual:_btnVisa])
    {
        _selectedCreditCardType = 5;
    }
    else if([sender isEqual:_btnOther])
    {
        _selectedCreditCardType = 0;
    }
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
    else if([textField isEqual:_txtCreditCardNo])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        NSInteger holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanInteger: &holder] && [scan isAtEnd] && [resultingString length] <= 16;
    }
    
    
    
    return YES;
}

-(void)setSelectedButton:(UIButton *)button
{
    button.layer.borderWidth = 4;
    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
    button.selected = 1;
}

//-(void)txtPaidAmountDidChange:(UITextField *)textField
//{
//    NSString *strChangesAmount = [Utility formatDecimal:[self getChangesAmount] withMinFraction:0 andMaxFraction:0];
//    _lblChangesAmount.text = [NSString stringWithFormat:@"เงินทอน %@ บาท",strChangesAmount];
//}

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
//    [self txtPaidAmountDidChange:nil];
}
@end
