//
//  AddressViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "AddressViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelTextView.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "Address.h"


@interface AddressViewController ()
{
    NSInteger _secNum;
    Address *_firstLoadAddress;
    Address *_editingAdddress;
}

@end

@implementation AddressViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelTextView = @"CustomTableViewCellLabelTextView";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvAddress;
@synthesize vwConfirmAndCancel;
@synthesize memberID;
@synthesize vc;
@synthesize editAddress;
@synthesize firstAddressFlag;
@synthesize addressList;

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        //street
        _editingAdddress.street = [Utility trimString:textView.text];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            _editingAdddress.postCode = [Utility trimString:textField.text];
            break;
        case 2:
            _editingAdddress.country = [Utility trimString:textField.text];
            break;
        case 3:
            _editingAdddress.deliveryCustomerName = [Utility trimString:textField.text];
            break;
        case 4:
            _editingAdddress.deliveryPhoneNo = [Utility trimString:textField.text];
            break;
        case 5:
            _editingAdddress.taxCustomerName = [Utility trimString:textField.text];
            break;
        case 6:
            _editingAdddress.taxPhoneNo = [Utility trimString:textField.text];
            break;
        case 7:
            _editingAdddress.taxID = [Utility trimString:textField.text];
            break;
        default:
            break;
    }

    
    NSLog(@"textfield:%@\n%@\n%@\n%@\n%@\n%@\n%@\n",_editingAdddress.postCode,_editingAdddress.country,_editingAdddress.deliveryCustomerName,_editingAdddress.deliveryPhoneNo,_editingAdddress.taxCustomerName,_editingAdddress.taxPhoneNo,_editingAdddress.taxID);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if(editAddress)
    {
        _firstLoadAddress = [editAddress copy];
        _editingAdddress = [editAddress copy]; //this object will change when user adjust and will be compare to _firstLoadIngredientType when tap save button
        
        
        _secNum = 1+_editingAdddress.deliveryAddressFlag+_editingAdddress.taxAddressFlag;
    }
    else
    {
        _firstLoadAddress = [[Address alloc]init];
        _editingAdddress = [[Address alloc]init];
        
        // default value when first load set here
        _firstLoadAddress.keyAddressFlag = firstAddressFlag;
        _editingAdddress.keyAddressFlag = firstAddressFlag;
        
        
        _secNum = 1;
    }
    [self adjustView];

 
    
    tbvAddress.dataSource = self;
    tbvAddress.delegate = self;
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvAddress registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView bundle:nil];
        [tbvAddress registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelTextView];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvAddress registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvAddress.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditAddress:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rowNum = 0;
    if(section == 0)
    {
        rowNum = 6;
    }
    else if(section == 1 && _editingAdddress.deliveryAddressFlag)
    {
        rowNum = 2;
    }
    else if(section == 1 && !_editingAdddress.deliveryAddressFlag)
    {
        rowNum = 3;
    }
    else if(section == 2)
    {
        rowNum = 3;
    }
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(section == 0)
    {
        if(item == 0)
        {
            CustomTableViewCellLabelTextView *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelTextView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"ที่อยู่:";
            cell.tag = 0;
            cell.txtVwValue.delegate = self;
            cell.txtVwValue.text = _editingAdddress.street;
            
            
            return cell;
        }
        else if(item == 1 || item == 2)
        {
            switch (item)
            {
                case 1:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"รหัสไปรษณีย์:";
                    cell.txtValue.tag = 1;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.postCode;
                    
                    return cell;
                }
                    break;
                case 2:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"ประเทศ:";
                    cell.txtValue.tag = 2;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.country;
                    
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
        else if(item == 3 || item == 4 || item == 5)
        {
            CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            switch (item) {
                case 3:
                {
                    cell.lblTitle.text = @"ที่อยู่หลัก:";
                    [cell.btnValue addTarget:self action:@selector(toggleAddress:) forControlEvents:UIControlEventTouchUpInside];
                    cell.btnValue.tag = 8;
                    cell.backgroundColor = mLightBlueColor;
                    cell.btnValue.selected = _editingAdddress.keyAddressFlag;
                }
                    break;
                case 4:
                {
                    cell.lblTitle.text = @"ที่อยู่จัดส่ง:";
                    [cell.btnValue addTarget:self action:@selector(toggleAddress:) forControlEvents:UIControlEventTouchUpInside];
                    cell.btnValue.tag = 9;
                    cell.backgroundColor = mLightBlueColor;
                    cell.btnValue.selected = _editingAdddress.deliveryAddressFlag;
                }
                    break;
                case 5:
                {
                    cell.lblTitle.text = @"ที่อยู่ออกใบกำกับภาษี:";
                    [cell.btnValue addTarget:self action:@selector(toggleAddress:) forControlEvents:UIControlEventTouchUpInside];
                    cell.btnValue.tag = 10;
                    cell.backgroundColor = mLightBlueColor;
                    cell.btnValue.selected = _editingAdddress.taxAddressFlag;
                }
                    break;
                default:
                    break;
            }
            
            
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
    }
    else if(section == 1)
    {
        if(_editingAdddress.deliveryAddressFlag)
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            switch (item) {
                case 0:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"ชื่อ:";
                    cell.txtValue.tag = 3;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.deliveryCustomerName;
                    
                    return cell;
                }
                    break;
                case 1:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"เบอร์โทร.:";
                    cell.txtValue.tag = 4;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.deliveryPhoneNo;
                    
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
                switch (item) {
                case 0:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"ชื่อ:";
                    cell.txtValue.tag = 5;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.taxCustomerName;
                    
                    return cell;
                }
                    break;
                case 1:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    cell.lblTitle.text = @"เบอร์โทร.:";
                    cell.txtValue.tag = 6;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.taxPhoneNo;
                    
                    return cell;
                }
                    break;
                case 2:
                {
                    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.lblTitle.text = @"เลขประจำตัวผู้เสียภาษี:";
                    cell.txtValue.tag = 7;
                    cell.txtValue.delegate = self;
                    cell.txtValue.text = _editingAdddress.taxID;
                    
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
    }
    else if(section == 2)
    {
        switch (item) {
            case 0:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.lblTitle.text = @"ชื่อ:";
                cell.txtValue.tag = 5;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _editingAdddress.taxCustomerName;
                
                return cell;
            }
                break;
            case 1:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lblTitle.text = @"เบอร์โทร.:";
                cell.txtValue.tag = 6;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _editingAdddress.taxPhoneNo;
                
                return cell;
            }
                break;
            case 2:
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lblTitle.text = @"เลขประจำตัวผู้เสียภาษี:";
                cell.txtValue.tag = 7;
                cell.txtValue.delegate = self;
                cell.txtValue.text = _editingAdddress.taxID;
                
                return cell;
            }
                break;
            default:
                break;
        }
    }

    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    return section == 0 && item == 0?89:44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    if(section == 1 && _editingAdddress.deliveryAddressFlag)
    {
        sectionName = NSLocalizedString(@"ชื่อจัดส่ง", @"ชื่อจัดส่ง");
    }
    else if(section == 1 && !_editingAdddress.deliveryAddressFlag)
    {
        sectionName = NSLocalizedString(@"ชื่อออกใบกำกับภาษี", @"ชื่อออกใบกำกับภาษี");
    }
    else if(section == 2)
    {
        sectionName = NSLocalizedString(@"ชื่อออกใบกำกับภาษี", @"ชื่อออกใบกำกับภาษี");
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
    float headerHeight = 0;
    if(section == 1 || section == 2)
    {
        headerHeight = 44;
    }
    return headerHeight;
}

