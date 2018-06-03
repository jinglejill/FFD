//
//  OrderDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ConfirmDisputeViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel2.h"
#import "CustomTableViewCellButton2.h"
#import "CustomTableViewCellDisputeDetail.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "Dispute.h"
#import "DisputeReason.h"
#import "CustomerTable.h"
#import "QuartzCore/QuartzCore.h"



@interface OrderDetailViewController ()
{
    Branch *_receiptBranch;
    NSInteger _fromType;//1=cancel,2=dispute
    float _accumHeight;
    HomeModel *_homeModelDelivered;
}
@end

@implementation OrderDetailViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel2 = @"CustomTableViewCellLabelLabel2";
static NSString * const reuseIdentifierButton2 = @"CustomTableViewCellButton2";
static NSString * const reuseIdentifierDisputeDetail = @"CustomTableViewCellDisputeDetail";



@synthesize tbvData;
@synthesize receipt;
@synthesize credentialsDb;


-(IBAction)unwindToOrderDetail:(UIStoryboardSegue *)segue
{
    NSIndexPath *indexPathSummary = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellReceiptSummary *cellSummary = [tbvData cellForRowAtIndexPath:indexPathSummary];
    
    
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:credentialsDb.branchID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[orderTakingList count]+2 inSection:0];
    CustomTableViewCellButton2 *cell = [cellSummary.tbvOrderDetail cellForRowAtIndexPath:indexPath];
    cell.btnValue.enabled = YES;
    
//    [self.homeModel downloadItems:dbReceipt withData:receipt];
}

