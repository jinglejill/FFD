//
//  CustomerKitchenViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 15/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomerKitchenViewController.h"
#import "OrderDetailViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel2.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "MenuType.h"
#import "CustomerTable.h"
#import "Setting.h"
#import "Printer.h"
#import "ReceiptPrint.h"
#import "InvoiceComposer.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"


@interface CustomerKitchenViewController ()
{
    NSMutableArray *_receiptList;
    BOOL _lastItemReachedDelivery;
    BOOL _lastItemReachedOthers;
    
    NSMutableArray *_webViewList;
    UIView *_backgroundView;
    NSMutableArray *_arrOfHtmlContentList;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
    

    float _contentOffsetYNew;
    float _contentOffsetYPrinted;
    NSIndexPath *_indexPathNew;
    NSIndexPath *_indexPathPrinted;
    NSIndexPath *_indexPathDelivery;
    NSIndexPath *_indexPathAction;
    NSIndexPath *_indexPathOthers;
    
    
    NSMutableArray *_statusCellArray;
    NSMutableArray *_firmwareInfoCellArray;
    
    
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    HomeModel *_homeModelDelivered;
}
@end

@implementation CustomerKitchenViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel2 = @"CustomTableViewCellLabelLabel2";



@synthesize btnAction;
@synthesize btnSelect;
@synthesize btnBack;
@synthesize tbvData;
@synthesize credentialsDb;
@synthesize segConPrintStatus;
@synthesize imgPrinterStaus;
@synthesize btnBadge;


-(IBAction)unwindToCustomerKitchen:(UIStoryboardSegue *)segue
{
    [self setReceiptList];
    [tbvData reloadData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)loadView
{
    [super loadView];
    
   
    _homeModelDelivered = [[HomeModel alloc]init];
    _homeModelDelivered.delegate = self;
    
    
    
    //use webview for calculate pdf page size
//    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
//    _backgroundView.backgroundColor = [UIColor whiteColor];
//    [self.view insertSubview:_backgroundView atIndex:0];
//    _webViewList = [[NSMutableArray alloc]init];
    NSString *strPrintBill = [Setting getSettingValueWithKeyName:@"printBill"];
    if([strPrintBill integerValue])
    {
        [self checkPrinterStatus];
    }
    
    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    [self setReceiptList];
    [tbvData reloadData];
    [tbvData layoutIfNeeded];
    if(segConPrintStatus.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathNew)
            {
                [tbvData scrollToRowAtIndexPath:_indexPathNew atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 2)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 3)
    {
        //if there is receipt with status = 7,8,11 ให้ขึ้น badge
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 4)
    {
        //status 9,10
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    
    //badge
    {
        
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:7 branchID:credentialsDb.branchID];
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:credentialsDb.branchID]];
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:11 branchID:credentialsDb.branchID]];
        btnBadge.hidden = [receiptActionList count]==0;
    }
    
}

