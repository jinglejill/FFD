//
//  IngredientViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientViewController.h"
#import "IngredientSetUpViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "Ingredient.h"
#import "SubIngredientType.h"


@interface IngredientViewController ()
{
    UITextField *_txtName;
    UITextField *_txtUom;
    UITextField *_txtUomSmall;
    UITextField *_txtSmallAmount;
    UIButton *_btnStatusFlag;
    
    Ingredient *_firstLoadIngredient;
    Ingredient *_editingIngredient;
}

@end

@implementation IngredientViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvIngredient;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editIngredient;
@synthesize editIngredientType;
@synthesize editSubIngredientType;


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtName])
    {
        _editingIngredient.name = [Utility trimString:textField.text];
    }
    else if([textField isEqual:_txtUom])
    {
        _editingIngredient.uom = [Utility trimString:textField.text];
    }
    else if([textField isEqual:_txtUomSmall])
    {
        _editingIngredient.uomSmall = [Utility trimString:textField.text];
    }
    else if([textField isEqual:_txtSmallAmount])
    {
        _editingIngredient.smallAmount = [Utility floatValue:textField.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    if(editIngredient)
    {
        _firstLoadIngredient = [editIngredient copy];
        _editingIngredient = [editIngredient copy];
    }
    else
    {
        _firstLoadIngredient = [[Ingredient alloc]init];
        _editingIngredient = [[Ingredient alloc]init];
        _firstLoadIngredient.status = 1;
        _firstLoadIngredient.smallAmount = 1;
        _editingIngredient.ingredientTypeID = editIngredientType.ingredientTypeID;
        _editingIngredient.subIngredientTypeID = editSubIngredientType?editSubIngredientType.subIngredientTypeID:-1;
        _editingIngredient.status = 1;
        _editingIngredient.smallAmount = 1;
    }
    
    
    tbvIngredient.dataSource = self;
    tbvIngredient.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvIngredient registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvIngredient registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvIngredient.tableFooterView = vwConfirmAndCancel;
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
        
        
        cell.lblTitle.text = @"ชื่อส่วนประกอบ:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtName = cell.txtValue;
        _txtName.delegate = self;
        _txtName.text = _editingIngredient.name;
        
        return cell;
    }
    if(item == 1)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"หน่วยใหญ่:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtUom = cell.txtValue;
        _txtUom.delegate = self;
        _txtUom.text = _editingIngredient.uom;
        
        return cell;
    }
    if(item == 2)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"หน่วยย่อย:";
        cell.txtValue.keyboardType = UIKeyboardTypeDefault;
        _txtUomSmall = cell.txtValue;
        _txtUomSmall.delegate = self;
        _txtUomSmall.text = _editingIngredient.uomSmall;
        
        return cell;
    }
    if(item == 3)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"สัดส่วน หน่วยย่อย/ใหญ่:";
        [cell.lblTitle sizeToFit];
        cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
        _txtSmallAmount = cell.txtValue;
        _txtSmallAmount.delegate = self;
        NSString *strSmallAmount = [Utility formatDecimal:_editingIngredient.smallAmount withMinFraction:0 andMaxFraction:9];
        _txtSmallAmount.text = strSmallAmount;
        
        return cell;
    }
    else if(item == 4)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"ใช้งานอยู่:";
        _btnStatusFlag = cell.btnValue;
        [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnValue.selected = _editingIngredient.status;
        
        
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
    if(![self validateIngredient])
    {
        return;
    }
    
    [_txtName resignFirstResponder];
    [_txtUom resignFirstResponder];
    [_txtUomSmall resignFirstResponder];
    [_txtSmallAmount resignFirstResponder];
    
    
    
    if(!editIngredient)//add
    {
        //insert
        Ingredient *ingredient = [[Ingredient alloc]initWithIngredientTypeID:_editingIngredient.ingredientTypeID subIngredientTypeID:_editingIngredient.subIngredientTypeID name:_editingIngredient.name uom:_editingIngredient.uom uomSmall:_editingIngredient.uomSmall smallAmount:_editingIngredient.smallAmount orderNo:[Ingredient getNextOrderNoWithStatus:_editingIngredient.status] status:_editingIngredient.status];
        
        
        [Ingredient addObject:ingredient];
        [self.homeModel insertItems:dbIngredient withData:ingredient actionScreen:@"Insert ingredient in ingredientSetUp screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มชื่อส่วนประกอบสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadIngredient editIngredient:_editingIngredient])
        {
            if(!editIngredient.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขชื่อส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadIngredient.status != _editingIngredient.status)
            {
                editIngredient.orderNo = [Ingredient getNextOrderNoWithStatus:_editingIngredient.status];
            }
            editIngredient.name = _editingIngredient.name;
            editIngredient.uom = _editingIngredient.uom;
            editIngredient.uomSmall = _editingIngredient.uomSmall;
            editIngredient.smallAmount = _editingIngredient.smallAmount;
            editIngredient.status = _editingIngredient.status;
            editIngredient.modifiedUser = [Utility modifiedUser];
            editIngredient.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbIngredient withData:editIngredient actionScreen:@"Edit ingredient in ingredientSetUp screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขชื่อส่วนประกอบสำเร็จ"];
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

- (BOOL)validateIngredient
{
    if([Utility isStringEmpty:_txtName.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อส่วนประกอบ" firstResponder:_txtName];
        return NO;
    }
    else if([Utility isStringEmpty:_txtUom.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อหน่วยหลัก" firstResponder:_txtUom];
        return NO;
    }
    else if([Utility isStringEmpty:_txtUomSmall.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อหน่วยย่อย" firstResponder:_txtUomSmall];
        return NO;
    }
    else if([_txtSmallAmount.text floatValue] == 0)
    {
        [self showAlert:@"" message:@"ไม่สามารถใส่ค่า 0 ได้" firstResponder:_txtSmallAmount];
        return NO;
    }
    
    return YES;
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingIngredient.status = button.selected;
    
    
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
