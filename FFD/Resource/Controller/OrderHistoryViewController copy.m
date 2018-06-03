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
    NSMutableArray *_arrOfHtmlContentList;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
}
@end

@implementation OrderHistoryViewController
static NSString * const reuseIdentifierOrderHistory = @"CustomTableViewCellOrderHistory";


@synthesize tbvOrderHistory;
@synthesize customerTable;


- (void)loadView
{
    [super loadView];
    
    
    _arrOfHtmlContentList = [[NSMutableArray alloc]init];
    NSInteger countMenuType = [MenuType getCountMenuType];
    for(int i=0; i<countMenuType; i++)
    {
        NSMutableArray *htmlContentList = [[NSMutableArray alloc]init];
        [_arrOfHtmlContentList addObject:htmlContentList];
    }
    

    
    //use webview for calculate pdf page size
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:backgroundView atIndex:0];
    
    
    _webViewList = [[NSMutableArray alloc]init];
    for(int i=0; i<countMenuType; i++)
    {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];
        webView.delegate = self;
        [self.view insertSubview:webView atIndex:0];
        [_webViewList addObject:webView];
    }
    //---------------
    
    
    
    
    
    
    
    
    
    [tbvOrderHistory setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    _listOfOrderTakingList = [[NSMutableArray alloc]init];
    NSMutableArray *allOrderKitchenList = [OrderKitchen getOrderKitchenListWithCustomerTableID:customerTable.customerTableID status:2];
    NSInteger numOfSequence = [OrderKitchen getNextSequenceNoWithCustomerTableID:customerTable.customerTableID status:2]-1;
    
    
    for (int i=0; i<numOfSequence; i++)
    {
        NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
        NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithSequenceNo:(i+1) orderKitchenList:allOrderKitchenList];
        for(OrderKitchen *item in orderKitchenList)
        {
            OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
            [orderTakingList addObject:orderTaking];
        }
        
        
        for(OrderTaking *item in orderTakingList)
        {
            Menu *menu = [Menu getMenu:item.menuID];
            item.menuOrderNo = menu.orderNo;
            SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
            item.subMenuOrderNo = subMenuType.orderNo;
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,nil];
        NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];        
        [_listOfOrderTakingList addObject:sortArray];
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
    OrderTaking *orderTaking = orderTakingList[0];
    OrderKitchen *orderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:orderTaking.orderTakingID];
    NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"HH:mm"];
    NSString *sectionName = [NSString stringWithFormat:@"#%ld  %@",section+1, sendToKitchenTime];
    
    
    
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
    
    [btnPrint addTarget:self action:@selector(printKitchenBill:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnPrint];


    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)printKitchenBill:(id)sender
{
    [self loadingOverlayView];
    UIButton *button = sender;
    NSInteger section = button.tag;
    
    
    
    NSMutableArray *orderTakingList = _listOfOrderTakingList[section];
    NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:orderTakingList];
    
    
    
    
    //print kitchen bill
    _countPrint = 0;
    _countingPrint = 0;
    //          _countingLoadWebView = 0;
    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
    NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
    _printBillWithPortName = [[NSMutableDictionary alloc]init];
    if([printBill integerValue])
    {
        //split kitchen bill to various type printer
        //printerKitchenMenuTypeID
        {
            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
            NSString *printerKitchenMenuTypeID = [Setting getSettingValueWithKeyName:@"printerKitchenMenuTypeID"];
            NSArray* menuTypeIDList = [printerKitchenMenuTypeID componentsSeparatedByString: @","];
            for(NSString *item in menuTypeIDList)
            {
                NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
                if([orderKitchenMenuTypeIDList count]>0)
                {
                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
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
                if([orderKitchenMenuTypeIDList count]>0)
                {
                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
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
                if([orderKitchenMenuTypeIDList count]>0)
                {
                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
                }
            }
            if([printOrderKitchenList count]>0)
            {
                _countPrint = _countPrint+[printOrderKitchenList count];
                [printDic setValue:printOrderKitchenList forKey:@"printerPortDrinks"];
            }
        }
        
        
        
        //port with bill and order
        int i=0;
        for(NSString *key in printDic)
        {
            NSMutableArray *printOrderKitchenList = [printDic objectForKey:key];
            for(NSMutableArray *orderKitchenMenuTypeIDList in printOrderKitchenList)
            {
                [_printBillWithPortName setValue:key forKey:[NSString stringWithFormat:@"%d",i]];
                [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i];
                i++;
            }
        }
    }
}

-(void)printKitchenBill:(NSMutableArray *)orderKitchenList orderNo:(NSInteger)orderNo
{
    //prepare data to print
    OrderKitchen *orderKitchen = orderKitchenList[0];
    OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *customerType = customerTable.tableName;
    NSString *waiterName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *strMenuType = menuType.name;
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
        
        [dicItem setValue:@"1" forKey:@"quantity"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:@"" forKey:@"pro"];
        [dicItem setValue:@"" forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
        
        sumQuantity += orderTaking.quantity;
    }
    NSString *strTotalQuantity = [Utility formatDecimal:1 withMinFraction:0 andMaxFraction:0];
    
    
    
    //create html invoice
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    NSString *invoiceHtml = [invoiceComposer renderInvoiceWithRestaurantName:restaurantName customerType:customerType waiterName:waiterName menuType:strMenuType sequenceNo:sequenceNo sendToKitchenTime:sendToKitchenTime totalQuantity:strTotalQuantity items:items];
    
    
    
    
    
    
    
    
    
    //load into webview in order to calculate height of content to prepare pdf
    NSMutableArray *htmlContentList = _arrOfHtmlContentList[orderNo];
    [htmlContentList removeAllObjects];
    [htmlContentList addObject:invoiceHtml];
    
    
    UIWebView *webView = _webViewList[orderNo];
    webView.tag = orderNo;
    [webView loadHTMLString:invoiceHtml baseURL:NULL];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    _countingPrint++;
    NSInteger htmlContentHeight = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue];
    
    
    //convert html to pdf with html content height
    NSString *strFileName = [NSString stringWithFormat:@"kitchenBill%ld",aWebView.tag];
    CustomPrintPageRenderer *printPageRenderer = [[CustomPrintPageRenderer alloc]initWithPageWidth:600 height:htmlContentHeight];
    
    
    
    NSMutableArray *htmlContentList = _arrOfHtmlContentList[aWebView.tag];
    NSString  *pdfFileName = [printPageRenderer exportHTMLContentToPDF:htmlContentList fileName:strFileName];
    
    
    
    //convert pdf to uiimage
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
    pdfImagePrint = [self cropImage:pdfImagePrint];
    
    NSLog(@"path: %@",pdfFileName);
    //    return;
    
    
    
    
    //print process
    NSString *printerSettingKey = [_printBillWithPortName valueForKey:[NSString stringWithFormat:@"%ld",(long)aWebView.tag]];
    NSString *portName = [Setting getSettingValueWithKeyName:printerSettingKey];
    NSLog(@"portName kitchen: %@",portName);
    [self doPrintProcess:pdfImagePrint portName:portName];
    
    
    
//    if(_countingPrint == _countPrint)
//    {
//        [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
//    }
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
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             alertView.tag = 22;
             alertView.delegate = self;
             [alertView show];
         }
         else
         {
             if(_countingPrint == _countPrint)
             {
                 [self removeOverlayViews];
             }
         }
     }];
}

@end