-(void)setReceiptList
{
    if(segConPrintStatus.selectedSegmentIndex == 0)
    {
        _receiptList = [Receipt getReceiptListWithStatus:2 branchID:credentialsDb.branchID];
        //dont forget to uncomment
//        _receiptList = [Receipt sortList:_receiptList];
        _receiptList = [Receipt sortListDesc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 1)
    {
        _receiptList = [Receipt getReceiptListWithStatus:5 branchID:credentialsDb.branchID];
        //dont forget to uncomment
        //        _receiptList = [Receipt sortList:_receiptList];
        _receiptList = [Receipt sortListDesc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 2)
    {
        _receiptList = [Receipt getReceiptListWithStatus:6 branchID:credentialsDb.branchID];
        _receiptList = [Receipt sortListDesc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 3)
    {
        _receiptList = [Receipt getReceiptListWithStatus:7 branchID:credentialsDb.branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:11 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:12 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:13 branchID:credentialsDb.branchID]];
        //dont forget to uncomment
        //        _receiptList = [Receipt sortList:_receiptList];
        _receiptList = [Receipt sortListDesc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 4)
    {
        _receiptList = [Receipt getReceiptListWithStatus:9 branchID:credentialsDb.branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:10 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:14 branchID:credentialsDb.branchID]];
        _receiptList = [Receipt sortListDesc:_receiptList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvData.delegate = self;
    tbvData.dataSource = self;

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        if([_receiptList count] == 0)
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = @"คุณไม่มีประวัติการสั่งอาหาร";
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        return [_receiptList count];
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
        return 1;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        return [orderTakingList count]+1+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Receipt *receipt = _receiptList[section];
        CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
        Branch *branch = [Branch getBranch:receipt.branchID];
        cell.lblReceiptNo.text = [NSString stringWithFormat:@"Order no. #%@", receipt.receiptNoID];
        cell.lblReceiptDate.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yy HH:mm"];
        cell.lblBranchName.text = [NSString stringWithFormat:@"Table: %@",customerTable.tableName];
        cell.lblBranchName.textColor = mGreen;
        
        
        
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel2 bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel2];
        }
        
        
        cell.tbvOrderDetail.delegate = self;
        cell.tbvOrderDetail.dataSource = self;
        cell.tbvOrderDetail.tag = receipt.receiptID;
        [cell.tbvOrderDetail reloadData];
        
        
        if(segConPrintStatus.selectedSegmentIndex == 0)
        {
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:@"Print" forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(printIndividualReceipt:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(segConPrintStatus.selectedSegmentIndex == 1)
        {
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:@"Delivered" forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(changeToDeliveredStatus:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btnOrderItAgain.hidden = YES;
        }
        
        
        
        
        switch (segConPrintStatus.selectedSegmentIndex)
        {
            case 2:
            {
                if (!_lastItemReachedDelivery && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,credentialsDb]];
                }
            }
                break;
            case 4:
            {
                if (!_lastItemReachedOthers && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,credentialsDb]];
                }
            }
                break;
            default:
                break;
        }
        
        
        return cell;
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
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1 branchID:credentialsDb.branchID];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1 branchID:credentialsDb.branchID];
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
            
            
            
            if(receiptID == _selectedReceiptID)
            {
                cell.backgroundColor = mSelectionStyleGray;
                if(item == [orderTakingList count]-1)
                {
                    _selectedReceiptID = 0;
                }
                
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }
        else if(item == [orderTakingList count])
        {
            CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
            NSString *strTotalAmount = [Utility formatDecimal:receipt.cashAmount+receipt.transferAmount+receipt.creditCardAmount withMinFraction:2 andMaxFraction:2];
            strTotalAmount = [Utility addPrefixBahtSymbol:strTotalAmount];
            cell.lblAmount.text = strTotalAmount;
            cell.lblTitle.text = @"รวมทั้งหมด";
            cell.lblTitle.textColor = mGreen;
            cell.lblTitleTop.constant = 8;
            
            
            
            return cell;
        }
        else if(item == [orderTakingList count]+1)
        {
            CustomTableViewCellLabelLabel2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
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
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        //load order มาโชว์
        Receipt *receipt = _receiptList[indexPath.section];
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
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1 branchID:credentialsDb.branchID];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1 branchID:credentialsDb.branchID];
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
        
//        return sumHeight+79+38-16;//38=print button,-16 top margin
        return sumHeight+83+34+34;//+37;
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
            
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1 branchID:credentialsDb.branchID];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1 branchID:credentialsDb.branchID];
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
            
            
            
            float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
            return height;
        }
        else if(indexPath.item == [orderTakingList count])
        {
            return 34;
        }
        else if(indexPath.item == [orderTakingList count]+1)
        {
            return 34;
        }
    }
    return 0;

}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![tableView isEqual:tbvData])
    {
        
        _selectedReceiptID = tableView.tag;
        _selectedReceipt = [Receipt getReceipt:_selectedReceiptID];
        [tableView reloadData];
        
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"segOrderDetail" sender:self];
        });
        
    }
}

