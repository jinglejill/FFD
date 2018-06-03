//
//  DeleteOrderPasswordViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/11/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "DeleteOrderPasswordViewController.h"
#import "ReceiptViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "Setting.h"
#import "OrderNote.h"
#import "Menu.h"
#import "OrderKitchen.h"
#import "CustomPrintPageRenderer.h"
#import "InvoiceComposer.h"




//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"




@interface DeleteOrderPasswordViewController ()
{
    UITextField *_txtPassword;
    NSString *_passwordEditing;
    NSMutableArray *_htmlContentList;
    UIView *_backgroundView;
    UIWebView *_webview;
    OrderTaking *_printOrderTaking;
}

@end

@implementation DeleteOrderPasswordViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";


@synthesize tbvPassword;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize orderTaking;
@synthesize customerTable;
@synthesize cancelAll;

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [vwConfirmAndCancel.btnConfirm sendActionsForControlEvents: UIControlEventTouchUpInside];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtPassword])
    {
        _passwordEditing = textField.text;
    }
}

-(void)viewDidLayoutSubviews
{
    {
        CGRect frame = _backgroundView.frame;
        frame = self.view.frame;
        _backgroundView.frame = frame;
    }
}

-(void)loadView
{
    [super loadView];
    
    
    _htmlContentList = [[NSMutableArray alloc]init];
    
    
    
    
    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
    _webview.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    tbvPassword.dataSource = self;
    tbvPassword.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvPassword registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvPassword.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmPassword:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    
    cell.lblTitle.text = @"รหัสผ่าน:";
    _txtPassword = cell.txtValue;
    cell.txtValue.placeholder = @"xxxxxx";
    cell.txtValue.delegate = self;
    cell.txtValue.text = _passwordEditing;
    cell.txtValue.secureTextEntry = YES;
    
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

- (void)confirmPassword:(id)sender
{
    [self.view endEditing:YES];
    if(![self validatePassword])
    {
        return;
    }
    
    
    //delete order
    if(orderTaking.quantity == 1)
    {
        //update status to 3
        OrderTaking *cancelOrderTaking = [OrderTaking getOrderTaking:orderTaking.orderTakingID];
        cancelOrderTaking.status = 3;
        cancelOrderTaking.modifiedUser = [Utility modifiedUser];
        cancelOrderTaking.modifiedDate = [Utility currentDateTime];
        _printOrderTaking = orderTaking;
        [self.homeModel updateItems:dbOrderTaking withData:cancelOrderTaking actionScreen:@"cancel receiptOrder by update ordertaking status(quantity = 1) in receipt screen"];
    }
    else if(cancelAll)//ลบทั้งรายการ
    {
        _printOrderTaking = orderTaking;
        NSMutableArray *cancelOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:orderTaking.customerTableID status:orderTaking.status takeAway:orderTaking.takeAway menuID:orderTaking.menuID noteIDListInText:orderTaking.noteIDListInText specialPrice:orderTaking.specialPrice cancelDiscountReason:orderTaking.cancelDiscountReason];
        for(OrderTaking *item in cancelOrderTakingList)
        {
            //update status to 3
            item.status = 3;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        [self.homeModel updateItems:dbOrderTakingList withData:cancelOrderTakingList actionScreen:@"cancel receiptOrder by update ordertaking status(cancel all) in receipt screen"];
    }
    else//ลบทีละ 1 รายการ
    {
        //แบ่งเป็น 2 กรณี 1.ordertaking นั้น quantity = 1,  2.ordertaking นั้น quantity > 1
        OrderTaking *minusOneOrderTaking = [OrderTaking getOrderTakingWithCustomerTableID:orderTaking.customerTableID status:orderTaking.status takeAway:orderTaking.takeAway menuID:orderTaking.menuID noteIDListInText:orderTaking.noteIDListInText specialPrice:orderTaking.specialPrice cancelDiscountReason:orderTaking.cancelDiscountReason];
        if(minusOneOrderTaking.quantity == 1)
        {
            minusOneOrderTaking.status = 3;
            minusOneOrderTaking.modifiedUser = [Utility modifiedUser];
            minusOneOrderTaking.modifiedDate = [Utility currentDateTime];
            _printOrderTaking = minusOneOrderTaking;
            [self.homeModel updateItems:dbOrderTaking withData:minusOneOrderTaking actionScreen:@"cancel receiptOrder by update ordertaking status(quantity per sequenceNo = 1 case total quantity > 1) in receipt screen"];
        }
        else
        {
            //update existing one
            minusOneOrderTaking.quantity -= 1;
            minusOneOrderTaking.modifiedUser = [Utility modifiedUser];
            minusOneOrderTaking.modifiedDate = [Utility currentDateTime];
            
            
            
            //create new orderTaking
            OrderTaking *cancelOrderTaking = [minusOneOrderTaking copy];
            cancelOrderTaking.orderTakingID = [OrderTaking getNextID];
            cancelOrderTaking.quantity = 1;
            cancelOrderTaking.status = 3;
            [OrderTaking addObject:cancelOrderTaking];
            
            
            
            //create new orderNote
            //ordernote for cancelOrderTaking
            NSMutableArray *newOrderNoteList = [[NSMutableArray alloc]init];
            NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:minusOneOrderTaking.orderTakingID];
            for(OrderNote *item in orderNoteList)
            {
                OrderNote *orderNote = [item copy];
                orderNote.orderNoteID = [OrderNote getNextID];
                orderNote.orderTakingID = cancelOrderTaking.orderTakingID;
                [OrderNote addObject:orderNote];
                [newOrderNoteList addObject:orderNote];
            }
            
            
            
            //create new orderKitchen
            //orderkitchen for cancelOrderTaking
            OrderKitchen *selectedOrderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:minusOneOrderTaking.orderTakingID];
            OrderKitchen *orderKitchen = [selectedOrderKitchen copy];
            orderKitchen.orderKitchenID = [OrderKitchen getNextID];
            orderKitchen.orderTakingID = cancelOrderTaking.orderTakingID;            
            [OrderKitchen addObject:orderKitchen];
            
            
            
            _printOrderTaking = cancelOrderTaking;
            [self.homeModel updateItems:dbOrderTakingOrderNoteOrderKitchenCancelOrder withData:@[minusOneOrderTaking,cancelOrderTaking,newOrderNoteList,orderKitchen] actionScreen:@"cancel receiptOrder by update ordertaking status(cancel 1) in receipt screen"];
        }
    }
    
    
    //print delete log
    [self printCancelOrderBill];
}

