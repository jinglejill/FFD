//
//  SubMenuTypeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SubMenuTypeViewController.h"
#import "MenuViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "SubMenuType.h"


@interface SubMenuTypeViewController ()
{
    UITextField *_txtName;
    UIButton *_btnStatusFlag;
    
    SubMenuType *_firstLoadSubMenuType;
    SubMenuType *_editingSubMenuType;
}

@end

@implementation SubMenuTypeViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvSubMenuType;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editMenuType;
@synthesize editSubMenuType;



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtName])
    {
        _editingSubMenuType.name = [Utility trimString:textField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if(editSubMenuType)
    {
        _firstLoadSubMenuType = [editSubMenuType copy];
        _editingSubMenuType = [editSubMenuType copy];        
    }
    else
    {
        _firstLoadSubMenuType = [[SubMenuType alloc]init];
        _editingSubMenuType = [[SubMenuType alloc]init];
        _firstLoadSubMenuType.status = 1;
        _editingSubMenuType.menuTypeID = editMenuType.menuTypeID;
        _editingSubMenuType.status = 1;
    }
    
    
    tbvSubMenuType.dataSource = self;
    tbvSubMenuType.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvSubMenuType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvSubMenuType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvSubMenuType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditSubMenuType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelSubMenuType:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    
    
    if(item == 0)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ชื่อหมวดหมู่ย่อย:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtName = cell.txtValue;
        _txtName.delegate = self;
        _txtName.text = _editingSubMenuType.name;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ใช้งานอยู่:";
        _btnStatusFlag = cell.btnValue;
        [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnValue.selected = _editingSubMenuType.status;
        
        
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

- (void)addEditSubMenuType:(id)sender
{
    if(![self validateSubMenuType])
    {
        return;
    }
    
    [_txtName resignFirstResponder];
    
    
    
    if(!editSubMenuType)//add
    {
        //insert
        SubMenuType *subMenuType = [[SubMenuType alloc]initWithMenuTypeID:_editingSubMenuType.menuTypeID name:_editingSubMenuType.name orderNo:[SubMenuType getNextOrderNoWithStatus:_editingSubMenuType.status] status:_editingSubMenuType.status];
       
        
        
        [SubMenuType addObject:subMenuType];
        [self.homeModel insertItems:dbSubMenuType withData:subMenuType actionScreen:@"Insert subMenuType in menu screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มหมวดหมู่ย่อยสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadSubMenuType editSubMenuType:_editingSubMenuType])
        {
            if(!editSubMenuType.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขหมวดหมู่ย่อยได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadSubMenuType.status != _editingSubMenuType.status)
            {
                editSubMenuType.orderNo = [SubMenuType getNextOrderNoWithStatus:_editingSubMenuType.status];
            }
            editSubMenuType.name = _editingSubMenuType.name;
            editSubMenuType.status = _editingSubMenuType.status;
            editSubMenuType.modifiedUser = [Utility modifiedUser];
            editSubMenuType.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbSubMenuType withData:editSubMenuType actionScreen:@"Edit subMenuType in menu screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขหมวดหมู่ย่อยสำเร็จ"];
                [vc loadViewProcess];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelSubMenuType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateSubMenuType
{
    if([Utility isStringEmpty:_txtName.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่หมวดหมู่ย่อย" firstResponder:_txtName];
        return NO;
    }
    
    return YES;
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingSubMenuType.status = button.selected;
    
    
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
