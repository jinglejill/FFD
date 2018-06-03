//
//  IngredientAmountViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientAmountViewController.h"
#import "IngredientSetUpViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "MenuIngredient.h"


@interface IngredientAmountViewController ()
{
    UITextField *_txtAmount;

    
    MenuIngredient *_firstLoadMenuIngredient;
    MenuIngredient *_editingMenuIngredient;
}

@end

@implementation IngredientAmountViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";


@synthesize tbvIngredientAmount;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize editMenuIngredient;




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtAmount])
    {
        _editingMenuIngredient.amount = [Utility floatValue:textField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if(editMenuIngredient)
    {
        _firstLoadMenuIngredient = [editMenuIngredient copy];
        _editingMenuIngredient = [editMenuIngredient copy];        
    }
    else
    {
        _firstLoadMenuIngredient = [[MenuIngredient alloc]init];
        _editingMenuIngredient = [[MenuIngredient alloc]init];
        _editingMenuIngredient.menuID = editMenuIngredient.menuID;
        _editingMenuIngredient.ingredientID = editMenuIngredient.ingredientID;
    }
    
    
    tbvIngredientAmount.dataSource = self;
    tbvIngredientAmount.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvIngredientAmount registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvIngredientAmount.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addeditMenuIngredient:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelMenuIngredient:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.lblTitle.text = @"จำนวนหลัก:";
    cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
    _txtAmount = cell.txtValue;
    _txtAmount.delegate = self;
    NSString *strAmount = [Utility formatDecimal:_editingMenuIngredient.amount withMinFraction:0 andMaxFraction:9];
    _txtAmount.text = strAmount;

    
    return cell;
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

- (void)addeditMenuIngredient:(id)sender
{
    if(![self validateMenuIngredient])
    {
        return;
    }
    

    [_txtAmount resignFirstResponder];    
    
    
    //edit
    {
        if([_firstLoadMenuIngredient editMenuIngredient:_editingMenuIngredient])
        {
            if(!editMenuIngredient.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถแก้ไขจำนวนได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
            
            
            editMenuIngredient.amount = _editingMenuIngredient.amount;
            editMenuIngredient.modifiedUser = [Utility modifiedUser];
            editMenuIngredient.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbMenuIngredient withData:editMenuIngredient actionScreen:@"Edit menuIngredient in ingredientSetUp screen"];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [vc showAlert:@"" message:@"แก้ไขจำนวนสำเร็จ"];
                [vc loadViewProcess];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelMenuIngredient:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateMenuIngredient
{

    
    return YES;
}
@end
