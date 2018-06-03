//
//  RewardProgramAddViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 8/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardProgramAddViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellTextAndSegCon.h"
#import "RewardProgram.h"



@interface RewardProgramAddViewController ()
{
    RewardProgram *_firstLoadRewaredProgram;
    RewardProgram *_editingRewaredProgram;
    UITextField *_txtStartDate;
    UITextField *_txtEndDate;
    UITextField *_txtType;
    UITextField *_txtSpent;
    UITextField *_txtGot;
    UISegmentedControl *_segConDiscountType;
}
@end

@implementation RewardProgramAddViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierTextAndSegCon = @"CustomTableViewCellTextAndSegCon";
@synthesize tbvRewardProgramAdd;
@synthesize dtPicker;
@synthesize vwConfirmAndCancel;
@synthesize editRewardProgram;
@synthesize type;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtStartDate])
    {
        NSString *strStartDate = [Utility formatDate:_txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:_txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            _txtEndDate.text = _txtStartDate.text;
        }
        _editingRewaredProgram.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
        _editingRewaredProgram.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
    }
    else if([textField isEqual:_txtEndDate])
    {
        NSString *strStartDate = [Utility formatDate:_txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:_txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            _txtStartDate.text = _txtEndDate.text;
        }
        _editingRewaredProgram.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
        _editingRewaredProgram.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
    }
    else if([textField isEqual:_txtSpent])
    {
        if(type == 1)
        {
            _editingRewaredProgram.salesSpent = [Utility floatValue:textField.text];
        }
        else
        {
            _editingRewaredProgram.pointSpent = [Utility floatValue:textField.text];
        }
    }
    else if([textField isEqual:_txtGot])
    {
        if(type == 1)
        {
            _editingRewaredProgram.receivePoint = [Utility floatValue:textField.text];
        }
        else
        {
            _editingRewaredProgram.discountAmount = [Utility floatValue:textField.text];
        }
    }
}

