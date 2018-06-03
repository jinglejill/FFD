//
//  MoneyCheckOpenViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MoneyCheckOpenViewController.h"
#import "Setting.h"
#import "MoneyCheck.h"


@interface MoneyCheckOpenViewController ()

@end

@implementation MoneyCheckOpenViewController
@synthesize tbvMoneyCheckOpen;
@synthesize vwCorrectIncorrectCancel;
@synthesize period;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    
    tbvMoneyCheckOpen.dataSource = self;
    tbvMoneyCheckOpen.delegate = self;
    
    
    
    //    add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"CorrectIncorrectCancelView" owner:self options:nil];
    tbvMoneyCheckOpen.tableFooterView = vwCorrectIncorrectCancel;
    [vwCorrectIncorrectCancel.btnCorrect addTarget:self action:@selector(correct:) forControlEvents:UIControlEventTouchUpInside];
    [vwCorrectIncorrectCancel.btnIncorrect addTarget:self action:@selector(incorrect:) forControlEvents:UIControlEventTouchUpInside];
    [vwCorrectIncorrectCancel.btnCancel addTarget:self action:@selector(cancelValue:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"จำนวนเงินทอนเริ่มต้น %@ บาท",[Utility formatDecimal:cashDrawerInitialAmount withMinFraction:0 andMaxFraction:2]];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    
    
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

- (void)correct:(id)sender
{
    //send email or line
    NSInteger notiOpenCloseShopEmail = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopEmail"] integerValue];
    NSString *strEmailAddress = [Setting getSettingValueWithKeyName:@"openCloseShopEmail"];
    NSString *strPeriod = [NSString stringWithFormat:@"%ld",period];
    
    
    float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    MoneyCheck *moneyCheck = [[MoneyCheck alloc]initWithType:1 method:1 amount:cashDrawerInitialAmount status:1 checkUser:userAccount.username checkDate:[Utility currentDateTime]];
    if(notiOpenCloseShopEmail && ![Utility isStringEmpty:strEmailAddress])
    {
        [self.homeModel insertItems:dbMoneyCheckAndSendMail withData:@[moneyCheck,strPeriod,strEmailAddress] actionScreen:@"insert correct MoneyCheck and sendMail in moneyCheckOpen screen"];
    }
    else
    {
        [self.homeModel insertItems:dbMoneyCheck withData:moneyCheck actionScreen:@"insert correct MoneyCheck in moneyCheckOpen screen"];
    }
    
    
//    NSInteger notiOpenCloseShopLine = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopLine"] integerValue];
}

- (void)incorrect:(id)sender
{
    //send email or line
    NSInteger notiOpenCloseShopEmail = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopEmail"] integerValue];
    NSString *strEmailAddress = [Setting getSettingValueWithKeyName:@"openCloseShopEmail"];
    NSString *strPeriod = [NSString stringWithFormat:@"%ld",period];
    
    
    float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    MoneyCheck *moneyCheck = [[MoneyCheck alloc]initWithType:1 method:1 amount:cashDrawerInitialAmount status:0 checkUser:userAccount.username checkDate:[Utility currentDateTime]];
    if(notiOpenCloseShopEmail && ![Utility isStringEmpty:strEmailAddress])
    {
        [self.homeModel insertItems:dbMoneyCheckAndSendMail withData:@[moneyCheck,strPeriod,strEmailAddress] actionScreen:@"insert incorrect MoneyCheck and sendMail in moneyCheckOpen screen"];
    }
    else
    {
        [self.homeModel insertItems:dbMoneyCheck withData:moneyCheck actionScreen:@"insert incorrect MoneyCheck in moneyCheckOpen screen"];
    }
    
    
    //    NSInteger notiOpenCloseShopLine = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopLine"] integerValue];
}

- (void)cancelValue:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
