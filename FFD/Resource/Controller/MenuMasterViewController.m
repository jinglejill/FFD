//
//  MenuMasterViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MenuMasterViewController.h"
#import "MenuViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "Menu.h"
#import "SubMenuType.h"


@interface MenuMasterViewController ()
{
    UITextField *_txtMenuCode;
    UITextField *_txtTitleThai;
    UITextField *_txtPrice;
    UITextField *_txtRemark;
    UIButton *_btnStatusFlag;
    
    Menu *_firstLoadMenu;
    Menu *_editingMenu;
}

@end

@implementation MenuMasterViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvMenuMaster;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editMenu;
@synthesize editMenuType;
@synthesize editSubMenuType;

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtPrice])
    {
        if([textField.text isEqualToString:@"0"])
        {
            textField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtMenuCode])
    {
        _editingMenu.menuCode = [Utility trimString:textField.text];
    }
    else if([textField isEqual:_txtTitleThai])
    {
        _editingMenu.titleThai = [Utility trimString:textField.text];
    }
    else if([textField isEqual:_txtPrice])
    {
        _editingMenu.price = [Utility floatValue:textField.text];
    }
    else if([textField isEqual:_txtRemark])
    {
        _editingMenu.remark = [Utility trimString:textField.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    if(editMenu)
    {
        _firstLoadMenu = [editMenu copy];
        _editingMenu = [editMenu copy];        
    }
    else
    {
        _firstLoadMenu = [[Menu alloc]init];
        _editingMenu = [[Menu alloc]init];
        _firstLoadMenu.status = 1;
        _editingMenu.menuTypeID = editMenuType.menuTypeID;
        _editingMenu.subMenuTypeID = editSubMenuType?editSubMenuType.subMenuTypeID:-1;
        _editingMenu.status = 1;
    }
    
    
    tbvMenuMaster.dataSource = self;
    tbvMenuMaster.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvMenuMaster registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvMenuMaster registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMenuMaster.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditMenu:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    
    
    if(item == 0)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"รหัสอาหาร:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtMenuCode = cell.txtValue;
        _txtMenuCode.delegate = self;
        _txtMenuCode.text = _editingMenu.menuCode;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ชื่ออาหาร:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtTitleThai = cell.txtValue;
        _txtTitleThai.delegate = self;
        _txtTitleThai.text = _editingMenu.titleThai;
        
        return cell;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ราคา:";
        cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
        _txtPrice = cell.txtValue;
        _txtPrice.delegate = self;
        NSString *strPrice = [Utility formatDecimal:_editingMenu.price withMinFraction:0 andMaxFraction:2];
        _txtPrice.text = strPrice;
        
        return cell;
    }
    else if(item == 3)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"หมายเหตุ:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtRemark = cell.txtValue;
        _txtRemark.delegate = self;
        _txtRemark.text = _editingMenu.remark;
        
        return cell;
    }
    else if(item == 4)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ใช้งานอยู่:";
        _btnStatusFlag = cell.btnValue;
        [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnValue.selected = _editingMenu.status;
        
        
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

- (void)addEditMenu:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateMenu])
    {
        return;
    }
    
    
    
    if(!editMenu)//add
    {
        //insert
        Menu *menu = [[Menu alloc]initWithMenuCode:_editingMenu.menuCode titleThai:_editingMenu.titleThai price:_editingMenu.price menuTypeID:_editingMenu.menuTypeID subMenuTypeID:_editingMenu.subMenuTypeID subMenuType2ID:0 subMenuType3ID:0 color:@"0xFFFFFF" orderNo:[Menu getNextOrderNoWithStatus:_editingMenu.status] status:_editingMenu.status remark:_editingMenu.remark];
        
        
        [Menu addObject:menu];
        [self.homeModel insertItems:dbMenu withData:menu actionScreen:@"Insert menu in menu screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มชื่ออาหารสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadMenu editMenu:_editingMenu])
        {
            if(!editMenu.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขชื่ออาหารได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadMenu.status != _editingMenu.status)
            {
                editMenu.orderNo = [Menu getNextOrderNoWithStatus:_editingMenu.status];
            }
            editMenu.titleThai = _editingMenu.titleThai;
            editMenu.price = _editingMenu.price;
            editMenu.remark = _editingMenu.remark;
            editMenu.status = _editingMenu.status;
            editMenu.modifiedUser = [Utility modifiedUser];
            editMenu.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbMenu withData:editMenu actionScreen:@"Edit menu in menu screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขชื่ออาหารสำเร็จ"];
                [vc loadViewProcess];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateMenu
{
    if([Utility isStringEmpty:_txtMenuCode.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่รหัสอาหาร" firstResponder:_txtMenuCode];
        return NO;
    }

    if([Utility isStringEmpty:_txtTitleThai.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่ออาหาร" firstResponder:_txtTitleThai];
        return NO;
    }
    
    return YES;
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingMenu.status = button.selected;
    
    
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}


@end
