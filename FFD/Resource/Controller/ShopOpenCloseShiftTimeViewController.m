//
//  ShopOpenCloseShiftTimeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 30/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ShopOpenCloseShiftTimeViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "Setting.h"


@interface ShopOpenCloseShiftTimeViewController ()
{
    NSString *_strEditingOpenCloseTime;
    NSString *_strFirstLoadOpenCloseTime;
    
    NSString *_strEditingShift1OpenTime;
    NSString *_strEditingShift2OpenTime;
    NSString *_strEditingShift3OpenTime;
    NSString *_strEditingShift1CloseTime;
    NSString *_strEditingShift2CloseTime;
    NSString *_strEditingShift3CloseTime;
    NSString *_strFirstLoadShift1OpenTime;
    NSString *_strFirstLoadShift2OpenTime;
    NSString *_strFirstLoadShift3OpenTime;
    NSString *_strFirstLoadShift1CloseTime;
    NSString *_strFirstLoadShift2CloseTime;
    NSString *_strFirstLoadShift3CloseTime;
}
@end

@implementation ShopOpenCloseShiftTimeViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
@synthesize dtPicker;
@synthesize tbvTime;
@synthesize vwConfirmAndCancel;
@synthesize type;


- (IBAction)datePickerChanged:(id)sender
{
    if(type == 3)
    {
        UITextField *textField2 = (UITextField *)[self.view viewWithTag:2];
        UITextField *textField3 = (UITextField *)[self.view viewWithTag:3];
        UITextField *textField4 = (UITextField *)[self.view viewWithTag:4];
        UITextField *textField5 = (UITextField *)[self.view viewWithTag:5];
        UITextField *textField6 = (UITextField *)[self.view viewWithTag:6];
        UITextField *textField7 = (UITextField *)[self.view viewWithTag:7];
        if([textField2 isFirstResponder])
        {
            textField2.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
        else if([textField3 isFirstResponder])
        {
            textField3.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
        else if([textField4 isFirstResponder])
        {
            textField4.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
        else if([textField5 isFirstResponder])
        {
            textField5.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
        else if([textField6 isFirstResponder])
        {
            textField6.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
        else if([textField7 isFirstResponder])
        {
            textField7.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
    }
    else
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1];
        if([textField isFirstResponder])
        {
            textField.text = [Utility dateToString:dtPicker.date toFormat:@"HH:mm"];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"HH:mm"];
    [dtPicker setDate:datePeriod];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(type == 3)
    {
        switch (textField.tag)
        {
            case 2:
                _strEditingShift1OpenTime = textField.text;
                break;
            case 3:
                _strEditingShift1CloseTime = textField.text;
                break;
            case 4:
                _strEditingShift2OpenTime = textField.text;
                break;
            case 5:
                _strEditingShift2CloseTime = textField.text;
                break;
            case 6:
                _strEditingShift3OpenTime = textField.text;
                break;
            case 7:
                _strEditingShift3CloseTime = textField.text;
                break;
            default:
                break;
        }
    }
    else
    {
        if(textField.tag == 1)
        {
            _strEditingOpenCloseTime = textField.text;
        }
    }
}

-(void)loadView
{
    [super loadView];
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(type == 1)
    {
        _strEditingOpenCloseTime = [Setting getSettingValueWithKeyName:@"openTime"];
        _strFirstLoadOpenCloseTime = _strEditingOpenCloseTime;
    }
    else if(type == 2)
    {
        _strEditingOpenCloseTime = [Setting getSettingValueWithKeyName:@"closeTime"];
        _strFirstLoadOpenCloseTime = _strEditingOpenCloseTime;
    }
    else if(type == 3)
    {
        _strEditingShift1OpenTime = [Setting getSettingValueWithKeyName:@"shift1OpenTime"];
        _strEditingShift2OpenTime = [Setting getSettingValueWithKeyName:@"shift2OpenTime"];
        _strEditingShift3OpenTime = [Setting getSettingValueWithKeyName:@"shift3OpenTime"];
        _strEditingShift1CloseTime = [Setting getSettingValueWithKeyName:@"shift1CloseTime"];
        _strEditingShift2CloseTime = [Setting getSettingValueWithKeyName:@"shift2CloseTime"];
        _strEditingShift3CloseTime = [Setting getSettingValueWithKeyName:@"shift3CloseTime"];
        _strFirstLoadShift1OpenTime = _strEditingShift1OpenTime;
        _strFirstLoadShift2OpenTime = _strEditingShift2OpenTime;
        _strFirstLoadShift3OpenTime = _strEditingShift3OpenTime;
        _strFirstLoadShift1CloseTime = _strEditingShift1CloseTime;
        _strFirstLoadShift2CloseTime = _strEditingShift2CloseTime;
        _strFirstLoadShift3CloseTime = _strEditingShift3CloseTime;
    }
    
    
    
    tbvTime.dataSource = self;
    tbvTime.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvTime registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    
//    add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvTime.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmValue:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelValue:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return type==3?3:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return type==3?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(type == 3)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.text = item == 0?@"เวลาเริ่มงาน:":@"เวลาเลิกร้าน:";
        cell.txtValue.inputView = dtPicker;
        cell.txtValue.delegate = self;
        
        
        if(section == 0 && item == 0)
        {
            cell.txtValue.tag = 2;
            cell.txtValue.text = _strEditingShift1OpenTime;
        }
        else if(section == 0 && item == 1)
        {
            cell.txtValue.tag = 3;
            cell.txtValue.text = _strEditingShift1CloseTime;
        }
        else if(section == 1 && item == 0)
        {
            cell.txtValue.tag = 4;
            cell.txtValue.text = _strEditingShift2OpenTime;
        }
        else if(section == 1 && item == 1)
        {
            cell.txtValue.tag = 5;
            cell.txtValue.text = _strEditingShift2CloseTime;
        }
        else if(section == 2 && item == 0)
        {
            cell.txtValue.tag = 6;
            cell.txtValue.text = _strEditingShift3OpenTime;
        }
        else if(section == 2 && item == 1)
        {
            cell.txtValue.tag = 7;
            cell.txtValue.text = _strEditingShift3CloseTime;
        }
        
        
        return cell;
    }
    else
    {
        if(item == 0)
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = type == 1?@"เวลาเปิดร้าน:":@"เวลาปิดร้าน:";
            cell.txtValue.tag = 1;
            cell.txtValue.inputView = dtPicker;
            cell.txtValue.delegate = self;
            cell.txtValue.text = _strEditingOpenCloseTime;
            
            return cell;
        }
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if(type == 3)
    {
        //label
        NSString *sectionName = [NSString stringWithFormat:@"กะที่ %ld",section+1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:sectionName];
        [view addSubview:label];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(type == 3)
    {
        return 44;
    }
    return 0;
}

- (void)confirmValue:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateTime])
    {
        return;
    }
    
    
    if(type == 3)
    {
        NSMutableArray *settingList = [[NSMutableArray alloc]init];
        if(![_strFirstLoadShift1OpenTime isEqualToString:_strEditingShift1OpenTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift1OpenTime"];
            setting.value = _strEditingShift1OpenTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        if(![_strFirstLoadShift2OpenTime isEqualToString:_strEditingShift2OpenTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift2OpenTime"];
            setting.value = _strEditingShift2OpenTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        if(![_strFirstLoadShift3OpenTime isEqualToString:_strEditingShift3OpenTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift3OpenTime"];
            setting.value = _strEditingShift3OpenTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        if(![_strFirstLoadShift1CloseTime isEqualToString:_strEditingShift1CloseTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift1CloseTime"];
            setting.value = _strEditingShift1CloseTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        if(![_strFirstLoadShift2CloseTime isEqualToString:_strEditingShift2CloseTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift2CloseTime"];
            setting.value = _strEditingShift2CloseTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        if(![_strFirstLoadShift3CloseTime isEqualToString:_strEditingShift3CloseTime])
        {
            Setting *setting = [Setting getSettingWithKeyName:@"shift3CloseTime"];
            setting.value = _strEditingShift3CloseTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [settingList addObject:setting];
        }
        [self.homeModel updateItems:dbSettingList withData:settingList actionScreen:@"update shiftOpenCloseTime in shopOpenCloseShiftTime screen"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if(![_strFirstLoadOpenCloseTime isEqualToString:_strEditingOpenCloseTime])
        {
            NSString *strKeyName = type == 1?@"openTime":@"closeTime";
            Setting *setting = [Setting getSettingWithKeyName:strKeyName];
            setting.value = _strEditingOpenCloseTime;
            setting.modifiedUser = [Utility modifiedUser];
            setting.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update open/CloseTime setting in shopOpenCloseShiftTime screen"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelValue:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateTime
{
//    NSString *strCloseTime = [Setting getSettingValueWithKeyName:@"closeTime"];
//    if([strCloseTime isEqualToString:_strEditingOpenCloseTime])
//    {
//        [self showAlert:@"" message:@"ไม่สามารถเปิดปิดเวลาเดียวกัน"];
//        return NO;
//    }
    return YES;
}
@end