-(void)loadView
{
    [super loadView];
    
    
    _homeModelDelivered = [[HomeModel alloc]init];
    _homeModelDelivered.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel2 bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel2];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton2 bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierButton2];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierDisputeDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierDisputeDetail];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            NSInteger numberOfRow = 3;//total,vat,net total---->(1,0,0),(1,1,0),(1,0,1),(1,1,1)
            if(receipt.discountValue > 0)
            {
                numberOfRow += 2 ;
            }
            if(receipt.serviceChargePercent > 0)
            {
                numberOfRow += 1;
            }
            
            return numberOfRow;
        }
        else if(section == 2)
        {
            if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
            {
                return 2;
            }
            else if(receipt.status == 7)
            {
                return 1+3;
            }
            else if(receipt.status == 8)
            {
                return 1+4;
            }
            else if(receipt.status == 9 || receipt.status == 10 || receipt.status == 11)
            {
                return 1+1;
            }
            else if(receipt.status == 12)
            {
                return 1+1;
            }
            else if(receipt.status == 13)
            {
                return 1+4;
            }
            else if(receipt.status == 14)
            {
                return 1+1;
            }
        }
    }
    else
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        
        return [orderTakingList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
//            Branch *branch = [Branch getBranch:receipt.branchID];
            cell.lblReceiptNo.text = [NSString stringWithFormat:@"Order no. #%@", receipt.receiptNoID];
            cell.lblReceiptDate.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yy HH:mm"];
            cell.lblBranchName.text = [NSString stringWithFormat:@"Table: %@",customerTable.tableName];
            cell.lblBranchName.textColor = mGreen;
            
            
            
            {
                UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
                [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
            }
            
            
            cell.tbvOrderDetail.scrollEnabled = NO;
            cell.tbvOrderDetail.delegate = self;
            cell.tbvOrderDetail.dataSource = self;
            cell.tbvOrderDetail.tag = receipt.receiptID;
            [cell.tbvOrderDetail reloadData];
            if(receipt.status == 2)
            {
                cell.btnOrderItAgain.hidden = NO;
                [cell.btnOrderItAgain addTarget:self action:@selector(printIndividualReceipt:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnOrderItAgain setTitle:@"Print" forState:UIControlStateNormal];
            }
            else if(receipt.status == 5)
            {
                cell.btnOrderItAgain.hidden = NO;
                [cell.btnOrderItAgain addTarget:self action:@selector(changeToDeliveredStatus:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnOrderItAgain setTitle:@"Delivered" forState:UIControlStateNormal];
            }
            else
            {
                cell.btnOrderItAgain.hidden = YES;
            }
            
            
            return cell;
        }
        else if(section == 1)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:credentialsDb.branchID];
            
            
            if(receipt.discountValue == 0 && receipt.serviceChargePercent == 0)//3 rows
            {
                switch (item)
                {
                    case 0:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return  cell;
                    }
                        break;
                    case 1:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 2:
                    {
                        //net total
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        
                        return cell;
                    }
                        break;
                }
            }
            else if(receipt.discountValue > 0 && receipt.serviceChargePercent == 0)//5 rows
            {
                switch (item)
                {
                    case 0:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return  cell;
                    }
                        break;
                    case 1:
                    {
                        //discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                        strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                        
                        cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return cell;
                    }
                        break;
                    case 2:
                    {
                        //after discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = @"ยอดรวม";
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        return  cell;
                    }
                        break;
                    case 3:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 4:
                    {
                        //net total
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        
                        
                        return cell;
                    }
                        break;
                }
            }
            else if(receipt.discountValue == 0 && receipt.serviceChargePercent > 0)//4 rows
            {
                switch (item)
                {
                    case 0:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return  cell;
                    }
                        break;
                    case 1:
                    {
                        //service charge
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                        strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = strServiceChargePercent;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 2:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 3:
                    {
                        //net total
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        
                        
                        return cell;
                    }
                        break;
                }
            }
            else if(receipt.discountValue > 0 && receipt.serviceChargePercent > 0)//6 rows
            {
                switch (item)
                {
                    case 0:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return  cell;
                    }
                        break;
                    case 1:
                    {
                        //discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                        strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                        
                        
                        cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        
                        return cell;
                    }
                        break;
                    case 2:
                    {
                        //after discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = @"ยอดรวม";
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                        cell.lblAmount.textColor = mGreen;
                        
                        return  cell;
                    }
                        break;
                    case 3:
                    {
                        //service charge
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                        strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = strServiceChargePercent;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 4:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.font = [UIFont systemFontOfSize:15];
                        cell.lblAmount.textColor = [UIColor darkGrayColor];
                        
                        
                        return cell;
                    }
                        break;
                    case 5:
                    {
                        //net total
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        
                        
                        return cell;
                    }
                        break;
                }
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                CustomTableViewCellLabelLabel2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strStatus = [Receipt getStrStatus:receipt];
                UIColor *color = [Receipt getStatusColor:receipt];
                
                
                
                UIFont *font = [UIFont systemFontOfSize:14];
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:strStatus attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:14];
                UIColor *color2 = [UIColor darkGrayColor];
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Status: " attributes:attribute2];
                
                
                [attrStringStatusLabel appendAttributedString:attrStringStatus];
                cell.lblValue.attributedText = attrStringStatusLabel;
                cell.lblText.text = @"";
                
                
                
                return cell;
            }
            else
            {
                if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        

                        if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
                        {
                            cell.btnValue.hidden = NO;
                            [cell.btnValue setTitle:@"Claim & refund" forState:UIControlStateNormal];
                            cell.btnValue.backgroundColor = mRed;
                            [cell.btnValue addTarget:self action:@selector(moneyRefund:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 7)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.lblRemark.textColor = mRed;
                        cell.lblRemark.text = @"ลูกค้าของคุณต้องการยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า";
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        float totalAmount = [Receipt getTotalAmount:receipt];
                        NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                        
                        
                        cell.lblReasonDetailHeight.constant = 0;
                        cell.lblReasonDetailTop.constant = 0;
                        
                        
                        cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Confirm" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = mGreen;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(confirmCancel:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Cancel" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(cancelCancel:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 8)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.lblRemark.textColor = mRed;
                        cell.lblRemark.text = @"ลูกค้าของคุณ Open dispute ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate";
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                        
                        
                        cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Confirm" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = mGreen;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(confirmDispute:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Negotiate" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = mRed;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(negotiate:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                    else if(item == 4)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Cancel" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(cancelDispute:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 9)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    cell.lblRemark.textColor = mRed;
                    cell.lblRemark.text = @"คำร้องขอยกเลิกออเดอร์เสร็จสิ้น";
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 10)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    cell.lblRemark.textColor = mRed;
                    cell.lblRemark.text = @"กระบวนการ Open dispute เสร็จสิ้น";
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                    
                    
                    cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 11)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    cell.lblRemark.textColor = mRed;
                    cell.lblRemark.text = @"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม.";
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSInteger statusBeforeLast = [Receipt getStateBeforeLast:receipt];
                    if(statusBeforeLast == 8)
                    {
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                        
                        
                        cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    }
                    else if(statusBeforeLast == 12 || statusBeforeLast == 13)
                    {
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                        
                        
                        cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                    }
                    
                    return cell;
                }
                else if(receipt.status == 12)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    cell.lblRemark.textColor = mRed;
                    cell.lblRemark.text = @"Open dispute ได้มีการแก้ไขตามด้านล่าง โปรดรอการยืนยันจากลูกค้าสักครู่";
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                    
                    
                    cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
                else if(receipt.status == 13)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.lblRemark.textColor = mRed;
                        cell.lblRemark.text = @"หลังจากคุยกับเจ้าหน้าที่ Jummum แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate";
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                        
                        
                        cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                        
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Confirm" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = mGreen;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(confirmNegotiate:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Negotiate" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = mRed;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(negotiate:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                    else if(item == 4)
                    {
                        CustomTableViewCellButton2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton2];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Cancel" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 14)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    cell.lblRemark.textColor = mRed;
                    cell.lblRemark.text = @"กระบวนการ Open dispute ดำเนินการเสร็จสิ้นแล้ว";
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                    
                    
                    cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
            }
        }
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        if(item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[item];
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                UIFont *font = [UIFont systemFontOfSize:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                               attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
            CGRect frame = cell.lblMenuName.frame;
            frame.size.width = menuNameLabelSize.width;
            frame.size.height = menuNameLabelSize.height;
            cell.lblMenuNameHeight.constant = menuNameLabelSize.height;
            cell.lblMenuName.frame = frame;
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            
            
            
            CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
            CGRect frame2 = cell.lblNote.frame;
            frame2.size.width = noteLabelSize.width;
            frame2.size.height = noteLabelSize.height;
            cell.lblNoteHeight.constant = noteLabelSize.height;
            cell.lblNote.frame = frame2;
            
            
            
            
            
            float totalAmount = orderTaking.specialPrice * orderTaking.quantity;
            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
            cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
            
            
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            //load order มาโชว์
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:credentialsDb.branchID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            float sumHeight = 0;
            for(int i=0; i<[orderTakingList count]; i++)
            {
                OrderTaking *orderTaking = orderTakingList[i];
                Menu *menu = [Menu getMenu:orderTaking.menuID];
                
                NSString *strMenuName;
                if(orderTaking.takeAway)
                {
                    strMenuName = [NSString stringWithFormat:@"ใส่ห่อ %@",menu.titleThai];
                }
                else
                {
                    strMenuName = menu.titleThai;
                }
                
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    UIFont *font = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont systemFontOfSize:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                
                
                
                UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
                UIFont *fontNote = [UIFont systemFontOfSize:11.0];
                
                
                
                CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
                CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
                noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
                
                
                float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
                sumHeight += height;
            }
            
            return sumHeight+83;
        }
        else if(section == 1)
        {
            return 26;
        }
        else if(section == 2)
        {
            if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
            {
                return item == 0?34:44+8;
            }
            else if(receipt.status == 7 || receipt.status == 8)
            {
                switch (item)
                {
                    case 0:
                        return 34;
                        break;
                    case 1:
                    {
                        if(receipt.status == 7)
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.text = @"ลูกค้าของคุณต้องการยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.text = disputeReason.text;
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            float totalAmount = [Receipt getTotalAmount:receipt];
                            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            
                            cell.lblReasonDetailTop.constant = 0;
                            cell.lblReasonDetailHeight.constant = 0;
                            
                            
                            
                            cell.lblPhoneNo.text = [Utility setPhoneNoFormat:dispute.phoneNo];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            return 11+cell.lblRemarkHeight.constant+8+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+8+cell.lblPhoneNoHeight.constant+11;
                        }
                        else if(receipt.status == 8)
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"ลูกค้าของคุณ Open dispute ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+8+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+8+cell.lblPhoneNoHeight.constant+11;
                        }
                    }
                        
                        break;
                    case 2:
                        return 44+8;
                        break;
                    case 3:
                        return 44+8;
                        break;
                    case 4:
                        return 44+8;
                        break;
                    default:
                        break;
                }
            }
            else if(receipt.status == 9 || receipt.status == 10 || receipt.status == 11 || receipt.status == 12 || receipt.status == 13 || receipt.status == 14)
            {
                if(item == 0)
                {
                    return 34;
                }
                else if(item == 1)
                {
                    switch (receipt.status)
                    {
                        case 9:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"คำร้องขอยกเลิกออเดอร์เสร็จสิ้น";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            float totalAmount = [Receipt getTotalAmount:receipt];
                            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetailHeight.constant = 0;
                            cell.lblReasonDetailTop.constant = 0;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 10:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"กระบวนการ Open dispute เสร็จสิ้น";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 11:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม.";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 12:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"Open dispute ได้มีการแก้ไขตามด้านล่าง โปรดรอการยืนยันจากลูกค้าสักครู่";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 13:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"หลังจากคุยกับเจ้าหน้าที่ Jummum แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                            cell.lblReasonTop.constant = 0;
                            cell.lblReasonHeight.constant = 0;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNoTop.constant = 0;
                            cell.lblPhoneNoHeight.constant = 0;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 14:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            cell.lblRemark.textColor = mRed;
                            cell.lblRemark.text = @"กระบวนการ Open dispute ดำเนินการเสร็จสิ้นแล้ว";
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:@"เหตุผล: " text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:@"จำนวนเงินที่ขอคืน: " text:strTotalAmount];
                            
                            
                            cell.lblReasonDetail.attributedText = [self setAttributedString:@"รายละเอียดเหตุผล: " text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNo.attributedText = [self setAttributedString:@"เบอร์โทรติดต่อ: " text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        default:
                        break;
                    }
                }
                else
                {
                    return 44+8;
                }
            }
        }
    }
    else
    {
        
        //load order มาโชว์
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        if(indexPath.item < [orderTakingList count])
        {
            OrderTaking *orderTaking = orderTakingList[indexPath.item];
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            
            NSString *strMenuName;
            if(orderTaking.takeAway)
            {
                strMenuName = [NSString stringWithFormat:@"ใส่ห่อ %@",menu.titleThai];
            }
            else
            {
                strMenuName = menu.titleThai;
            }
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                UIFont *font = [UIFont systemFontOfSize:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
                
                
                UIFont *font2 = [UIFont systemFontOfSize:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            
            
            
            UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
            UIFont *fontNote = [UIFont systemFontOfSize:11.0];
            
            
            
            CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
            CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
            
            
            float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
            return height;
        }
    }
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if([tableView isEqual:tbvData])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        if(indexPath.item == [orderTakingList count]+1)
        {
            cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        }
        else
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//-(void)itemsDownloaded:(NSArray *)items
//{
//    if(self.homeModel.propCurrentDB == dbReceipt)
//    {
//        NSMutableArray *receiptList = items[0];
//        if([receiptList count]>0)
//        {
//            [Receipt updateStatusList:receiptList];
//            [tbvData reloadData];
//        }
//    }
//}

//-(void)orderItAgain:(id)sender
//{
//    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
//    [OrderTaking setCurrentOrderTakingList:orderTakingList];
//
//
//    _receiptBranch = [Branch getBranch:receipt.branchID];
//    [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
//}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segConfirmDispute"])
    {
        ConfirmDisputeViewController *vc = segue.destinationViewController;
        vc.fromType = _fromType;
        vc.receipt = receipt;
    }
}

//-(void)disputeOrder:(id)sender
//{
//    _fromType = 2;
//    [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
//}
//
//-(void)cancelOrder:(id)sender
//{
//    //    dont forget to uncomment
//    _fromType = 1;
//    [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
//}

-(void)moneyRefund:(id)sender
{
    
    _fromType = receipt.status == 2?3:4;
    [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"UIModalPresentationNone");
    return UIModalPresentationNone;
}

-(void)confirmCancel:(id)sender
{
    receipt.status = 9;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    
    [self loadingOverlayView];
    [self.homeModel updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
}

-(void)cancelCancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)confirmDispute:(id)sender
{
    receipt.status = 10;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    
    [self loadingOverlayView];
    [self.homeModel updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
    
}

-(void)confirmNegotiate:(id)sender
{
    receipt.status = 14;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    
    [self loadingOverlayView];
    [self.homeModel updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
}

-(void)negotiate:(id)sender
{
    receipt.status = 11;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    
    [self loadingOverlayView];
    [self.homeModel updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
}

-(void)cancelDispute:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)itemsUpdated
{
    [self removeOverlayViews];
    [tbvData reloadData];
    if(receipt.status == 6)
    {
        
    }
    else if(receipt.status == 11)
    {
        [self showAlert:@"สำเร็จ" message:@"คุณส่งคำร้องขอแก้ไขจำนวนเงินที่จะ refund สำเร็จ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
    }
    else if(receipt.status == 9 || receipt.status == 10)
    {
        [self showAlert:@"สำเร็จ" message:@"ลูกค้าของคุณจะได้รับเงินคืนภายใน 48 ชม."];
    }
}

-(void)printIndividualReceipt:(id)sender
{
//    UIButton *btnPrint = sender;
//    Receipt *receipt = _receiptList[btnPrint.tag];
    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
    [receiptList addObject:receipt];
    [self printReceiptKitchenBill:receiptList];
//    [self printReceipt:receiptList];
    
}

-(void)changeToDeliveredStatus:(id)sender
{
    receipt.status = 6;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    
    
    [_homeModelDelivered updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
}
-(void)reloadTableView
{
    [tbvData reloadData];
}
@end
