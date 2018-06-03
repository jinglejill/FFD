//
//  OrderHistoryViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "CustomTableViewCellOrderHistory.h"
#import "OrderKitchen.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "SubMenuType.h"
#import "MenuType.h"
#import "Setting.h"
#import "InvoiceComposer.h"
#import "CustomPrintPageRenderer.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"


@interface OrderHistoryViewController ()
{
    NSMutableArray *_listOfOrderTakingList;
    NSMutableArray *_webViewList;
    UIView *_backgroundView;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
}
@end

@implementation OrderHistoryViewController
static NSString * const reuseIdentifierOrderHistory = @"CustomTableViewCellOrderHistory";


@synthesize tbvOrderHistory;
@synthesize customerTable;
@synthesize btnClose;

-(void)viewDidLayoutSubviews
{
    {
        CGRect frame = _backgroundView.frame;
        frame = self.view.frame;
        _backgroundView.frame = frame;
    }
}

- (void)loadView
{
    [super loadView];
    
    
    [self setButtonDesign:btnClose];


    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    
    
    _webViewList = [[NSMutableArray alloc]init];

    
    
    
    
    [tbvOrderHistory setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    _listOfOrderTakingList = [[NSMutableArray alloc]init];
    NSMutableArray *status2OrderKitchenList = [OrderKitchen getOrderKitchenListWithCustomerTableID:customerTable.customerTableID status:2];
    NSMutableArray *status5OrderKitchenList = [OrderKitchen getOrderKitchenListWithCustomerTableID:customerTable.customerTableID status:5];
    NSMutableArray *allOrderKitchenList = [[NSMutableArray alloc]init];
    [allOrderKitchenList addObjectsFromArray:status2OrderKitchenList];
    [allOrderKitchenList addObjectsFromArray:status5OrderKitchenList];
    
    
    
    //split to 2 parts 1.no customerTableOrder 2. have customerTableOrder
    NSMutableArray *orderKitchenListNoCustomerTableIDOrder = [OrderKitchen getOrderKitchenListWithNoCustomerTableIDOrder:allOrderKitchenList];
    NSMutableArray *orderKitchenListHaveCustomerTableIDOrder = [OrderKitchen getOrderKitchenListWithHaveCustomerTableIDOrder:allOrderKitchenList];
    
    
    NSSet *sequenceNoSet = [NSSet setWithArray:[orderKitchenListNoCustomerTableIDOrder valueForKey:@"_sequenceNo"]];
    for (int i=0; i<[sequenceNoSet count]; i++)
    {
        NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithSequenceNo:(i+1) orderKitchenList:orderKitchenListNoCustomerTableIDOrder];
        for(OrderKitchen *item in orderKitchenList)
        {
            OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
            [orderTakingList addObject:orderTaking];
        }
        orderTakingList = [OrderTaking createSumUpOrderTakingGroupByNoteFromSeveralSendToKitchen:orderTakingList];
        [_listOfOrderTakingList addObject:orderTakingList];
    }
    
    
    
    //2.
    NSSet *customerTableIDOrderSet = [NSSet setWithArray:[orderKitchenListHaveCustomerTableIDOrder valueForKey:@"_customerTableIDOrder"]];
    NSArray *customerTableIDOrderList = [customerTableIDOrderSet allObjects];
    NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithCustomerTableIDList:customerTableIDOrderList];
    for(int j=0; j<[customerTableList count]; j++)
    {
//        orderKitchenListHaveCustomerTableIDOrder-->find sequence
        CustomerTable *customerTable = customerTableList[j];
        NSMutableArray *orderKitchenListWithCustomerTableIDOrder = [OrderKitchen getOrderKitchenListWithCustomerTableOrderID:customerTable.customerTableID orderKitchenList:orderKitchenListHaveCustomerTableIDOrder];
        NSSet *sequenceNoSet = [NSSet setWithArray:[orderKitchenListWithCustomerTableIDOrder valueForKey:@"_sequenceNo"]];
        NSArray *sequenceNoList = [sequenceNoSet allObjects];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_sequenceNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        sequenceNoList = [sequenceNoList sortedArrayUsingDescriptors:sortDescriptors];
        
        
        
        

        for(NSNumber *item in sequenceNoList)
        {
            NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
            NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithSequenceNo:[item integerValue] orderKitchenList:orderKitchenListWithCustomerTableIDOrder];
            for(OrderKitchen *item in orderKitchenList)
            {
                OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
                [orderTakingList addObject:orderTaking];
            }
            orderTakingList = [OrderTaking createSumUpOrderTakingGroupByNoteFromSeveralSendToKitchen:orderTakingList];
            [_listOfOrderTakingList addObject:orderTakingList];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tbvOrderHistory.dataSource = self;
    tbvOrderHistory.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderHistory bundle:nil];
        [tbvOrderHistory registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderHistory];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    

    return [_listOfOrderTakingList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
    
    return [orderTakingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    CustomTableViewCellOrderHistory *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderHistory forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
    OrderTaking *orderTaking = orderTakingList[item];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
    
    
    NSString *strMenuName;
    if(orderTaking.takeAway)
    {
        strMenuName = [NSString stringWithFormat:@"ใส่ห่อ %@",menu.titleThai];
    }
    else
    {
        strMenuName = menu.titleThai;
    }
    
    cell.lblMenu.text = strMenuName;
    cell.lblQuantity.text = strQuantity;
    
    
    
    CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenu.font size:CGSizeMake(tbvOrderHistory.frame.size.width - 27-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenu.text];
    CGRect frame = cell.lblMenu.frame;
    frame.size.width = menuNameLabelSize.width;
    frame.size.height = menuNameLabelSize.height;
    cell.lblMenu.frame = frame;
    
    
    
    
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
    
    CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvOrderHistory.frame.size.width - 27-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
    CGRect frame2 = cell.lblNote.frame;
    frame2.size.width = noteLabelSize.width;
    frame2.size.height = noteLabelSize.height;
    cell.lblNote.frame = frame2;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;

    //load order มาโชว์
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
    OrderTaking *orderTaking = orderTakingList[item];
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
    
    
    CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(300-27-16-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];
    float noteHeight = 0;
    if(![Utility isStringEmpty:[strAllNote string]])
    {
        CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(300-27-16-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
        noteHeight = noteLabelSize.height;

    }
    

    
    float height = menuNameLabelSize.height+noteHeight+10*2;
    height = height < 49.83? 49.83:height;
    return height;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
//    if([orderTakingList count]>0)
//    {
        OrderTaking *orderTaking = orderTakingList[0];
        OrderKitchen *orderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:orderTaking.orderTakingID];
        NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"HH:mm"];
        NSInteger sequenceNo = orderKitchen.sequenceNo;
//    }
//    else
//    {
//        sendToKitchenTime = @"00:00";
//    }
    
    
    NSString *sectionName = [NSString stringWithFormat:@"#%ld  %@",sequenceNo, sendToKitchenTime];
    if(orderKitchen.customerTableIDOrder != 0)
    {
        CustomerTable *customerTable = [CustomerTable getCustomerTable:orderKitchen.customerTableIDOrder];
        sectionName = [NSString stringWithFormat:@"%@ (tb. %@)",sectionName,customerTable.tableName];
    }
    
    
    
    
    //label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:sectionName];
    [view addSubview:label];
    
    
    
    //button print
    UIButton *btnPrint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPrint.frame = CGRectMake(tableView.frame.size.width-60-8,7, 60, 30);
    btnPrint.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    btnPrint.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnPrint setTitle:@"Print" forState:UIControlStateNormal];
    [btnPrint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPrint setBackgroundColor:[UIColor clearColor]];
    btnPrint.tag = section;
    
    [btnPrint addTarget:self action:@selector(printHistoryKitchenBill:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnPrint];


    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)printHistoryKitchenBill:(id)sender
{
    [self loadingOverlayView];
    [self showStatus:@""];



    UIButton *button = sender;
    NSInteger section = button.tag;
    
    
    
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
    NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:orderTakingList];
    
    
    
    
    //print kitchen bill
    _countPrint = 0;
    _countingPrint = 0;
    NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
    _printBillWithPortName = [[NSMutableDictionary alloc]init];
    //split kitchen bill to various type printer
    //printerPortCashier
    {
        NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
        {
            if([orderKitchenList count]>0)
            {
                [printOrderKitchenList addObject:orderKitchenList];
            }
        }
        if([printOrderKitchenList count]>0)
        {
            _countPrint = _countPrint+[printOrderKitchenList count];
            [printDic setValue:printOrderKitchenList forKey:@"foodCheckList"];
        }
    }
    
    
    
    
    
    //printerKitchenMenuTypeID
    {
        NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
        NSString *printerKitchenMenuTypeID = [Setting getSettingValueWithKeyName:@"printerKitchenMenuTypeID"];
        NSArray* menuTypeIDList = [printerKitchenMenuTypeID componentsSeparatedByString: @","];
        for(NSString *item in menuTypeIDList)
        {
            NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
            for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
            {
                OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
                for(int i=0; i<orderTaking.quantity; i++)
                {
                    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
                    [orderKitchenList addObject:orderKitchen];
                    [printOrderKitchenList addObject:orderKitchenList];
                }
            }
        }
        if([printOrderKitchenList count]>0)
        {
            _countPrint = _countPrint+[printOrderKitchenList count];
            [printDic setValue:printOrderKitchenList forKey:@"printerPortKitchen"];
        }
    }
    
    
    
    //printerKitchen2MenuTypeID
    {
        NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
        NSString *printerKitchen2MenuTypeID = [Setting getSettingValueWithKeyName:@"printerKitchen2MenuTypeID"];
        NSArray* menuTypeIDList = [printerKitchen2MenuTypeID componentsSeparatedByString: @","];
        for(NSString *item in menuTypeIDList)
        {
            NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
            for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
            {
                OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
                for(int i=0; i<orderTaking.quantity; i++)
                {
                    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
                    [orderKitchenList addObject:orderKitchen];
                    [printOrderKitchenList addObject:orderKitchenList];
                }
            }
        }
        if([printOrderKitchenList count]>0)
        {
            _countPrint = _countPrint+[printOrderKitchenList count];
            [printDic setValue:printOrderKitchenList forKey:@"printerPortKitchen2"];
        }
    }
    
    
    
    //printerDrinksMenuTypeID
    {
        NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
        NSString *printerDrinksMenuTypeID = [Setting getSettingValueWithKeyName:@"printerDrinksMenuTypeID"];
        NSArray* menuTypeIDList = [printerDrinksMenuTypeID componentsSeparatedByString: @","];
        for(NSString *item in menuTypeIDList)
        {
            NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
            for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
            {
                OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
                for(int i=0; i<orderTaking.quantity; i++)
                {
                    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
                    [orderKitchenList addObject:orderKitchen];
                    [printOrderKitchenList addObject:orderKitchenList];
                }
            }
        }
        if([printOrderKitchenList count]>0)
        {
            _countPrint = _countPrint+[printOrderKitchenList count];
            [printDic setValue:printOrderKitchenList forKey:@"printerPortDrinks"];
        }
    }
    
    
    
    //port with bill and order
    for(int i=0; i<_countPrint; i++)
    {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
        webView.delegate = self;
        [self.view insertSubview:webView atIndex:0];
        [_webViewList addObject:webView];
    }
    int i=0;
    for(NSString *key in printDic)
    {
        NSMutableArray *printOrderKitchenList = [printDic objectForKey:key];
        for(NSMutableArray *orderKitchenMenuTypeIDList in printOrderKitchenList)
        {
            [_printBillWithPortName setValue:key forKey:[NSString stringWithFormat:@"%d",i]];
            if([key isEqualToString:@"foodCheckList"])
            {
                [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:YES];
            }
            else
            {
                [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:NO];
            }
            i++;
        }
    }
}

