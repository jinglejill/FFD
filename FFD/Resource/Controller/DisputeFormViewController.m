//
//  DisputeFormViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DisputeFormViewController.h"
#import "CustomTableViewCellLabelText2.h"
#import "CustomTableViewCellLabelTextView2.h"
#import "CustomTableViewHeaderFooterOkCancel.h"
#import "Dispute.h"
#import "DisputeReason.h"
#import "Receipt.h"
#import "Branch.h"



@interface DisputeFormViewController ()
{
    Dispute *_dispute;
    NSMutableArray *_disputeReasonList;
    NSInteger _selectedIndexPicker;
}
@end

@implementation DisputeFormViewController
static NSString * const reuseIdentifierLabelText2 = @"CustomTableViewCellLabelText2";
static NSString * const reuseIdentifierLabelTextView2 = @"CustomTableViewCellLabelTextView2";
static NSString * const reuseIdentifierHeaderFooterOkCancel = @"CustomTableViewHeaderFooterOkCancel";


@synthesize tbvData;
@synthesize pickerVw;
@synthesize receipt;
@synthesize fromType;
@synthesize tbvAction;


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"ใส่เหตุผลในการขอเงินคืน"])
    {
        textView.text = @"";
    }
    
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _dispute.detail = [Utility trimString:textView.text];
    if([textView.text isEqualToString:@""])
    {
        textView.text = @"ใส่เหตุผลในการขอเงินคืน";
        textView.textColor = mPlaceHolder;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            DisputeReason *disputeReason = [DisputeReason getDisputeReasonWithText:textField.text];
            _dispute.disputeReasonID = disputeReason.disputeReasonID;
        }
            break;
        case 2:
        {
            _dispute.refundAmount = [Utility floatValue:textField.text];
        }
            break;
        case 4:
        {
            _dispute.phoneNo = [Utility trimString:textField.text];
        }
            break;
        default:
            break;
    }
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        DisputeReason *disputeReason = _disputeReasonList[_selectedIndexPicker];
        textField.text = disputeReason.text;
        [pickerVw selectRow:_selectedIndexPicker inComponent:0 animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [pickerVw removeFromSuperview];
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;
    
    
    
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    tbvData.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dispute = [[Dispute alloc]init];
    
    
    
    tbvAction.delegate = self;
    tbvAction.dataSource = self;
    tbvAction.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tbvAction.scrollEnabled = NO;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText2 bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText2];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView2 bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelTextView2];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterOkCancel bundle:nil];
        [tbvAction registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterOkCancel];
    }
    
    
    
    [self loadingOverlayView];
    [self.homeModel downloadItems:dbDisputeReasonList withData:@(fromType)];
    
  
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1)
        {
            return 3;
        }
        else if(fromType == 2)
        {
            return 5;
        }
        else if(fromType == 3)
        {
            return 2;
        }
        else if(fromType == 4)
        {
            return 4;
        }
    }
    else
    {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1 || fromType == 3)
        {
            if(item == 0)
            {
                UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                
                
                cell.textLabel.text = @"กรุณากรอกรายละเอียดด้านล่างนี้";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                
                
                return cell;
            }
            else if(item == 1)
            {
                CustomTableViewCellLabelText2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"เหตุผลในการขอเงินคืน";
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.placeholder = @"กรุณาเลือกเหตุผลในการขอเงินคืน";
                cell.txtValue.delegate = self;
                cell.txtValue.inputView = pickerVw;
                
                DisputeReason *disputeReason = [DisputeReason getDisputeReason:_dispute.disputeReasonID];
                cell.txtValue.text = disputeReason.text;
                cell.lblRemark.text = @"";
                
                
                return cell;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"เบอร์โทร.";
                NSString *strRemark = @"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน";
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = 4;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _dispute.phoneNo;
                cell.txtValue.keyboardType = UIKeyboardTypePhonePad;
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                
                return cell;
            }
        }
        else if(fromType == 2 || fromType == 4)
        {
            if(item == 0)
            {
                UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                
                
                cell.textLabel.text = @"กรุณากรอกรายละเอียดด้านล่างนี้";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                
                
                return cell;
            }
            else if(item == 1)
            {
                CustomTableViewCellLabelText2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"เหตุผลในการขอเงินคืน";
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.placeholder = @"กรุณาเลือกเหตุผลในการขอเงินคืน";
                cell.txtValue.delegate = self;
                cell.txtValue.inputView = pickerVw;
                
                DisputeReason *disputeReason = [DisputeReason getDisputeReason:_dispute.disputeReasonID];
                cell.txtValue.text = disputeReason.text;
                cell.lblRemark.text = @"";
                
                
                return cell;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"จำนวนเงิน";
                NSString *strTotalAmount = [Utility formatDecimal:[Receipt getTotalAmount:receipt] withMinFraction:2 andMaxFraction:2];
                NSString *strRemark = [NSString stringWithFormat:@"จำนวนเงิน: THB 0.01 to %@",strTotalAmount];
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.delegate = self;
                cell.txtValue.placeholder = @"THB";
                cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
                cell.txtValue.text = [Utility formatDecimal:_dispute.refundAmount withMinFraction:0 andMaxFraction:2];
                if(_dispute.refundAmount == 0)
                {
                    cell.txtValue.text = @"";
                }
                
                
                cell.lblRemark.text = strRemark;
                
                
                return cell;
            }
            else if(item == 3)
            {
                CustomTableViewCellLabelTextView2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelTextView2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"เหตุผลเพิ่มเติมในการขอเงินคืน";
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txvValue.tag = 3;
                cell.txvValue.delegate = self;
                cell.txvValue.text = _dispute.detail;
                if([cell.txvValue.text isEqualToString:@""])
                {
                    cell.txvValue.text = @"ใส่เหตุผลในการขอเงินคืน";
                    cell.txvValue.textColor = mPlaceHolder;
                }
                else
                {
                    cell.txvValue.textColor = [UIColor blackColor];
                }
                [cell.txvValue.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
                [cell.txvValue.layer setBorderWidth:0.5];
                
                //The rounded corner part, where you specify your view's corner radius:
                cell.txvValue.layer.cornerRadius = 5;
                cell.txvValue.clipsToBounds = YES;
                
                
                
                return cell;
            }
            else if(item == 4)
            {
                CustomTableViewCellLabelText2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = @"เบอร์โทร.";
                NSString *strRemark = @"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน";
                
                
                
                UIFont *font = [UIFont systemFontOfSize:15];
                UIColor *color = mRed;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:15];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _dispute.phoneNo;
                cell.txtValue.keyboardType = UIKeyboardTypePhonePad;
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                
                return cell;
            }
        }
        
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1 || fromType == 3)
        {
            if(item == 0)
            {
                return 44;
            }
            else if(item == 1)
            {
                return 122-8-16-8;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
                NSString *strRemark = @"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินของท่านคืน";
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                return 122-16+cell.lblRemark.frame.size.height-8;
            }
        }
        else if(fromType == 2 || fromType == 4)
        {
            if(item == 0)
            {
                return 44;
            }
            else if(item == 1)
            {
                return 122-8-16-8;
            }
            else if(item == 2)
            {
                return 122-8;
            }
            else if(item == 3)
            {
                return 108+20-8;
            }
            else if(item == 4)
            {
                CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
                NSString *strRemark = @"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินของท่านคืน";
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                return 122-16+cell.lblRemark.frame.size.height-8;
            }
        }
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        CustomTableViewHeaderFooterOkCancel *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterOkCancel];
        
        
        
        [footerView.btnOk addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return footerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        return 8+44+8+44;
    }
    return 0;
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    
    
    _disputeReasonList = items[0];
    [DisputeReason setSharedData:items[0]];
    [tbvData reloadData];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        _selectedIndexPicker = row;
        DisputeReason *disputeReason = _disputeReasonList[row];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
        cell.txtValue.text = disputeReason.text;
        
        
        [cell.txtValue resignFirstResponder];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        return [_disputeReasonList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strText = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText2 *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        DisputeReason *disputeReason = _disputeReasonList[row];
        strText = disputeReason.text;
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

-(void)submit:(id)sender
{
    [self.view endEditing:YES];
    if(![self validate])
    {
        return;
    }
    [self loadingOverlayView];
    
    
    _dispute.receiptID = receipt.receiptID;
    _dispute.type = fromType;
    _dispute.modifiedUser = [Utility modifiedUser];
    _dispute.modifiedDate = [Utility currentDateTime];
    
    Branch *branch = [Branch getBranch:receipt.branchID];
    [self.homeModel insertItems:dbDispute withData:@[_dispute,branch] actionScreen:@"insert dispute"];
}

-(void)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
}

