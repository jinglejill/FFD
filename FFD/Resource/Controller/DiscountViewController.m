//
//  DiscountViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "DiscountViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelSegment.h"
#import "Discount.h"
#import "Receipt.h"
#import "RewardProgram.h"
#import "RewardPoint.h"
#import "ReceiptViewController.h"


@interface DiscountViewController ()
{
    Receipt *_editingReceipt;
    UISegmentedControl *_segConDiscountAs;
    NSInteger _selectedItem;
    NSInteger _selectedItemRewardProgram;
}

@end

@implementation DiscountViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelSegment = @"CustomTableViewCellLabelSegment";


@synthesize tbvDiscount;
@synthesize vwConfirmAndCancel;
@synthesize discountList;
@synthesize rewardProgramList;
@synthesize receipt;
@synthesize customerTable;
@synthesize vc;
@synthesize member;


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            _editingReceipt.discountAmount = [Utility floatValue:textField.text];
            if(_editingReceipt.discountAmount == 0)
            {
                UITextField *txtDiscountReason = (UITextField *)[self.view viewWithTag:2];
                txtDiscountReason.text = @"";
            }
        }
           
            break;
        case 2:
            _editingReceipt.discountReason = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            UITextField *txtDiscountReason = (UITextField *)[self.view viewWithTag:2];
            [txtDiscountReason performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.05];
        }
            break;
        case 2:
        {
            [vwConfirmAndCancel.btnConfirm sendActionsForControlEvents: UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
    
    return NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    switch (textField.tag) {
        case 1:
        {
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
                UITableViewCell *cell = [tbvDiscount cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                
                _selectedItem = -1;
            }
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedItemRewardProgram inSection:2];
                UITableViewCell *cell = [tbvDiscount cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                
                _selectedItemRewardProgram = -1;
            }
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    tbvDiscount.contentSize = CGSizeMake(300, 44*[discountList count]+44*2+44*3+58);
}

- (void)loadView
{
    [super loadView];
    _selectedItem = -1;
    _selectedItemRewardProgram = -1;

    
    _editingReceipt = [[Receipt alloc]init];
    _editingReceipt.discountAmount = 0;
    _editingReceipt.discountReason = @"";
    
    
    //discount amount
    if(receipt)
    {
        if(receipt.discountType == 1 || receipt.discountType == 2)
        {
            _editingReceipt.discountAmount = receipt.discountAmount;
        }
    }
    
    //discount reason
    if(receipt)
    {
        _editingReceipt.discountReason = receipt.discountReason;
    }
    
    
    //reward program
    RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:receipt.receiptID status:0];
    if(rewardPoint)
    {
        
        _selectedItemRewardProgram = [RewardProgram getSelectedIndexWithRewardProgramList:rewardProgramList pointSpent:rewardPoint.point discountType:receipt.discountType discountAmount:receipt.discountAmount];
        _editingReceipt.discountAmount = 0;
        _editingReceipt.discountReason = @"ใช้แต้ม";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tbvDiscount.dataSource = self;
    tbvDiscount.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvDiscount registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSegment bundle:nil];
        [tbvDiscount registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelSegment];
    }
    
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvDiscount.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditDiscount:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelDiscount:) forControlEvents:UIControlEventTouchUpInside];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([rewardProgramList count]>0)
    {
        return 3;
    }
    else
    {
        return 2;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rowNo=0;
    if(section == 0)
    {
        rowNo = [discountList count];
    }
    else if(section == 1)
    {
        rowNo = 3;
    }
    else if(section == 2)
    {
        rowNo = [rewardProgramList count];
    }
    
    return rowNo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        
        Discount *discount = discountList[item];
        NSString *strDiscount = @"";
        NSString *strDiscountAmount = [Utility formatDecimal:discount.discountAmount withMinFraction:0 andMaxFraction:0];
        NSString *strRemark = @"";
        if(![Utility isStringEmpty:discount.remark])
        {
            strRemark = [NSString stringWithFormat:@" (%@)",discount.remark];
        }
        if(discount.discountType == 1)
        {
            strDiscount = [NSString stringWithFormat:@"ลด %@ บาท%@",strDiscountAmount,strRemark];
        }
        else
        {
            strDiscount = [NSString stringWithFormat:@"ลด %@ %%%@",strDiscountAmount,strRemark];
        }
        
        cell.textLabel.text = strDiscount;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        
        if(item == _selectedItem)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        return cell;
    }
    else if(section == 1)
    {
        switch (item) {
            case 0:
            {
                CustomTableViewCellLabelSegment *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelSegment];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.lblTitle.text = @"ส่วนลดเป็น:";
                _segConDiscountAs = cell.segConGender;
                [_segConDiscountAs removeAllSegments];
                [_segConDiscountAs insertSegmentWithTitle:@"บาท" atIndex:0 animated:NO];
                [_segConDiscountAs insertSegmentWithTitle:@"%" atIndex:1 animated:NO];
                
                
                if(receipt)
                {
                    if(receipt.discountType == 0 || receipt.discountType == 1)
                    {
                        _segConDiscountAs.selectedSegmentIndex = 0;
                    }
                    else if(receipt.discountType == 2)
                    {
                        _segConDiscountAs.selectedSegmentIndex = 1;
                    }
                }
                else
                {
                    _segConDiscountAs.selectedSegmentIndex = 0;
                }
                
                return cell;
            }
                break;
            case 1:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
                
                
                cell.lblTitle.text = @"จำนวน:";
                cell.txtValue.tag = 1;
                cell.txtValue.delegate = self;
                cell.txtValue.text = [Utility removeComma:[Utility formatDecimal:_editingReceipt.discountAmount]];
                
                
                return cell;
            }
                break;
            case 2:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.txtValue.keyboardType = UIKeyboardTypeDefault;
                
                
                cell.lblTitle.text = @"เหตุผล:";
                cell.txtValue.tag = 2;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _editingReceipt.discountReason;
                cell.txtValue.placeholder = @"ใส่เหตุผล";
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else if(section == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        RewardProgram *rewardProgram = rewardProgramList[item];
        NSString *strPointSpent = [Utility formatDecimal:rewardProgram.pointSpent withMinFraction:0 andMaxFraction:0];
        NSString *strDiscountAmount = [Utility formatDecimal:rewardProgram.discountAmount withMinFraction:0 andMaxFraction:0];
        NSString *strDiscountType = rewardProgram.discountType == 1?@" บาท":@"%";
        NSString *strRewardProgram = [NSString stringWithFormat:@"ใช้ %@ แต้ม แลกรับส่วนลด %@%@",strPointSpent,strDiscountAmount,strDiscountType];
        
        
        cell.textLabel.text = strRewardProgram;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        
        if(item == _selectedItemRewardProgram)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(section == 0)
    {
        Discount *discount = discountList[item];
        
        
        _selectedItem = item;
        _selectedItemRewardProgram = -1;
        _editingReceipt.discountAmount = 0;
        _editingReceipt.discountReason = discount.remark;
        
        
        UITextField *txtDiscountReason = (UITextField *)[self.view viewWithTag:2];
        [txtDiscountReason performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.05];
    }
    else if(section == 2)
    {
        _selectedItemRewardProgram = item;
        _selectedItem = -1;
        _editingReceipt.discountAmount = 0;
        _editingReceipt.discountReason = @"ใช้แต้ม";
    }
    
    
    [tbvDiscount reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"เลือกส่วนลด", @"เลือกส่วนลด");
            break;
        case 1:
            sectionName = NSLocalizedString(@"หรือ ใส่ส่วนลดที่ต้องการ", @"หรือ ใส่ส่วนลดที่ต้องการ");
            break;
        case 2:
            sectionName = NSLocalizedString(@"หรือ ใช้แต้มแลกส่วนลด", @"หรือ ใช้แต้มแลกส่วนลด");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:14];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)addEditDiscount:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateDiscount])
    {
        return;
    }
    
    
    //segue back to receipt vc
    if(_selectedItem != -1)//select preset discount
    {
        
        RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:receipt.receiptID status:0];
        if(rewardPoint)
        {
            [RewardPoint removeObject:rewardPoint];
        }
        
        
        UITextField *txtDiscountReason = (UITextField *)[self.view viewWithTag:2];
        Discount *discount = discountList[_selectedItem];
        receipt.discountType = discount.discountType;
        receipt.discountAmount = discount.discountAmount;
        receipt.discountReason = [Utility trimString:txtDiscountReason.text];
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc updateTotalOrderAndAmount];
            [vc updatePaidAmount];
        }];
        
    }
    else if(_selectedItemRewardProgram != -1)//select rewardprogram
    {
        RewardProgram *rewardProgram = rewardProgramList[_selectedItemRewardProgram];
        receipt.discountType = rewardProgram.discountType;
        receipt.discountAmount = rewardProgram.discountAmount;
        receipt.discountReason = @"ใช้แต้ม";
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        
        
        
        RewardPoint *rewardPoint = [[RewardPoint alloc]initWithMemberID:member.memberID receiptID:receipt.receiptID point:rewardProgram.pointSpent status:0];
        [RewardPoint addObject:rewardPoint];
        
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc updateTotalOrderAndAmount];
            [vc updatePaidAmount];
        }];
    }
    else// input custom discount
    {
        RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:receipt.receiptID status:0];
        if(rewardPoint)
        {
            [RewardPoint removeObject:rewardPoint];
        }
        
        
        receipt.discountType = _editingReceipt.discountAmount == 0?0:_segConDiscountAs.selectedSegmentIndex+1;
        receipt.discountAmount = _editingReceipt.discountAmount;
        receipt.discountReason = _editingReceipt.discountAmount == 0?@"":[Utility trimString:_editingReceipt.discountReason];
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];

        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc updateTotalOrderAndAmount];
            [vc updatePaidAmount];
        }];
    }
}

