//
//  MoneyCheckCloseViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MoneyCheckCloseViewController.h"
#import "CustomTableViewCellLabelCorrectIncorrect.h"
#import "Setting.h"
#import "MoneyCheck.h"
#import "Receipt.h"


@interface MoneyCheckCloseViewController ()
{
    NSInteger _cashDrawerInitialAmount;
    NSInteger _methodCash;
    NSInteger _methodCredit;
    NSInteger _methodTransfer;
    NSInteger _methodEWallet;
}
@end

@implementation MoneyCheckCloseViewController
static NSString * const reuseIdentifierLabelCorrectIncorrect = @"CustomTableViewCellLabelCorrectIncorrect";


@synthesize tbvMoneyCheckClose;
@synthesize vwConfirmAndCancel;
@synthesize period;
@synthesize type;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    tbvMoneyCheckClose.dataSource = self;
    tbvMoneyCheckClose.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelCorrectIncorrect bundle:nil];
        [tbvMoneyCheckClose registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelCorrectIncorrect];
    }
    
    
    //    add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMoneyCheckClose.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    return type==0?5:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    CustomTableViewCellLabelCorrectIncorrect *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelCorrectIncorrect];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (item) {
        case 0:
        {
            float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
            cell.lblText.text = [NSString stringWithFormat:@"จำนวนเงินทอนสิ้นกะ %@ บาท",[Utility formatDecimal:cashDrawerInitialAmount withMinFraction:0 andMaxFraction:2]];
            cell.btnCorrect.tag = 1;
            cell.btnIncorrect.tag = 2;
            [cell.btnCorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIncorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 1:
        {
            float cash = [Receipt getAllCashAmountWithReceiptDate:[Utility currentDateTime]];
            cell.lblText.text = [NSString stringWithFormat:@"ยอดเงินสด %@ บาท",[Utility formatDecimal:cash withMinFraction:0 andMaxFraction:2]];
            cell.btnCorrect.tag = 3;
            cell.btnIncorrect.tag = 4;
            [cell.btnCorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIncorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 2:
        {
            float credit = [Receipt getAllCreditAmountWithReceiptDate:[Utility currentDateTime]];
            cell.lblText.text = [NSString stringWithFormat:@"ยอดบัตรเครดิต %@ บาท",[Utility formatDecimal:credit withMinFraction:0 andMaxFraction:2]];
            cell.btnCorrect.tag = 5;
            cell.btnIncorrect.tag = 6;
            [cell.btnCorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIncorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 3:
        {
            float transfer = [Receipt getAllTransferAmountWithReceiptDate:[Utility currentDateTime]];
            cell.lblText.text = [NSString stringWithFormat:@"ยอดโอนเงิน %@ บาท",[Utility formatDecimal:transfer withMinFraction:0 andMaxFraction:2]];
            cell.btnCorrect.tag = 7;
            cell.btnIncorrect.tag = 8;
            [cell.btnCorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIncorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 4:
        {
            float eWallet = 0;//[Receipt getAllEWalletAmountWithReceiptDate:[Utility currentDateTime]];
            cell.lblText.text = [NSString stringWithFormat:@"ยอด E-Wallet %@ บาท",[Utility formatDecimal:eWallet withMinFraction:0 andMaxFraction:2]];
            cell.btnCorrect.tag = 9;
            cell.btnIncorrect.tag = 10;
            [cell.btnCorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIncorrect addTarget:self action:@selector(correctIncorrect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        default:
            break;
    }
    
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

- (void)correctIncorrect:(id)sender
{
    UIButton *button = sender;
    button.selected = button.selected?button.selected:!button.selected;
    switch (button.tag)
    {
        case 1:
        {
            UIButton *btnIncorrect = [self.view viewWithTag:2];
            btnIncorrect.selected = !button.selected;
            _cashDrawerInitialAmount = !btnIncorrect.selected;
        }
            break;
        case 2:
        {
            UIButton *btnCorrect = [self.view viewWithTag:1];
            btnCorrect.selected = !button.selected;
            _cashDrawerInitialAmount = btnCorrect.selected;
        }
            break;
        case 3:
        {
            UIButton *btnIncorrect = [self.view viewWithTag:4];
            btnIncorrect.selected = !button.selected;
            _methodCash = !btnIncorrect.selected;
        }
            break;
        case 4:
        {
            UIButton *btnCorrect = [self.view viewWithTag:3];
            btnCorrect.selected = !button.selected;
            _methodCash = btnCorrect.selected;
        }
            break;
        case 5:
        {
            UIButton *btnIncorrect = [self.view viewWithTag:6];
            btnIncorrect.selected = !button.selected;
            _methodCredit = !btnIncorrect.selected;
        }
            break;
        case 6:
        {
            UIButton *btnCorrect = [self.view viewWithTag:5];
            btnCorrect.selected = !button.selected;
            _methodCredit = btnCorrect.selected;
        }
            break;
        case 7:
        {
            UIButton *btnIncorrect = [self.view viewWithTag:8];
            btnIncorrect.selected = !button.selected;
            _methodTransfer = !btnIncorrect.selected;
        }
            break;
        case 8:
        {
            UIButton *btnCorrect = [self.view viewWithTag:7];
            btnCorrect.selected = !button.selected;
            _methodTransfer = btnCorrect.selected;
        }
            break;
        case 9:
        {
            UIButton *btnIncorrect = [self.view viewWithTag:10];
            btnIncorrect.selected = !button.selected;
            _methodTransfer = !btnIncorrect.selected;
        }
            break;
        case 10:
        {
            UIButton *btnCorrect = [self.view viewWithTag:9];
            btnCorrect.selected = !button.selected;
            _methodEWallet = btnCorrect.selected;
        }
            break;
        default:
            break;
    }
}

- (void)confirm:(id)sender
{
    //send email or line
    NSInteger notiOpenCloseShopEmail = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopEmail"] integerValue];
    NSString *strEmailAddress = [Setting getSettingValueWithKeyName:@"openCloseShopEmail"];
    NSString *strPeriod = [NSString stringWithFormat:@"%ld",period];
    
    
    float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
    float cash = [Receipt getAllCashAmountWithReceiptDate:[Utility currentDateTime]];
    float credit = [Receipt getAllCreditAmountWithReceiptDate:[Utility currentDateTime]];
    float transfer = [Receipt getAllTransferAmountWithReceiptDate:[Utility currentDateTime]];
    float eWallet = 0;//[Receipt getAllCreditAmountWithReceiptDate:[Utility currentDateTime]];
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    
    NSMutableArray *moneyCheckList = [[NSMutableArray alloc]init];
    MoneyCheck *moneyCheck = [[MoneyCheck alloc]initWithType:type method:1 amount:cashDrawerInitialAmount status:_cashDrawerInitialAmount checkUser:userAccount.username checkDate:[Utility currentDateTime]];
    [MoneyCheck addObject:moneyCheck];
    [moneyCheckList addObject:moneyCheck];
    
    if(type == 0)
    {
        MoneyCheck *moneyCheck2 = [[MoneyCheck alloc]initWithType:type method:2 amount:cash status:_methodCash checkUser:userAccount.username checkDate:[Utility currentDateTime]];
        [MoneyCheck addObject:moneyCheck];
        [moneyCheckList addObject:moneyCheck2];
        
        MoneyCheck *moneyCheck3 = [[MoneyCheck alloc]initWithType:type method:3 amount:credit status:_methodCredit checkUser:userAccount.username checkDate:[Utility currentDateTime]];
        [MoneyCheck addObject:moneyCheck];
        [moneyCheckList addObject:moneyCheck3];
        
        MoneyCheck *moneyCheck4 = [[MoneyCheck alloc]initWithType:type method:4 amount:transfer status:_methodTransfer checkUser:userAccount.username checkDate:[Utility currentDateTime]];
        [MoneyCheck addObject:moneyCheck];
        [moneyCheckList addObject:moneyCheck4];
        
        MoneyCheck *moneyCheck5 = [[MoneyCheck alloc]initWithType:type method:5 amount:eWallet status:_methodEWallet checkUser:userAccount.username checkDate:[Utility currentDateTime]];
        [MoneyCheck addObject:moneyCheck];
        [moneyCheckList addObject:moneyCheck5];
    }    
    
    if(notiOpenCloseShopEmail && ![Utility isStringEmpty:strEmailAddress])
    {
        [self.homeModel insertItems:dbMoneyCheckListAndSendMail withData:@[moneyCheckList,strPeriod,strEmailAddress] actionScreen:@"insertList correct/incorrect MoneyCheck in moneyCheckOpen screen"];
    }
    else
    {
        [self.homeModel insertItems:dbMoneyCheckList withData:moneyCheckList actionScreen:@"insertList correct/incorrect MoneyCheck in moneyCheckOpen screen"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    NSInteger notiOpenCloseShopLine = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopLine"] integerValue];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
