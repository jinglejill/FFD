//
//  MenuTypeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MenuTypeViewController.h"
#import "MenuViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "MenuType.h"
#import "SubMenuType.h"


@interface MenuTypeViewController ()
{
    UITextField *_txtName;
    UIButton *_btnAllowDiscountFlag;
    UIButton *_btnStatusFlag;
    
    MenuType *_firstLoadMenuType;
    MenuType *_editingMenuType;
}

@end

@implementation MenuTypeViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvMenuType;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editMenuType;


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtName])
    {
        _editingMenuType.name = [Utility trimString:textField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];



    
    if(editMenuType)
    {
        _firstLoadMenuType = [editMenuType copy];
        _editingMenuType = [editMenuType copy];        
    }
    else
    {
        _firstLoadMenuType = [[MenuType alloc]init];
        _editingMenuType = [[MenuType alloc]init];
        _firstLoadMenuType.status = 1;
        _editingMenuType.status = 1;
    }
    
    
    tbvMenuType.dataSource = self;
    tbvMenuType.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvMenuType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvMenuType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMenuType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditMenuType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelMenuType:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    

    if(item == 0)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ชื่อหมวดอาหาร:";
        _txtName = cell.txtValue;
        _txtName.delegate = self;
        _txtName.text = _editingMenuType.name;
        
        return cell;
    }
    else if(item == 1 || item == 2)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        switch (item) {
            case 1:
            {
                cell.lblTitle.text = @"ร่วมส่วนลด %:";
                _btnAllowDiscountFlag = cell.btnValue;
                [_btnAllowDiscountFlag addTarget:self action:@selector(toggleAllowDiscount:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnValue.selected = _editingMenuType.allowDiscount;
            }
                break;
            case 2:
            {
                cell.lblTitle.text = @"ใช้งานอยู่:";
                _btnStatusFlag = cell.btnValue;
                [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnValue.selected = _editingMenuType.status;
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

- (void)addEditMenuType:(id)sender
{
    if(![self validateMenuType])
    {
        return;
    }
    
    [_txtName resignFirstResponder];

    
    if(!editMenuType)//add
    {
        
        
        //insert
        MenuType *menuType = [[MenuType alloc]initWithName:_editingMenuType.name allowDiscount:_editingMenuType.allowDiscount color:_editingMenuType.color orderNo:[MenuType getNextOrderNoWithStatus:_editingMenuType.status] status:_editingMenuType.status];
        [MenuType addObject:menuType];
        
        
        
        SubMenuType *subMenuType = [[SubMenuType alloc]initWithMenuTypeID:menuType.menuTypeID name:@"หมวดหมู่ย่อย1" orderNo:1 status:1];
        [SubMenuType addObject:subMenuType];
        
        
        
        [self.homeModel insertItems:dbMenuTypeAndSubMenuType withData:@[menuType,subMenuType] actionScreen:@"Insert menuType and subMenuType in menu screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มหมวดอาหารสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadMenuType editMenuType:_editingMenuType])
        {
            if(!editMenuType.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขหมวดหมู่อาหารได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadMenuType.status != _editingMenuType.status)
            {
                editMenuType.orderNo = [MenuType getNextOrderNoWithStatus:_editingMenuType.status];
            }
            editMenuType.name = _editingMenuType.name;
            editMenuType.allowDiscount = _editingMenuType.allowDiscount;
            editMenuType.status = _editingMenuType.status;
            editMenuType.modifiedUser = [Utility modifiedUser];
            editMenuType.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbMenuType withData:editMenuType actionScreen:@"Edit menuType in menu screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขหมวดอาหารสำเร็จ"];
                [vc loadViewProcess];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelMenuType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateMenuType
{
    if([Utility isStringEmpty:_txtName.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อหมวดอาหาร" firstResponder:_txtName];
        return NO;
    }
    
    return YES;
}

- (void)toggleAllowDiscount:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingMenuType.allowDiscount = button.selected;
    
    
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingMenuType.status = button.selected;
    
    
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