-(void)printKitchenBill:(NSMutableArray *)orderKitchenList orderNo:(NSInteger)orderNo  foodCheckList:(BOOL)foodCheckList
{
    //prepare data to print
    OrderKitchen *orderKitchen = orderKitchenList[0];
    OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *customerType = customerTable.tableName;
    NSString *waiterName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *strMenuType = foodCheckList?@"ทั้งหมด":menuType.name;
    NSString *sequenceNo = [NSString stringWithFormat:@"%ld",orderKitchen.sequenceNo];
    NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"yyyy-MM-dd HH:mm"];
    
    
    
    
    //items
    float sumQuantity = 0;
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for(OrderKitchen *item in orderKitchenList)
    {
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        
        OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        
        if(!foodCheckList)
        {
            strQuantity = @"1";
        }
        
        
        //take away
        NSString *strTakeAway = @"";
        if(orderTaking.takeAway)
        {
            strTakeAway = @"ใส่ห่อ";
        }
        
        [dicItem setValue:strQuantity forKey:@"quantity"];
        [dicItem setValue:strTakeAway forKey:@"takeAway"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:@"" forKey:@"pro"];
        [dicItem setValue:@"" forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
        
        sumQuantity += orderTaking.quantity;
    }
    if(!foodCheckList)
    {
        sumQuantity = 1;
    }
    NSString *strTotalQuantity = [Utility formatDecimal:sumQuantity withMinFraction:0 andMaxFraction:0];
    
    
    
    //create html invoice
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    NSString *invoiceHtml = [invoiceComposer renderKitchenBillWithRestaurantName:restaurantName customerType:customerType waiterName:waiterName menuType:strMenuType sequenceNo:sequenceNo sendToKitchenTime:sendToKitchenTime totalQuantity:strTotalQuantity items:items];
    
    

    
    
    UIWebView *webView = _webViewList[orderNo];
    webView.tag = orderNo;
    [webView loadHTMLString:invoiceHtml baseURL:NULL];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    
    
    _countingPrint++;
    NSString *strFileName = [NSString stringWithFormat:@"kitchenBill%ld.pdf",aWebView.tag];
    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:strFileName];


    
    //convert pdf to uiimage
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
    UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
    
    
    NSLog(@"path: %@",pdfFileName);
    //    //TEST
    //    [self removeOverlayViews];
    //    return;
    
    
    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
    if(![printBill integerValue])
    {
        [self hideStatus];
        [self removeOverlayViews];
        [self closeVc:nil];
    }
    else
    {
        //print process
        NSString *printerSettingKey = [_printBillWithPortName valueForKey:[NSString stringWithFormat:@"%ld",(long)aWebView.tag]];
        if([printerSettingKey isEqualToString:@"foodCheckList"])
        {
            printerSettingKey = [Setting getSettingValueWithKeyName:@"foodCheckList"];
        }
        NSString *portName = [Setting getSettingValueWithKeyName:printerSettingKey];
        NSLog(@"portName kitchen: %@",portName);
        [self doPrintProcess:pdfImagePrint portName:portName];
    }
}

-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName
{
    NSData *commands = nil;
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:[AppDelegate getEmulation]];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    commands = [builder.commands copy];
    
    
    //    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    [Communication sendCommands:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message)
     {     // 10000mS!!!
         if(![message isEqualToString:@"พิมพ์สำเร็จ"])
         {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self hideStatus];
                                                 [self removeOverlayViews];
                                                 [self closeVc:nil];
                                             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             if(_countingPrint == _countPrint)
             {
                 [self hideStatus];
                 [self removeOverlayViews];
                 [self closeVc:nil];
             }             
         }
     }];
}

- (IBAction)closeVc:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