- (void)addEditAddress:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateAddress])
    {
        return;
    }
    
    
    if(!editAddress)//add
    {
        if(_editingAdddress.keyAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.keyAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        if(_editingAdddress.deliveryAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.deliveryAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        if(_editingAdddress.taxAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.taxAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        
        
        
        NSMutableSet *updateSet = [[NSMutableSet alloc]init];
        if(_editingAdddress.keyAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.keyAddressFlag)
                {
                    item.keyAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        
        if(_editingAdddress.deliveryAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.deliveryAddressFlag)
                {
                    item.deliveryAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        
        if(_editingAdddress.taxAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(item.taxAddressFlag)
                {
                    item.taxAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        
        NSMutableArray *updateList = [[updateSet allObjects] mutableCopy];
        [self.homeModel updateItems:dbAddressList withData:updateList actionScreen:@"update other address key address flag and delivery address flag in address screen"];
   
        
        //insert
        Address *address = [[Address alloc]initWithMemberID:memberID street:_editingAdddress.street postCode:_editingAdddress.postCode country:_editingAdddress.country keyAddressFlag:_editingAdddress.keyAddressFlag deliveryAddressFlag:_editingAdddress.deliveryAddressFlag taxAddressFlag:_editingAdddress.taxAddressFlag deliveryCustomerName:_editingAdddress.deliveryCustomerName deliveryPhoneNo:_editingAdddress.deliveryPhoneNo taxCustomerName:_editingAdddress.taxCustomerName taxPhoneNo:_editingAdddress.taxPhoneNo taxID:_editingAdddress.taxID];
        [Address addObject:address];
        [self.homeModel insertItems:dbAddress withData:address actionScreen:@"Insert address in receipt screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มที่อยู่สำเร็จ"];
            [(ReceiptViewController *)vc reloadMemberDetail];
        }];
    }
    else//edit
    {
        if(_editingAdddress.keyAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.keyAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        if(_editingAdddress.deliveryAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.deliveryAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        if(_editingAdddress.taxAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.taxAddressFlag)
                {
                    if(!item.idInserted)
                    {
                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถเพิ่มที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                        return;
                    }
                }
            }
        }
        
        
        NSMutableSet *updateSet = [[NSMutableSet alloc]init];
        if(_editingAdddress.keyAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.keyAddressFlag)
                {
                    item.keyAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        
        if(_editingAdddress.deliveryAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.deliveryAddressFlag)
                {
                    item.deliveryAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        
        if(_editingAdddress.taxAddressFlag)
        {
            for(Address *item in addressList)
            {
                if(![item isEqual:editAddress] && item.taxAddressFlag)
                {
                    item.taxAddressFlag = 0;
                    item.modifiedUser = [Utility modifiedUser];
                    item.modifiedDate = [Utility currentDateTime];
                    [updateSet addObject:item];
                }
            }
        }
        NSMutableArray *updateList = [[updateSet allObjects] mutableCopy];
        [self.homeModel updateItems:dbAddressList withData:updateList actionScreen:@"update other address key address flag and delivery address flag in address screen"];
        
        


        if([_firstLoadAddress editAddress:_editingAdddress])
        {
            if(!editAddress.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขที่อยู่ได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }


            editAddress.street = _editingAdddress.street;
            editAddress.postCode = _editingAdddress.postCode;
            editAddress.country = _editingAdddress.country;
            editAddress.keyAddressFlag = _editingAdddress.keyAddressFlag;
            editAddress.deliveryAddressFlag = _editingAdddress.deliveryAddressFlag;
            editAddress.taxAddressFlag = _editingAdddress.taxAddressFlag;
            editAddress.deliveryCustomerName = _editingAdddress.deliveryCustomerName;
            editAddress.deliveryPhoneNo = _editingAdddress.deliveryPhoneNo;
            editAddress.taxCustomerName = _editingAdddress.taxCustomerName;
            editAddress.taxPhoneNo = _editingAdddress.taxPhoneNo;
            editAddress.taxID = _editingAdddress.taxID;
            editAddress.modifiedUser = [Utility modifiedUser];
            editAddress.modifiedDate = [Utility currentDateTime];
            
            
            
            [self.homeModel updateItems:dbAddress withData:editAddress actionScreen:@"Edit address in receipt screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขที่อยู่สำเร็จ"];
                [(ReceiptViewController *)vc reloadMemberDetail];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelAddress:(id)sender
{    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateAddress
{
    //require phone on
    if([Utility isStringEmpty:_editingAdddress.street])
    {
        UITextView *tv = (UITextView *)[self.view viewWithTag:0];
        [self showAlert:@"" message:@"กรุณาใส่ที่อยู่" firstResponder:tv];
        return NO;
    }
    if(_editingAdddress.deliveryAddressFlag)
    {
        if([Utility isStringEmpty:_editingAdddress.deliveryCustomerName])
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:3];
            [self showAlert:@"" message:@"กรุณาใส่ชื่อสำหรับที่อยู่จัดส่ง" firstResponder:textField];
            return NO;
        }
        if([Utility isStringEmpty:_editingAdddress.deliveryPhoneNo])
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:4];
            [self showAlert:@"" message:@"กรุณาใส่เบอร์โทรสำหรับที่อยู่จัดส่ง" firstResponder:textField];
            return NO;
        }
    }
    if(_editingAdddress.taxAddressFlag)
    {
        if([Utility isStringEmpty:_editingAdddress.taxCustomerName])
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:5];
            [self showAlert:@"" message:@"กรุณาใส่ชื่อสำหรับที่อยู่ออกใบกำกับภาษี" firstResponder:textField];
            return NO;
        }
        if([Utility isStringEmpty:_editingAdddress.taxPhoneNo])
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:6];
            [self showAlert:@"" message:@"กรุณาใส่เบอร์โทรสำหรับที่อยู่ออกใบกำกับภาษี" firstResponder:textField];;
            return NO;
        }
        if([Utility isStringEmpty:_editingAdddress.taxID])
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:7];
            [self showAlert:@"" message:@"กรุณาใส่เลขประจำตัวผู้เสียภาษีภาษี" firstResponder:textField];
            return NO;
        }
    }
    
    return YES;
}