- (IBAction)segConValueChanged:(id)sender
{
    _editingRewaredProgram.discountType = _segConDiscountType.selectedSegmentIndex == 0?1:2;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtStartDate] || [textField isEqual:_txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    else if([textField isEqual:_txtSpent])
    {
        if(type == 1)
        {
            if(_editingRewaredProgram.salesSpent == 0)
            {
                textField.text = @"";
            }
        }
        else
        {
            if(_editingRewaredProgram.pointSpent == 0)
            {
                textField.text = @"";
            }
        }
    }
    else if([textField isEqual:_txtGot])
    {
        if(type == 1)
        {
            if(_editingRewaredProgram.receivePoint == 0)
            {
                textField.text = @"";
            }
        }
        else
        {
            if(_editingRewaredProgram.discountAmount == 0)
            {
                textField.text = @"";
            }
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([_txtStartDate isFirstResponder])
    {
        _txtStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    if([_txtEndDate isFirstResponder])
    {
        _txtEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToRewardProgram" sender:self];
}

- (void)loadView
{
    [super loadView];
    
    
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
}

- (void)loadViewProcess
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(editRewardProgram)
    {
        _firstLoadRewaredProgram = [editRewardProgram copy];
        _editingRewaredProgram = [editRewardProgram copy];
    }
    else
    {
        _firstLoadRewaredProgram = [[RewardProgram alloc]init];
        _firstLoadRewaredProgram.startDate = [Utility setStartOfTheDay:[Utility currentDateTime]];
        _firstLoadRewaredProgram.endDate = [Utility setStartOfTheDay:[Utility currentDateTime]];
        _firstLoadRewaredProgram.type = type;
        _firstLoadRewaredProgram.discountType = 1;
        _editingRewaredProgram = [_firstLoadRewaredProgram copy];        
    }
    
    
    tbvRewardProgramAdd.dataSource = self;
    tbvRewardProgramAdd.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvRewardProgramAdd registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTextAndSegCon bundle:nil];
        [tbvRewardProgramAdd registerNib:nib forCellReuseIdentifier:reuseIdentifierTextAndSegCon];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvRewardProgramAdd.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditRewardProgram:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelRewardProgram:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    
    switch (item)
    {
        case 0:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"วันที่เริ่มต้น:";
            _txtStartDate = cell.txtValue;
            _txtStartDate.delegate = self;
            _txtStartDate.inputView = dtPicker;
            _txtStartDate.textAlignment = NSTextAlignmentLeft;
            _txtStartDate.text = [Utility dateToString:_editingRewaredProgram.startDate toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 1:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"วันที่สิ้นสุด:";
            _txtEndDate = cell.txtValue;
            _txtEndDate.delegate = self;
            _txtEndDate.inputView = dtPicker;
            _txtEndDate.textAlignment = NSTextAlignmentLeft;
            _txtEndDate.text = [Utility dateToString:_editingRewaredProgram.endDate toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 2:
        {
            //menu
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"ประเภท:";
            
            _txtType = cell.txtValue;
            _txtType.textAlignment = NSTextAlignmentLeft;
            _txtType.text = type == 1?@"สะสมแต้ม":@"ใช้แต้ม";
            _txtType.enabled = NO;
            return cell;
        }
            break;
        case 3:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if(type == 1)
            {
                cell.lblTitle.text = @"ใช้จ่าย(บาท):";
                _txtSpent = cell.txtValue;
                _txtSpent.placeholder = @"0.00";
                _txtSpent.keyboardType = UIKeyboardTypeNumberPad;
                _txtSpent.text = [Utility formatDecimal:_editingRewaredProgram.salesSpent withMinFraction:0 andMaxFraction:0];
                
                _txtSpent.textAlignment = NSTextAlignmentLeft;
                _txtSpent.delegate = self;
            }
            else
            {
                cell.lblTitle.text = @"ใช้แต้ม:";
                _txtSpent = cell.txtValue;
                _txtSpent.placeholder = @"0.00";
                _txtSpent.keyboardType = UIKeyboardTypeNumberPad;
                _txtSpent.text = [Utility formatDecimal:_editingRewaredProgram.pointSpent withMinFraction:0 andMaxFraction:0];
                
                _txtSpent.textAlignment = NSTextAlignmentLeft;
                _txtSpent.delegate = self;
            }
            return cell;
        }
            break;
        case 4:
        {
            CustomTableViewCellTextAndSegCon *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTextAndSegCon];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if(type == 1)
            {
                cell.lblTitle.text = @"ได้รับแต้ม:";
                _txtGot = cell.txtValue;
                _txtGot.placeholder = @"0.00";
                _txtGot.keyboardType = UIKeyboardTypeDecimalPad;
                _txtGot.text = [Utility formatDecimal:_editingRewaredProgram.receivePoint withMinFraction:0 andMaxFraction:0];
                
                _txtGot.textAlignment = NSTextAlignmentLeft;
                _txtGot.delegate = self;
                
                
                _segConDiscountType = cell.segConValue;
                _segConDiscountType.hidden = YES;
            }
            else
            {
                cell.lblTitle.text = @"แลกส่วนลด:";
                _txtGot = cell.txtValue;
                _txtGot.placeholder = @"0.00";
                _txtGot.keyboardType = UIKeyboardTypeDecimalPad;
                _txtGot.text = [Utility formatDecimal:_editingRewaredProgram.discountAmount withMinFraction:0 andMaxFraction:0];
                
                _txtGot.textAlignment = NSTextAlignmentLeft;
                _txtGot.delegate = self;
                
                
                _segConDiscountType = cell.segConValue;
                _segConDiscountType.hidden = NO;
                _segConDiscountType.selectedSegmentIndex = _editingRewaredProgram.discountType == 0 || _editingRewaredProgram.discountType == 1?0:1;
                [_segConDiscountType addTarget:self action:@selector(segConValueChanged:) forControlEvents:UIControlEventValueChanged];
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

- (BOOL)validateRewardProgram
{
    return YES;
}

- (void)addEditRewardProgram:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateRewardProgram])
    {
        return;
    }
    
    
    _editingRewaredProgram.modifiedUser = [Utility modifiedUser];
    _editingRewaredProgram.modifiedDate = [Utility currentDateTime];
    
    if(editRewardProgram)
    {
        if(type == 1)
        {
            editRewardProgram.startDate = _editingRewaredProgram.startDate;
            editRewardProgram.endDate = _editingRewaredProgram.endDate;
            editRewardProgram.salesSpent = _editingRewaredProgram.salesSpent;
            editRewardProgram.receivePoint = _editingRewaredProgram.receivePoint;
        }
        else
        {
            editRewardProgram.startDate = _editingRewaredProgram.startDate;
            editRewardProgram.endDate = _editingRewaredProgram.endDate;
            editRewardProgram.pointSpent = _editingRewaredProgram.pointSpent;
            editRewardProgram.discountType = _editingRewaredProgram.discountType;
            editRewardProgram.discountAmount = _editingRewaredProgram.discountType;
        }
        [self.homeModel updateItems:dbRewardProgram withData:editRewardProgram actionScreen:@"update rewardProgram"];
    }
    else
    {
        [RewardProgram addObject:_editingRewaredProgram];
        [self.homeModel insertItems:dbRewardProgram withData:_editingRewaredProgram actionScreen:@"insert rewardProgram"];
    }
    
    [self performSegueWithIdentifier:@"segUnwindToRewardProgram" sender:self];
}

- (void)cancelRewardProgram:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToRewardProgram" sender:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isEqual:_txtSpent])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        int holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanInt: &holder] && [scan isAtEnd];
    }
    else if([textField isEqual:_txtGot])
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

@end