-(void)itemsInserted
{
    [self removeOverlayViews];
    
    
    receipt.status = 8;
    [self showAlert:@"" message:@"คำร้องขอเงินคืนได้ถูกส่งไปแล้ว กรุณารอการยืนยันจากร้านค้า" method:@selector(unwindToReceiptSummary)];
}

-(BOOL)validate
{
    if(fromType == 1)
    {
        {
            UITextField *textField = [self.view viewWithTag:1];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:@"กรุณาเลือกเหตุผลที่ขอเงินคืน"];
                return NO;
            }
        }       
        
        {
            UITextField *textField = [self.view viewWithTag:4];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:@"กรุณาใส่เบอร์โทร"];
                return NO;
            }
        }
    }
    else if(fromType == 2)
    {
        {
            UITextField *textField = [self.view viewWithTag:1];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:@"กรุณาเลือกเหตุผลที่ขอเงินคืน"];
                return NO;
            }
        }
        
        {
            UITextField *textField = [self.view viewWithTag:2];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:@"กรุณาใส่จำนวนเงิน"];
                return NO;
            }
        }
        
        {
            UITextView *textView = [self.view viewWithTag:3];
            if([Utility isStringEmpty:textView.text])
            {
                [self blinkAlertMsg:@"กรุณาใส่เหตุผลเพิ่มเติม"];
                return NO;
            }
        }
        
        {
            UITextField *textField = [self.view viewWithTag:4];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:@"กรุณาใส่เบอร์โทร"];
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)unwindToReceiptSummary
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
}
@end
