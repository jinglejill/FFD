//
//  IngredientTypeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientTypeViewController.h"
#import "IngredientSetUpViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelCheckBox.h"
#import "IngredientType.h"
#import "SubIngredientType.h"

@interface IngredientTypeViewController ()
{
    UITextField *_txtName;
    UIButton *_btnStatusFlag;
    
    IngredientType *_firstLoadIngredientType;
    IngredientType *_editingIngredientType;
}

@end

@implementation IngredientTypeViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelCheckBox = @"CustomTableViewCellLabelCheckBox";


@synthesize tbvIngredientType;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editIngredientType;


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtName])
    {
        _editingIngredientType.name = [Utility trimString:textField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if(editIngredientType)
    {
        _firstLoadIngredientType = [editIngredientType copy];
        _editingIngredientType = [editIngredientType copy]; //this object will change when user adjust and will be compare to _firstLoadIngredientType when tap save button        
    }
    else
    {
        _firstLoadIngredientType = [[IngredientType alloc]init];
        _editingIngredientType = [[IngredientType alloc]init];
        _firstLoadIngredientType.status = 1;// default value when first load
        _editingIngredientType.status = 1;
    }
    
    
    tbvIngredientType.dataSource = self;
    tbvIngredientType.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvIngredientType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCheckBox bundle:nil];
        [tbvIngredientType registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCheckBox];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvIngredientType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addeditIngredientType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelIngredientType:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
        
        
        cell.lblTitle.text = @"ชื่อหมวดส่วนประกอบ:";
        _txtName = cell.txtValue;
        _txtName.delegate = self;
        _txtName.text = _editingIngredientType.name;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabelCheckBox *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCheckBox];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        switch (item) {
            case 1:
            {
                cell.lblTitle.text = @"ใช้งานอยู่:";
                _btnStatusFlag = cell.btnValue;
                [_btnStatusFlag addTarget:self action:@selector(toggleStatus:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnValue.selected = _editingIngredientType.status;
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

- (void)addeditIngredientType:(id)sender
{
    if(![self validateIngredientType])
    {
        return;
    }
    
    [_txtName resignFirstResponder];
    
    
    if(!editIngredientType)//add
    {
        //insert
        IngredientType *ingredientType = [[IngredientType alloc]initWithName:_editingIngredientType.name orderNo:[IngredientType getNextOrderNoWithStatus:_editingIngredientType.status] status:_editingIngredientType.status];
        [IngredientType addObject:ingredientType];
        

        SubIngredientType *subIngredientType = [[SubIngredientType alloc]initWithIngredientTypeID:ingredientType.ingredientTypeID name:@"หมวดหมู่ย่อย1" orderNo:1 status:1];
        [SubIngredientType addObject:subIngredientType];

        
        
        [self.homeModel insertItems:dbIngredientTypeAndSubIngredientType withData:@[ingredientType,subIngredientType] actionScreen:@"Insert ingredientType and subIngredientType in ingredientSetUp screen"];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"เพิ่มหมวดส่วนประกอบสำเร็จ"];
            [vc loadViewProcess];
        }];
    }
    else//edit
    {
        if([_firstLoadIngredientType editIngredientType:_editingIngredientType])
        {
            if(!editIngredientType.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขหมวดหมู่ส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            if(_firstLoadIngredientType.status != _editingIngredientType.status)
            {
                editIngredientType.orderNo = [IngredientType getNextOrderNoWithStatus:_editingIngredientType.status];
            }
            editIngredientType.name = _editingIngredientType.name;
            editIngredientType.status = _editingIngredientType.status;
            editIngredientType.modifiedUser = [Utility modifiedUser];
            editIngredientType.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbIngredientType withData:editIngredientType actionScreen:@"Edit ingredientType in ingredientSetUp screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขหมวดส่วนประกอบสำเร็จ"];
                [vc loadViewProcess];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelIngredientType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateIngredientType
{
    if([Utility isStringEmpty:_txtName.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อหมวดส่วนประกอบ" firstResponder:_txtName];
        return NO;
    }
    
    return YES;
}

- (void)toggleStatus:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _editingIngredientType.status = button.selected;
    
    
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