- (void)cancelPassword:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validatePassword
{
    _txtPassword.text = [Utility trimString:_txtPassword.text];
    
    
    if(![Setting isDeleteOrderPasswordValid:_txtPassword.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"รหัสผ่านไม่ถูกต้อง"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

-(void)printCancelOrderBill
{
    [self loadingOverlayView];
    
    
    //prepare data to print main
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *customerType = customerTable.tableName;
    NSString *managerName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *cancelTime = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy-MM-dd HH:mm"];
    
    
    
    
    //items
    NSMutableArray *items = [[NSMutableArray alloc]init];
    {
        OrderTaking *item = _printOrderTaking;
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        NSString *strQuantity = [Utility formatDecimal:item.quantity withMinFraction:0 andMaxFraction:0];
        
        Menu *menu = [Menu getMenu:item.menuID];
        NSString *strTotalPricePerItem = [Utility formatDecimal:item.specialPrice*item.quantity withMinFraction:0 andMaxFraction:0];
        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        
        
        
        //promotion item
        NSString *strPro;
        if(item.specialPrice == item.price)
        {
            strPro = @"";
        }
        else
        {
            strPro = @"P";
        }
        
        
        //take away
        NSString *strTakeAway = @"";
        if(item.takeAway)
        {
            strTakeAway = @"ใส่ห่อ";
        }
        
        [dicItem setValue:strQuantity forKey:@"quantity"];
        [dicItem setValue:strTakeAway forKey:@"takeAway"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:strPro forKey:@"pro"];
        [dicItem setValue:strTotalPricePerItem forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
    }
    
    
    
    //create html cancel order bill
    NSString *invoiceHtml = @"";
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    invoiceHtml = [invoiceComposer renderCancelOrderBillWithRestaurantName:restaurantName customerType:customerType managerName:managerName cancelTime:cancelTime items:items];
    
    
    [_htmlContentList removeAllObjects];
    [_htmlContentList addObject:invoiceHtml];
    
    
    
    
    //load into webview in order to calculate height of content to prepare pdf
    [_webview loadHTMLString:invoiceHtml baseURL:NULL];
    if(![_webview isDescendantOfView:self.view])
    {
        [self.view insertSubview:_webview atIndex:0];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    
    
    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:@"cancelOrder.pdf"];
    

    //convert pdf to image
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
    UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
    NSLog(@"pdf fileName: %@",pdfFileName);
    
    
    //        //test remove after finish test
    //        return;
    
    
    
    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
    if(![printBill integerValue])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showAlert:@"" message:@"ยกเลิกรายการสำเร็จ"];
            [vc reloadReceiptOrder];
            [vc updatePaidAmount];
        }];
    }
    else
    {
        //print process
        NSString *portName = [Setting getSettingValueWithKeyName:@"printerPortCashier"];
        NSLog(@"portName receipt: %@",portName);
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
                                                 [self removeOverlayViews];
                                             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             [self dismissViewControllerAnimated:YES completion:^{
                 [vc showAlert:@"" message:@"ยกเลิกรายการสำเร็จ"];
                 [vc reloadReceiptOrder];
             }];
         }
     }];
}

@end