- (void)toggleAddress:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    
    switch (button.tag) {
        case 8:
            _editingAdddress.keyAddressFlag = button.selected;
            break;
        case 9:
        {
            _editingAdddress.deliveryAddressFlag = button.selected;
            _editingAdddress.deliveryCustomerName = @"";
            _editingAdddress.deliveryPhoneNo = @"";
        }
            
            break;
        case 10:
        {
            _editingAdddress.taxAddressFlag = button.selected;
            _editingAdddress.taxCustomerName = @"";
            _editingAdddress.taxPhoneNo = @"";
            _editingAdddress.taxID = @"";
        }
        
            break;
        default:
            break;
    }

    NSLog(@"address selected:%d",button.selected);
    
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
    [self adjustView];
}

- (void)adjustView
{
    float height = 89+44*5+58;//89+44*5+44+44*2+44+44*3+58;
    if(_editingAdddress.deliveryAddressFlag)
    {
        height += 44+44*2;
    }
    if(_editingAdddress.taxAddressFlag)
    {
        height += +44+44*3;
    }
    
    CGSize size = self.preferredContentSize;
    size.height = height;
    self.preferredContentSize = size;
    [UIView animateWithDuration:0.25 animations:^{
        [self.presentationController.containerView setNeedsLayout];
        [self.presentationController.containerView layoutIfNeeded];
    }];
    

    if(_editingAdddress.deliveryAddressFlag && _editingAdddress.taxAddressFlag)
    {
        _secNum = 3;
    }
    else if(!_editingAdddress.deliveryAddressFlag && !_editingAdddress.taxAddressFlag)
    {
        _secNum = 1;
    }
    else
    {
        _secNum = 2;
    }
    [tbvAddress reloadData];
    
}
@end
