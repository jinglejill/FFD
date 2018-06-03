//
//  DiscountAddViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DiscountAddViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellTextAndSegCon.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "Discount.h"



@interface DiscountAddViewController ()
{
    Discount *_firstLoadDiscount;
    Discount *_editingDiscount;
    UITextField *_txtDiscountAmount;
    UISegmentedControl *_segConDiscountType;
    UITextField *_txtRemark;
    UIButton *_btnStatus;
    
}
@end

@implementation DiscountAddViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierTextAndSegCon = @"CustomTableViewCellTextAndSegCon";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";
@synthesize tbvDiscountAdd;
@synthesize vwConfirmAndCancel;
@synthesize editDiscount;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtDiscountAmount])
    {
        _editingDiscount.discountAmount = [Utility floatValue:textField.text];
    }
    else if([textField isEqual:_txtRemark])
    {
        _editingDiscount.remark = [Utility trimString:textField.text];
    }
}

- (IBAction)segConValueChanged:(id)sender
{
    _editingDiscount.discountType = _segConDiscountType.selectedSegmentIndex == 0?1:2;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtDiscountAmount])
    {
        if(_editingDiscount.discountAmount == 0)
        {
            textField.text = @"";
        }
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToDiscountList" sender:self];
}

- (void)loadView
{
    [super loadView];
}

- (void)loadViewProcess
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(editDiscount)
    {
        _firstLoadDiscount = [editDiscount copy];
        _editingDiscount = [editDiscount copy];
    }
    else
    {
        _firstLoadDiscount = [[Discount alloc]init];
        _firstLoadDiscount.discountType = 1;
        _firstLoadDiscount.status = 1;
        _editingDiscount = [_firstLoadDiscount copy];
    }
    
    
    tbvDiscountAdd.dataSource = self;
    tbvDiscountAdd.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvDiscountAdd registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTextAndSegCon bundle:nil];
        [tbvDiscountAdd registerNib:nib forCellReuseIdentifier:reuseIdentifierTextAndSegCon];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvDiscountAdd registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvDiscountAdd.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditDiscount:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelDiscount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
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
    
    
    switch (item)
    {
        case 0:
        {
            CustomTableViewCellTextAndSegCon *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTextAndSegCon];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lblTitle.text = @"ส่วนลด:";
            _txtDiscountAmount = cell.txtValue;
            _txtDiscountAmount.placeholder = @"0.00";
            _txtDiscountAmount.keyboardType = UIKeyboardTypeDecimalPad;
            _txtDiscountAmount.text = [Utility formatDecimal:_editingDiscount.discountAmount withMinFraction:0 andMaxFraction:2];
            
            _txtDiscountAmount.textAlignment = NSTextAlignmentLeft;
            _txtDiscountAmount.delegate = self;
            
            
            _segConDiscountType = cell.segConValue;
            _segConDiscountType.hidden = NO;
            _segConDiscountType.selectedSegmentIndex = _editingDiscount.discountType == 0 || _editingDiscount.discountType == 1?0:1;
            [_segConDiscountType addTarget:self action:@selector(segConValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 1:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"หมายเหตุ:";
            _txtRemark = cell.txtValue;
            _txtRemark.delegate = self;
            _txtRemark.textAlignment = NSTextAlignmentLeft;
            _txtRemark.text = _editingDiscount.remark;
            
            return cell;
        }
            break;
        case 2:
        {
            CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"ใช้งานอยู่:";
            _btnStatus = cell.btnValue;
            [_btnStatus addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnValue.selected = _editingDiscount.status;
            
            
            if(cell.btnValue.selected)
            {
                [cell.btnValue setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
            }
            else
            {
                [cell.btnValue setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
            }
            
            return cell;
        }
            break;
        
        default:
            break;
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

- (BOOL)validateDiscount
{
    return YES;
}

- (void)addEditDiscount:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateDiscount])
    {
        return;
    }
    
    
    _editingDiscount.modifiedUser = [Utility modifiedUser];
    _editingDiscount.modifiedDate = [Utility currentDateTime];
    
    if(editDiscount)
    {
        editDiscount.discountType = _editingDiscount.discountType;
        editDiscount.discountAmount = _editingDiscount.discountAmount;
        editDiscount.remark = _editingDiscount.remark;
        editDiscount.status = _editingDiscount.status;
        [self.homeModel updateItems:dbDiscount withData:editDiscount actionScreen:@"update discount in discountAdd screen"];
    }
    else
    {
        [Discount addObject:_editingDiscount];
        [self.homeModel insertItems:dbDiscount withData:_editingDiscount actionScreen:@"insert discount in discountAdd screen"];
    }
    
    [self performSegueWithIdentifier:@"segUnwindToDiscountList" sender:self];
}

- (void)cancelDiscount:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToDiscountList" sender:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:_txtDiscountAmount])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        float holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanFloat: &holder] && [scan isAtEnd];
    }
    
    return YES;
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingDiscount.status = button.selected;
    
    
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}

@end
