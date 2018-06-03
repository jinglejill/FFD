//
//  SubIngredientTypeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SubIngredientTypeViewController.h"
#import "IngredientSetUpViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "SubIngredientType.h"


@interface SubIngredientTypeViewController ()
{
    UITextField *_txtName;
    UIButton *_btnStatusFlag;
    
    SubIngredientType *_firstLoadSubIngredientType;
    SubIngredientType *_editingSubIngredientType;
}

@end

@implementation SubIngredientTypeViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvSubIngredientType;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editIngredientType;
@synthesize editSubIngredientType;



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtName])
    {
        _editingSubIngredientType.name = [Utility trimString:textField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if(editSubIngredientType)
    {
        _firstLoadSubIngredientType = [editSubIngredientType copy];
        _editingSubIngredientType = [editSubIngredientType copy];
    }
    else
    {
        _firstLoadSubIngredientType = [[SubIngredientType alloc]init];
        _editingSubIngredientType = [[SubIngredientType alloc]init];
        _firstLoadSubIngredientType.status = 1;
        _editingSubIngredientType.ingredientTypeID = editIngredientType.ingredientTypeID;
        _editingSubIngredientType.status = 1;
    }
    
    
    tbvSubIngredientType.dataSource = self;
    tbvSubIngredientType.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvSubIngredientType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvSubIngredientType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvSubIngredientType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addeditSubIngredientType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelSubIngredientType:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
        _txtName.text = _editingSubIngredientType.name;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ใช้งานอยู่:";
        _btnStatusFlag = cell.btnValue;
        [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnValue.selected = _editingSubIngredientType.status;
        
        
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

- (void)addeditSubIngredientType:(id)sender
{
    if(![self validateSubIngredientType])
    {
        return;
    }
    
    [_txtName resignFirstResponder];
    
    
    
    if(!editSubIngredientType)//add
    {
        //insert
        SubIngredientType *subIngredientType = [[SubIngredientType alloc]initWithIngredientTypeID:_editingSubIngredientType.ingredientTypeID name:_editingSubIngredientType.name orderNo:[SubIngredientType getNextOrderNoWithStatus:_editingSubIngredientType.status] status:_editingSubIngredientType.status];

        
        [SubIngredientType addObject:subIngredientType];
        [self.homeModel insertItems:dbSubIngredientType withData:subIngredientType actionScreen:@"Insert subIngredientType in ingredientSetUp screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มหมวดหมู่ย่อยสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadSubIngredientType editSubIngredientType:_editingSubIngredientType])
        {
            if(!editSubIngredientType.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขหมวดหมู่ย่อยได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadSubIngredientType.status != _editingSubIngredientType.status)
            {
                editSubIngredientType.orderNo = [SubIngredientType getNextOrderNoWithStatus:_editingSubIngredientType.status];
            }
            editSubIngredientType.name = _editingSubIngredientType.name;
            editSubIngredientType.status = _editingSubIngredientType.status;
            editSubIngredientType.modifiedUser = [Utility modifiedUser];
            editSubIngredientType.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbSubIngredientType withData:editSubIngredientType actionScreen:@"Edit subIngredientType in menu screen"];
            
            
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

- (void)cancelSubIngredientType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateSubIngredientType
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
    _editingSubIngredientType.status = button.selected;
    
    
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
