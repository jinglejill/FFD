//
//  PromotionDateViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 7/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PromotionDateViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "SpecialPriceProgram.h"


@interface PromotionDateViewController ()
{
    UITextField *_txtStartDate;
    UITextField *_txtEndDate;
    UITextField *_txtSpecialPrice;
}
@end

@implementation PromotionDateViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
@synthesize tbvPromotionDate;
@synthesize dtPicker;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize selectedSpecialPriceProgramList;
@synthesize lblDirection;


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
    }
    else if([textField isEqual:_txtEndDate])
    {
        NSString *strStartDate = [Utility formatDate:_txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:_txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            _txtStartDate.text = _txtEndDate.text;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtStartDate] || [textField isEqual:_txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    else if([textField isEqual:_txtSpecialPrice])
    {
        if([Utility floatValue:_txtSpecialPrice.text] == 0)
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

- (void)loadView
{
    [super loadView];
    
    
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    if(edit)
    {
        lblDirection.text = @"ระบุวันเริ่มต้น วันสิ้นสุด และราคาโปรโมชั่น";
    }
    else
    {
        lblDirection.text = @"ระบุวันเริ่มต้นและวันสิ้นสุดอันใหม่";
    }
  
}

- (void)loadViewProcess
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    tbvPromotionDate.dataSource = self;
    tbvPromotionDate.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvPromotionDate registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvPromotionDate.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addPromotionDate:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelPromotionDate:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return edit?3:2;//edit or copy
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
            _txtStartDate = cell.txtValue;
            _txtStartDate.delegate = self;
            _txtStartDate.inputView = dtPicker;
            _txtStartDate.textAlignment = NSTextAlignmentLeft;
            _txtStartDate.text = [Utility dateToString:[Utility setStartOfTheDay:[Utility currentDateTime]] toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 1:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"วันที่สิ้นสุด:";
            _txtEndDate = cell.txtValue;
            _txtEndDate.delegate = self;
            _txtEndDate.inputView = dtPicker;
            _txtEndDate.textAlignment = NSTextAlignmentLeft;
            _txtEndDate.text = [Utility dateToString:[Utility setStartOfTheDay:[Utility currentDateTime]] toFormat:@"d MMM yyyy"];
            
            return cell;
        }
            break;
        case 2:
        {
            CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblTitle.text = @"ราคาโปรโมชั่น:";
            _txtSpecialPrice = cell.txtValue;
            _txtSpecialPrice.placeholder = @"0.00";
            _txtSpecialPrice.keyboardType = UIKeyboardTypeDecimalPad;
            _txtSpecialPrice.text = @"0";
            
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

- (void)addPromotionDate:(id)sender
{
    if(!edit)//copy
    {
        NSMutableArray *copySpecialPriceProgramList = [[NSMutableArray alloc]init];
        for(SpecialPriceProgram *item in selectedSpecialPriceProgramList)
        {
            SpecialPriceProgram *specialPriceProgram = [item copy];
            specialPriceProgram.specialPriceProgramID = [SpecialPriceProgram getNextID];
            specialPriceProgram.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
            specialPriceProgram.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
            [SpecialPriceProgram addObject:specialPriceProgram];
            [copySpecialPriceProgramList addObject:specialPriceProgram];
        }
        [self.homeModel insertItems:dbSpecialPriceProgramList withData:copySpecialPriceProgramList actionScreen:@"insert specialPriceProgramList"];
        
    }
    else//edit
    {
        for(SpecialPriceProgram *item in selectedSpecialPriceProgramList)
        {
            item.startDate = [Utility stringToDate:_txtStartDate.text fromFormat:@"d MMM yyyy"];
            item.endDate = [Utility stringToDate:_txtEndDate.text fromFormat:@"d MMM yyyy"];
            item.specialPrice = [Utility floatValue:_txtSpecialPrice.text];
        }
        [self.homeModel updateItems:dbSpecialPriceProgramList withData:selectedSpecialPriceProgramList actionScreen:@"update specialPriceProgramList"];
    }
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         [vc getDataList];
     }];
    
}

- (void)cancelPromotionDate:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
     {
     }];
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
@end