- (void)cancelDiscount:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateDiscount
{
    //check select discount otherwise input discount amount
    if(_selectedItem != -1)
    {
        return YES;
    }
    else if(_selectedItemRewardProgram != -1)
    {
        NSInteger totalPoint = member?[RewardPoint getTotalPointWithMemberID:member.memberID]:0;
        RewardProgram *rewardProgram = rewardProgramList[_selectedItemRewardProgram];
        
        if(totalPoint < rewardProgram.pointSpent)
        {
            NSString *strWantMorePoint = [Utility formatDecimal:rewardProgram.pointSpent - totalPoint withMinFraction:0 andMaxFraction:0];
            NSString *strMsg = [NSString stringWithFormat:@"แต้มสะสมไม่เพียงพอ ต้องการอีก %@ แต้ม",strWantMorePoint];
            [self showAlert:@"" message:strMsg];
            return NO;
        }
        return YES;
    }
    else if(_editingReceipt.discountAmount == 0)
    {
        [self showAlert:@"" message:@"กรุณาเลือกหรือใส่ส่วนลด"];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 1)
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


- (void)keyboardWillShow:(NSNotification *)notification
{
//        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//        UIEdgeInsets contentInsets;
//        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
//            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
//        } else {
//            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
//        }
//
//        tbvDiscount.contentInset = contentInsets;
//        tbvDiscount.scrollIndicatorInsets = contentInsets;
//            [tbvDiscount scrollToRowAtIndexPath:tbvDiscount.e atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//        tbvDiscount.contentInset = UIEdgeInsetsZero;
//        tbvDiscount.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    
        //    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        //    [UIView animateWithDuration:rate.floatValue animations:^{
        //        self.tableView.contentInset = // insert content inset value here
        //        self.tableView.scrollIndicatorInsets = // insert content inset value here
        //    }];
}

@end