-(void)itemsDownloaded:(NSArray *)items
{
    if([[items[0] mutableCopy] count]==0)
    {
        if(segConPrintStatus.selectedSegmentIndex == 2)
        {
            _lastItemReachedDelivery = YES;
        }
        else
        {
            _lastItemReachedOthers = YES;
        }
        [tbvData reloadData];
    }
    else
    {
        [Receipt addList:[items[0] mutableCopy]];
        [OrderTaking addList:[items[1] mutableCopy]];
        [OrderNote addList:[items[2] mutableCopy]];
        [ReceiptPrint addList:[items[3] mutableCopy]];
        
        [self setReceiptList];
        [tbvData reloadData];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)selectList:(id)sender
{
    tbvData.editing = YES;
    [tbvData reloadData];
}

- (IBAction)doAction:(id)sender
{
    //printAll
//    [self printReceipt:_receiptList];
    [self printReceiptKitchenBill:_receiptList];
}

//-(void)printReceipt:(NSMutableArray *)receiptList
//{
//    //print customer kitchen ต่างจาก print kitchen FFD 2 จุด คือ 1.print ทีเดียวหลายโต๊ะ 2.ordertaking จาก jummum จะเป็น order ละ 1 รายการ(FFD จะตามจำนวนรายการที่สั่งพร้อมกัน)
//    
//    NSMutableArray *receiptPrintList = [[NSMutableArray alloc]init];
//    for(Receipt *item in receiptList)
//    {
//        item.status = 5;
//        item.modifiedUser = [Utility modifiedUser];
//        item.modifiedDate = [Utility currentDateTime];
//        
//        ReceiptPrint *receiptPrint = [[ReceiptPrint alloc]initWithReceiptID:item.receiptID];
//        [ReceiptPrint addObject:receiptPrint];
//        [receiptPrintList addObject:receiptPrint];
//    }
//    
//    [self.homeModel insertItems:dbReceiptPrintList withData:receiptPrintList actionScreen:@"insert receiptPrintList in customerKitchen screen"];
//    
//
//    
//    _countPrint = 0;
//    _countingPrint = 0;
//    _arrOfHtmlContentList = [[NSMutableArray alloc]init];
//    _printBillWithPortName = [[NSMutableDictionary alloc]init];
//    NSMutableArray *arrPrintDic = [[NSMutableArray alloc]init];
//    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
//    
//    
//    
//    
//    
//    for(Receipt *item in receiptList)
//    {
//        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:item.receiptID branchID:credentialsDb.branchID];
//        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
//        NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
//        for(OrderTaking *orderTaking in orderTakingList)
//        {
//            OrderKitchen *orderKitchen = [[OrderKitchen alloc]initWithCustomerTableID:orderTaking.customerTableID orderTakingID:orderTaking.orderTakingID sequenceNo:1 customerTableIDOrder:0];
//            orderKitchen.quantity = orderTaking.quantity;
//            [orderKitchenList addObject:orderKitchen];
//        }
//        
//        
//        
//        //foodCheckList
//        NSInteger printFoodCheckList = [[Setting getSettingValueWithKeyName:@"printFoodCheckList"] integerValue];
//        NSInteger printerID = [[Setting getSettingValueWithKeyName:@"foodCheckList"] integerValue];
//        if(printFoodCheckList && printerID)
//        {
//            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
//            {
//                if([orderKitchenList count]>0)
//                {
//                    [printOrderKitchenList addObject:orderKitchenList];
//                }
//            }
//            if([printOrderKitchenList count]>0)
//            {
//                _countPrint = _countPrint+[printOrderKitchenList count];
//                Printer *printer = [Printer getPrinter:printerID];
//                NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
//                [printDic setValue:printOrderKitchenList forKey:printer.portName];
//                [arrPrintDic addObject:printDic];
//            }
//        }
//        
//        
//        
//        //printerKitchenMenuTypeID
//        NSMutableArray *printerList = [Printer getPrinterList];
//        for(int i=0; i<[printerList count]; i++)
//        {
//            Printer *printer = printerList[i];
//            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
//            NSString *printerKitchenMenuTypeID = printer.menuTypeIDListInText;
//            NSArray* menuTypeIDList = [printerKitchenMenuTypeID componentsSeparatedByString: @","];
//            for(NSString *item in menuTypeIDList)
//            {
//                NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
//                
//                if(printOrderKitchenByItem)
//                {
//                    for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
//                    {
//                        
//                        OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
//                        NSInteger quantity = orderKitchen.quantity == 0?orderTaking.quantity:orderKitchen.quantity;
//                        for(int i=0; i<quantity; i++)
//                        {
//                            NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
//                            [orderKitchenList addObject:orderKitchen];
//                            [printOrderKitchenList addObject:orderKitchenList];
//                        }
//                    }
//                }
//                else if(!printOrderKitchenByItem && [orderKitchenMenuTypeIDList count]>0)
//                {
//                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
//                }
//            }
//            if([printOrderKitchenList count]>0)
//            {
//                _countPrint = _countPrint+[printOrderKitchenList count];
//                NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
//                [printDic setValue:printOrderKitchenList forKey:printer.portName];
//                [arrPrintDic addObject:printDic];
//            }
//        }
//    }
//    
//    
//
//    
//    
//    //port with bill and order
//    for(int i=0; i<_countPrint; i++)
//    {
//        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
//        webView.delegate = self;
//        [self.view insertSubview:webView atIndex:0];
//        [_webViewList addObject:webView];
//    }
//    int i=0;
//    for(NSMutableDictionary *printDic in arrPrintDic)
//    {
//        for(NSString *key in printDic)//printDic คือตัวเครื่องพิมพ์
//        {
//            NSMutableArray *printOrderKitchenList = [printDic objectForKey:key];
//            for(NSMutableArray *orderKitchenMenuTypeIDList in printOrderKitchenList)
//            {
//                [_printBillWithPortName setValue:key forKey:[NSString stringWithFormat:@"%d",i]];
//                if([key isEqualToString:@"foodCheckList"])//foodCheckList คือรวมทุกรายการในบิลเดียว หัวบิลแสดงคำว่าทั้งหมด, ถ้าไม่ใช่คือพิมพ์ 1 ที่ต่อ 1 บิล หัวบิลแสดงหมวดอาหารรายการนั้น
//                {
//                    [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:YES];
//                }
//                else
//                {
//                    [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:NO];
//                }
//                i++;
//            }
//        }
//    }
//}
//
//-(void)printKitchenBill:(NSMutableArray *)orderKitchenList orderNo:(NSInteger)orderNo foodCheckList:(BOOL)foodCheckList
//{
//    //prepare data to print
//    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
//    OrderKitchen *orderKitchen = orderKitchenList[0];
//    OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
//    Menu *menu = [Menu getMenu:orderTaking.menuID];
//    MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
//    CustomerTable *customerTable = [CustomerTable getCustomerTable:orderKitchen.customerTableID];
//    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
//    NSString *customerType = customerTable.tableName;
//    NSString *waiterName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
//    NSString *strMenuType = foodCheckList?@"ทั้งหมด":menuType.name;
//    NSString *sequenceNo = [NSString stringWithFormat:@"%ld",orderKitchen.sequenceNo];
//    NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"yyyy-MM-dd HH:mm"];
//    
//    
//    
//    
//    //items
//    float sumQuantity = 0;
//    float quantity = 0;
//    NSMutableArray *items = [[NSMutableArray alloc]init];
//    for(OrderKitchen *item in orderKitchenList)
//    {
//        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
//        
//        OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
//        quantity = orderKitchen.quantity == 0?orderTaking.quantity:orderKitchen.quantity;
//        NSString *strQuantity = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
//        Menu *menu = [Menu getMenu:orderTaking.menuID];
//        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
//        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
//        
//        
//        if(printOrderKitchenByItem)
//        {
//            strQuantity = @"1";
//        }
//        
//        
//        //take away
//        NSString *strTakeAway = @"";
//        if(orderTaking.takeAway)
//        {
//            strTakeAway = @"ใส่ห่อ";
//        }
//        
//        [dicItem setValue:strQuantity forKey:@"quantity"];
//        [dicItem setValue:strTakeAway forKey:@"takeAway"];
//        [dicItem setValue:menu.titleThai forKey:@"menu"];
//        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
//        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
//        [dicItem setValue:@"" forKey:@"pro"];
//        [dicItem setValue:@"" forKey:@"totalPricePerItem"];
//        [items addObject:dicItem];
//        
//        sumQuantity += quantity;
//    }
//    if(printOrderKitchenByItem)
//    {
//        sumQuantity = 1;
//    }
//    NSString *strTotalQuantity = [Utility formatDecimal:sumQuantity withMinFraction:0 andMaxFraction:0];
//    
//    
//    
//    //create html invoice
//    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
//    NSString *invoiceHtml = [invoiceComposer renderKitchenBillWithRestaurantName:restaurantName customerType:customerType waiterName:waiterName menuType:strMenuType sequenceNo:sequenceNo sendToKitchenTime:sendToKitchenTime totalQuantity:strTotalQuantity items:items];
//    
//    
//    
//    
//    UIWebView *webView = _webViewList[orderNo];
//    webView.tag = orderNo;
//    [webView loadHTMLString:invoiceHtml baseURL:NULL];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView
//{
//    [super webViewDidFinishLoad:aWebView];
//    if(self.receiptKitchenBill)
//    {
//        self.receiptKitchenBill = 0;
//        return;
//    }
//    
//    
//    
//    _countingPrint++;
//    NSString *strFileName = [NSString stringWithFormat:@"kitchenBill%ld.pdf",aWebView.tag];
//    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:strFileName];
//    
//    
//    
//    
//    //convert pdf to uiimage
//    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
//    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
//    UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
//    
//    
//    NSLog(@"path: %@",pdfFileName);
////        //TEST
////        [self removeOverlayViews];
////        return;
//    
//    
//    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
//    if(![printBill integerValue])
//    {
//        if(_countingPrint == _countPrint)
//        {
//            [self hideStatus];
//            [self removeOverlayViews];
//            [self loadViewProcess];
////            [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
//        }
//    }
//    else
//    {
//        //print process
//        NSString *portName = [_printBillWithPortName valueForKey:[NSString stringWithFormat:@"%ld",(long)aWebView.tag]];
//        [self doPrintProcess:pdfImagePrint portName:portName];
//    }
//}
//
//-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName
//{
//    NSData *commands = nil;
//    
//    ISCBBuilder *builder = [StarIoExt createCommandBuilder:[AppDelegate getEmulation]];
//    
//    [builder beginDocument];
//    
//    [builder appendBitmap:image diffusion:NO];
//    
//    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
//    
//    [builder endDocument];
//    
//    commands = [builder.commands copy];
//    
//    
//    //    NSString *portName     = [AppDelegate getPortName];
//    NSString *portSettings = [AppDelegate getPortSettings];
//    
//    [Communication sendCommands:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message)
//     {     // 10000mS!!!
//         if(![message isEqualToString:@"พิมพ์สำเร็จ"])
//         {
//             UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
//                                                                            message:message
//                                                                     preferredStyle:UIAlertControllerStyleAlert];
//             
//             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                   handler:^(UIAlertAction * action)
//                                             {
//                                                 if(_countingPrint == _countPrint)
//                                                 {
//                                                     [self hideStatus];
//                                                     [self removeOverlayViews];
//                                                     [self loadViewProcess];
////                                                     [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
//                                                 }
//                                             }];
//             
//             [alert addAction:defaultAction];
//             [self presentViewController:alert animated:YES completion:nil];
//         }
//         else
//         {
//             if(_countingPrint == _countPrint)
//             {
//                 [self hideStatus];
//                 [self removeOverlayViews];
//                 
//                 
//                 //update receipt status
//                 [self loadViewProcess];
////                 [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
//             }
//         }
//     }];
//}

-(void)printIndividualReceipt:(id)sender
{
    UIButton *btnPrint = sender;
    Receipt *receipt = _receiptList[btnPrint.tag];
    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
    [receiptList addObject:receipt];
    [self printReceiptKitchenBill:receiptList];
//    [self printReceipt:receiptList];
    
}

-(void)changeToDeliveredStatus:(id)sender
{
    UIButton *btnPrint = sender;
    Receipt *receipt = _receiptList[btnPrint.tag];
    receipt.status = 6;
    receipt.modifiedUser = [Utility modifiedUser];
    receipt.modifiedDate = [Utility currentDateTime];
    

    [_homeModelDelivered updateItems:dbJummumReceipt withData:receipt actionScreen:@"update JMM receipt"];
}

- (IBAction)printStatusChanged:(id)sender
{
    if(segConPrintStatus.selectedSegmentIndex == 0)
    {
        _indexPathPrinted = tbvData.indexPathsForVisibleRows.firstObject;
        NSLog(@"printed : save indexPath => %ld,%ld",_indexPathPrinted.section,_indexPathPrinted.item);
    }
    else if(segConPrintStatus.selectedSegmentIndex == 1)
    {
        _indexPathNew = tbvData.indexPathsForVisibleRows.firstObject;
        NSLog(@"new : save indexPath => %ld,%ld",_indexPathNew.section,_indexPathNew.item);
    }
    else if(segConPrintStatus.selectedSegmentIndex == 2)
    {
        _indexPathDelivery = tbvData.indexPathsForVisibleRows.firstObject;
        NSLog(@"new : save indexPath => %ld,%ld",_indexPathNew.section,_indexPathNew.item);
    }
    else if(segConPrintStatus.selectedSegmentIndex == 3)
    {
        _indexPathAction = tbvData.indexPathsForVisibleRows.firstObject;
        NSLog(@"new : save indexPath => %ld,%ld",_indexPathNew.section,_indexPathNew.item);
    }
    else if(segConPrintStatus.selectedSegmentIndex == 4)
    {
        _indexPathOthers = tbvData.indexPathsForVisibleRows.firstObject;
        NSLog(@"new : save indexPath => %ld,%ld",_indexPathNew.section,_indexPathNew.item);
    }
    [self loadViewProcess];
}

-(void)checkPrinterStatus
{
    [self loadingOverlayView];
    BOOL result = NO;
    SMPort *port = nil;
    
    
    NSArray *_printerCodeList = @[@"Kitchen",@"Kitchen2",@"Drinks",@"Cashier"];
    for(int i=0; i<[_printerCodeList count]; i++)
    {
        Printer *printer = [Printer getPrinterWithCode:_printerCodeList[i]];
        NSString *strPortName = printer.portName;
        if([Utility isStringEmpty:strPortName])
        {
            //            [_printerStatusList addObject:@""];
            printer.printerStatus = 0;
            continue;
        }
        
        //check status
        @try
        {
            while (YES)
            {
                //                port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                port = [SMPort getPort:strPortName :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                if (port == nil)
                {
                    //printer offline
                    //                    i = 4;
                    //                    [_printerStatusList removeAllObjects];
                    //                    [_printerStatusList addObject:@""];
                    printer.printerStatus = 0;
                    break;
                }
                
                StarPrinterStatus_2 printerStatus;
                
                [port getParsedStatus:&printerStatus :2];
                
                if (printerStatus.offline == SM_TRUE) {
                    [_statusCellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
                    //                    [_printerStatusList addObject:@""];
                    printer.printerStatus = 0;
                }
                else {
                    [_statusCellArray addObject:@[@"Online", @"Online",  [UIColor blueColor]]];
                    //                    [_printerStatusList addObject:@"Online"];
                    printer.printerStatus = 1;
                }
                
                if (printerStatus.offline == SM_TRUE) {
                    [_firmwareInfoCellArray addObject:@[@"Unable to get F/W info. from an error.", @"", [UIColor redColor]]];
                    
                    result = YES;
                    break;
                }
                else {
                    NSDictionary *firmwareInformation = [port getFirmwareInformation];
                    
                    if (firmwareInformation == nil) {
                        break;
                    }
                    
                    [_firmwareInfoCellArray addObject:@[@"Model Name",       [firmwareInformation objectForKey:@"ModelName"],       [UIColor blueColor]]];
                    
                    [_firmwareInfoCellArray addObject:@[@"Firmware Version", [firmwareInformation objectForKey:@"FirmwareVersion"], [UIColor blueColor]]];
                    
                    result = YES;
                    break;
                }
            }
        }
        @catch (PortException *exc) {
        }
        @finally {
            if (port != nil) {
                [SMPort releasePort:port];
                
                port = nil;
            }
        }
    }
    
    
    if (result == NO)
    {
        imgPrinterStaus.image = [UIImage imageNamed:@"offline"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        imgPrinterStaus.image = [UIImage imageNamed:@"connected"];
    }
    [self removeOverlayViews];
}

- (IBAction)connectPrinter:(id)sender
{
    [self checkPrinterStatus];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderDetail"])
    {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
        vc.credentialsDb = credentialsDb;
    }
}

-(void)reloadTableView
{
    [self setReceiptList];
    [tbvData reloadData];
}

-(void)itemsUpdated
{
    [self setReceiptList];
    [tbvData reloadData];
}
@end
