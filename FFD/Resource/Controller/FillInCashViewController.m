//
//  FillInCashViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "FillInCashViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellPaidAmount.h"
#import "CustomTableViewCellButton.h"


@interface FillInCashViewController ()
{
    UITextField *_txtPaidAmount;
    UILabel *_lblChangesAmount;
}

@end


@implementation FillInCashViewController
static NSString * const reuseIdentifierPaidAmount = @"CustomTableViewCellPaidAmount";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";

@synthesize tbvCash;
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
    
    return NO;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tbvCash.dataSource = self;
    tbvCash.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPaidAmount bundle:nil];
        [tbvCash registerNib:nib forCellReuseIdentifier:reuseIdentifierPaidAmount];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvCash registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvCash.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditCash:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelCash:) forControlEvents:UIControlEventTouchUpInside];
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
    if(item == 1)
    {
        CustomTableViewCellPaidAmount *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPaidAmount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text = @"จำนวนเงิน:";
        _txtPaidAmount = cell.txtValue;
        _txtPaidAmount.placeholder = @"0.00";
        _txtPaidAmount.delegate = self;
        _txtPaidAmount.keyboardType = UIKeyboardTypeDecimalPad;
        _txtPaidAmount.text = receipt.cashReceive == 0?@"":[Utility removeComma:[Utility formatDecimal:receipt.cashReceive]];
        [_txtPaidAmount addTarget:self action:@selector(txtPaidAmountDidChange:) forControlEvents:UIControlEventEditingChanged];
        _txtPaidAmount.borderStyle = UITextBorderStyleNone;
        CGRect frame = _txtPaidAmount.frame;
        frame.origin.y = frame.origin.y-15;
        frame.size.height = 66;
        _txtPaidAmount.frame = frame;
        _txtPaidAmount.font = [UIFont systemFontOfSize:24];
        [self setButtonDesign:cell.btn20];
        [self setButtonDesign:cell.btn50];
        [self setButtonDesign:cell.btn100];
        [self setButtonDesign:cell.btn500];
        [self setButtonDesign:cell.btn1000];
        [self setButtonDesign:cell.btnClear];
        [cell.btn20 addTarget:self action:@selector(addAmount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn50 addTarget:self action:@selector(addAmount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn100 addTarget:self action:@selector(addAmount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn500 addTarget:self action:@selector(addAmount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn1000 addTarget:self action:@selector(addAmount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnClear addTarget:self action:@selector(clearAmount:) forControlEvents:UIControlEventTouchUpInside];
        
        
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
    else if(item == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        _lblChangesAmount = cell.textLabel;
        NSString *strChangesAmount = [Utility formatDecimal:[self getChangesAmount] withMinFraction:0 andMaxFraction:0];
        _lblChangesAmount.text = [NSString stringWithFormat:@"เงินทอน %@ บาท",strChangesAmount];
        _lblChangesAmount.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _lblChangesAmount.textColor = mDarkGrayColor;

        
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item == 1?345:92;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

- (void)addEditCash:(id)sender
{
    if(![self validateCash])
    {
        return;
    }
    
    
    if([Utility floatValue:_txtPaidAmount.text] == 0 )
    {
        //clear cash info
        receipt.cashReceive = 0;
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
       
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             [vc updatePaidAmount];
         }];
    }
    else
    {
        //update cash info
        receipt.cashReceive = [Utility floatValue:_txtPaidAmount.text];
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

- (void)cancelCash:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateCash
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isEqual:_txtPaidAmount])
    {
        NSString *resultingString = [[Utility removeComma:textField.text] stringByReplacingCharactersInRange: range withString: string];
        
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

-(void)txtPaidAmountDidChange:(UITextField *)textField
{
    NSString *strChangesAmount = [Utility formatDecimal:[self getChangesAmount] withMinFraction:0 andMaxFraction:0];
    _lblChangesAmount.text = [NSString stringWithFormat:@"เงินทอน %@ บาท",strChangesAmount];
}

-(void)totalAmountTap:(id *)sender
{
    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:0 andMaxFraction:2];
    _txtPaidAmount.text = strTotalAmount;
}

-(float)getChangesAmount
{
    return [Utility floatValue:_txtPaidAmount.text] - (totalAmount - receipt.creditCardAmount);
}

- (void)clearAmount:(id)sender
{
    _txtPaidAmount.text = @"";
    [self txtPaidAmountDidChange:nil];
}

- (void)addAmount:(id)sender//:(NSInteger)amount
{
    UIButton *button = sender;
    float paidAmount = [_txtPaidAmount.text isEqualToString:@""]?0:[Utility floatValue:_txtPaidAmount.text];
    paidAmount += [button.titleLabel.text floatValue];
    _txtPaidAmount.text = [Utility removeComma:[Utility formatDecimal:paidAmount]];
    
    [self txtPaidAmountDidChange:nil];
}

- (void)numberTap:(id)sender
{
    UIButton *button = sender;
    UITextRange *selectedTextRange = _txtPaidAmount.selectedTextRange;
    NSUInteger location = (NSUInteger)[_txtPaidAmount offsetFromPosition:_txtPaidAmount.beginningOfDocument toPosition:selectedTextRange.start];
    
    NSUInteger length = (NSUInteger)[_txtPaidAmount offsetFromPosition:selectedTextRange.start toPosition:selectedTextRange.end];
    NSRange selectedRange = NSMakeRange(location, length);
    BOOL shouldChangeCharacter = [_txtPaidAmount.delegate textField:_txtPaidAmount shouldChangeCharactersInRange:selectedRange replacementString:button.titleLabel.text];
    if(shouldChangeCharacter)
    {
        _txtPaidAmount.text = [NSString stringWithFormat:@"%@%@",_txtPaidAmount.text,button.titleLabel.text];
        [self txtPaidAmountDidChange:nil];
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
    [self txtPaidAmountDidChange:nil];
}
@end
