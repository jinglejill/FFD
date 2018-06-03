//
//  AddPromotionViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "AddPromotionViewController.h"
#import "MenuViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "SpecialPriceProgram.h"



@interface AddPromotionViewController ()
{
    SpecialPriceProgram *_firstLoadSpecialPriceProgram;
    SpecialPriceProgram *_editingSpecialPriceProgram;
    UITextField *_txtStartDate;
    UITextField *_txtEndDate;
    UITextField *_txtMenu;
    UITextField *_txtSpecialPrice;
    NSMutableArray *_selectedMenuList;
}
@end

@implementation AddPromotionViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
@synthesize tbvAddPromotion;
@synthesize dtPicker;
@synthesize vwConfirmAndCancel;
@synthesize editSpecialPriceProgram;

- (IBAction)unwindToAddPromotion:(UIStoryboardSegue *)segue
{
    int i=0;
    NSString *strMenuTitleList = @"";
    MenuViewController *menuViewController = segue.sourceViewController;
    _selectedMenuList = menuViewController.selectedMenuList;
    for(Menu *item in _selectedMenuList)
    {
        if(i == [_selectedMenuList count]-1)
        {
            strMenuTitleList = [NSString stringWithFormat:@"%@%@",strMenuTitleList,item.titleThai];
        }
        else
        {
            strMenuTitleList = [NSString stringWithFormat:@"%@%@,",strMenuTitleList,item.titleThai];
        }
        i++;
    }
    _txtMenu.text = strMenuTitleList;
    if([_selectedMenuList count] > 1)
    {
        _txtSpecialPrice.enabled = NO;
    }
    else
    {
        Menu *menu = _selectedMenuList[0];
        _editingSpecialPriceProgram.menuID = menu.menuID;
        _txtSpecialPrice.enabled = YES;
    }
    
    _editingSpecialPriceProgram.specialPrice = 0;
    _txtSpecialPrice.text = @"0";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtStartDate])
    {
        NSString *strStartDate = [Utility formatDate:_txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:_txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            _txtEndDate.text = _txtStartDate.text;
        }
        _editingSpecialPriceProgram.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
        _editingSpecialPriceProgram.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
    }
    else if([textField isEqual:_txtEndDate])
    {
        NSString *strStartDate = [Utility formatDate:_txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:_txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            _txtStartDate.text = _txtEndDate.text;
        }
        _editingSpecialPriceProgram.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
        _editingSpecialPriceProgram.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
    }    
    else if([textField isEqual:_txtSpecialPrice])
    {
        _editingSpecialPriceProgram.specialPrice = [Utility floatValue:textField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtStartDate] || [textField isEqual:_txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    else if([textField isEqual:_txtMenu])
    {
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"segMenu" sender:self];
    }
    else if([textField isEqual:_txtSpecialPrice])
    {
        if(_editingSpecialPriceProgram.specialPrice == 0)
        {
            textField.text = @"";
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([_txtStartDate isFirstResponder])
    {
        _txtStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    if([_txtEndDate isFirstResponder])
    {
        _txtEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToPromotion" sender:self];
}

- (void)loadView
{
    [super loadView];
    
    

    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    

}

- (void)loadViewProcess
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(editSpecialPriceProgram)
    {
        _firstLoadSpecialPriceProgram = [editSpecialPriceProgram copy];
        _editingSpecialPriceProgram = [editSpecialPriceProgram copy];
    }
    else
    {
        _firstLoadSpecialPriceProgram = [[SpecialPriceProgram alloc]init];
        _firstLoadSpecialPriceProgram.startDate = [Utility setStartOfTheDay:[Utility currentDateTime]];
        _firstLoadSpecialPriceProgram.endDate = [Utility setStartOfTheDay:[Utility currentDateTime]];
        _editingSpecialPriceProgram = [_firstLoadSpecialPriceProgram copy];        
    }
    
    
    tbvAddPromotion.dataSource = self;
    tbvAddPromotion.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvAddPromotion registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvAddPromotion.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditPromotion:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelPromotion:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    
    switch (item)
    {
        case 0:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"วันที่เริ่มต้น:";
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            _txtStartDate = cell.txtValue;
            _txtStartDate.delegate = self;
            _txtStartDate.inputView = dtPicker;
            _txtStartDate.textAlignment = NSTextAlignmentLeft;
            _txtStartDate.text = [Utility dateToString:_editingSpecialPriceProgram.startDate toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 1:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"วันที่สิ้นสุด:";
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            _txtEndDate = cell.txtValue;
            _txtEndDate.delegate = self;
            _txtEndDate.inputView = dtPicker;
            _txtEndDate.textAlignment = NSTextAlignmentLeft;
            _txtEndDate.text = [Utility dateToString:_editingSpecialPriceProgram.endDate toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 2:
        {
            //menu
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Menu *menu = [Menu getMenu:_editingSpecialPriceProgram.menuID];
            cell.lblTitle.text = @"รายการอาหาร:";
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            _txtMenu = cell.txtValue;
            _txtMenu.textAlignment = NSTextAlignmentLeft;
            _txtMenu.text = menu.titleThai;
            _txtMenu.placeholder = @"เลือกรายการอาหาร";
            _txtMenu.delegate = self;
            _txtMenu.tintColor = [UIColor clearColor];
            if(editSpecialPriceProgram)
            {
                _txtMenu.enabled = NO;
            }
            else
            {
                _txtMenu.enabled = YES;
            }
            return cell;
        }
            break;
        case 3:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"ราคาโปรโมชั่น:";
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            _txtSpecialPrice = cell.txtValue;
            _txtSpecialPrice.placeholder = @"0.00";
            _txtSpecialPrice.keyboardType = UIKeyboardTypeDecimalPad;
            _txtSpecialPrice.text = [Utility formatDecimal:_editingSpecialPriceProgram.specialPrice withMinFraction:0 andMaxFraction:2];
            
            _txtSpecialPrice.textAlignment = NSTextAlignmentLeft;
            _txtSpecialPrice.delegate = self;
            
            return cell;
        }
            break;
        default:
            break;
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

- (BOOL)validatePromotion
{
    if([_selectedMenuList count] == 0)
    {
        [self showAlert:@"" message:@"กรุณาเลือกรายการอาหาร" firstResponder:_txtMenu];
        return  NO;
    }

    
    return YES;
}

- (void)addEditPromotion:(id)sender
{
    [self.view endEditing:YES];
    if(![self validatePromotion])
    {
        return;
    }
    
    
    if([_selectedMenuList count] == 1)
    {
        _editingSpecialPriceProgram.modifiedUser = [Utility modifiedUser];
        _editingSpecialPriceProgram.modifiedDate = [Utility currentDateTime];
        
        if(editSpecialPriceProgram)
        {
            editSpecialPriceProgram.startDate = _editingSpecialPriceProgram.startDate;
            editSpecialPriceProgram.endDate = _editingSpecialPriceProgram.endDate;
            editSpecialPriceProgram.menuID = _editingSpecialPriceProgram.menuID;
            editSpecialPriceProgram.specialPrice = _editingSpecialPriceProgram.specialPrice;
            [self.homeModel updateItems:dbSpecialPriceProgram withData:_editingSpecialPriceProgram actionScreen:@"update specialPriceProgram"];
        }
        else
        {
            [SpecialPriceProgram addObject:_editingSpecialPriceProgram];
            [self.homeModel insertItems:dbSpecialPriceProgram withData:_editingSpecialPriceProgram actionScreen:@"insert specialPriceProgram"];
        }
        
        
    }
    else
    {
        NSMutableArray *specialPriceProgramList = [[NSMutableArray alloc]init];
        for(Menu *item in _selectedMenuList)
        {
            SpecialPriceProgram *specialPriceProgram = [_editingSpecialPriceProgram copy];
            specialPriceProgram.specialPriceProgramID = [SpecialPriceProgram getNextID];
            specialPriceProgram.menuID = item.menuID;
            specialPriceProgram.modifiedUser = [Utility modifiedUser];
            specialPriceProgram.modifiedDate = [Utility currentDateTime];
            [SpecialPriceProgram addObject:specialPriceProgram];
            [specialPriceProgramList addObject:specialPriceProgram];
        }
                
        [self.homeModel insertItems:dbSpecialPriceProgramList withData:specialPriceProgramList actionScreen:@"insert specialPriceProgramList"];
    }
    [self performSegueWithIdentifier:@"segUnwindToPromotion" sender:self];
}

- (void)cancelPromotion:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToPromotion" sender:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isEqual:_txtSpecialPrice])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        float holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanFloat: &holder] && [scan isAtEnd];
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segMenu"])
    {
        MenuViewController *vc = segue.destinationViewController;
        vc.selectMenu = YES;
    }
}
@end
