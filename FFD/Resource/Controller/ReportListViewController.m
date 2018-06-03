//
//  ReportListViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportListViewController.h"
#import "ReportDetailViewController.h"
#import "CustomReportViewController.h"
#import "SalesTransaction.h"
#import "Setting.h"
#import "CustomPrintPageRenderer.h"
#import "InvoiceComposer.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"




@interface ReportListViewController ()
{
    NSInteger _selectedIndexReportGroup;
    NSInteger _selectedIndexReportType;
    NSInteger _selectedIndexFrequency;
    NSArray *_frequencyList;
    NSArray *_reportTypeList;
    UITextField *_activeTextField;
    NSMutableArray *_salesTransactionList;
    UIWebView *_webview;
    UIView *_backgroundView;
    NSMutableArray *_reportEndDayList;
    NSMutableArray *_saleAndDiscountList;
    NSMutableArray *_countReceiptAndServingPersonList;
    NSMutableArray *_cashAmountList;
    NSMutableArray *_creditCardAmountList;
}
@end

@implementation ReportListViewController
@synthesize tbvReportNameList;
@synthesize lblStartDate;
@synthesize lblEndDate;
@synthesize txtStartDate;
@synthesize txtEndDate;
@synthesize dtPicker;
@synthesize txtFrequency;
@synthesize txtReportType;
@synthesize pickerVw;
@synthesize btnExportOrderTransaction;
@synthesize btnReportEndDay;


- (void)viewDidLayoutSubviews
{
    CGRect frame = tbvReportNameList.frame;
    frame.size.height = frame.size.height-200;
    tbvReportNameList.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setButtonDesign:btnExportOrderTransaction];
    [self setButtonDesign:btnReportEndDay];
    tbvReportNameList.dataSource = self;
    tbvReportNameList.delegate = self;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    switch (indexPath.item) {
        case 0:
            cell.textLabel.text = @"รายงานยอดขาย";
            break;
        case 1:
            cell.textLabel.text = @"รายงานวัตถุดิบคงคลังและปริมาณการใช้";
            break;
        case 2:
            cell.textLabel.text = @"รายงานค่าใช้จ่าย";
            break;
        case 3:
            cell.textLabel.text = @"สรุปผลประกอบการ";
            break;
        case 4:
            cell.textLabel.text = @"รายงานสมาชิก";
            break;
            
        default:
            break;
    }
    
    if(_selectedIndexReportGroup == indexPath.item)
    {
        cell.backgroundColor = mLightBlueColor;
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = mBlueColor;
    
    _selectedIndexReportGroup = indexPath.item;
    [self sendParamToReportDetail];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];


    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    [self sendParamToReportDetail];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:txtStartDate] || [textField isEqual:txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    else if([textField isEqual:txtFrequency])
    {
        [pickerVw selectRow:_selectedIndexFrequency inComponent:0 animated:NO];
    }
    else if([textField isEqual:txtReportType])
    {
        [pickerVw selectRow:_selectedIndexReportType inComponent:0 animated:NO];
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([txtStartDate isFirstResponder])
    {
        txtStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    if([txtEndDate isFirstResponder])
    {
        txtEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)exportOrderTransaction:(id)sender
{
    [self loadingOverlayView];
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    [self.homeModel downloadItems:dbReportOrderTransaction withData:@[startDate,endDate]];
    
}

- (IBAction)printReportEndDay:(id)sender
{
    [self loadingOverlayView];
//    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    [self.homeModel downloadItems:dbReportEndDay withData:@[endDate]];
}

- (void)loadView
{
    [super loadView];
    
    
    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
    _webview.delegate = self;

    
    
    
    
    _selectedIndexReportGroup = 0;
    _selectedIndexReportType = 0;
    _selectedIndexFrequency = 0;
    
    
    txtStartDate.text = [Utility dateToString:[Utility getPrevious14Days] toFormat:@"d MMM yyyy"];
    txtEndDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtStartDate.delegate = self;
    txtEndDate.delegate = self;
    txtStartDate.inputView = dtPicker;
    txtEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    
    [pickerVw removeFromSuperview];
    txtFrequency.delegate = self;
    txtFrequency.inputView = pickerVw;
    txtReportType.delegate = self;
    txtReportType.inputView = pickerVw;
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;

    
    
    _frequencyList = @[@"รายวัน",@"รายสัปดาห์",@"รายเดือน"];
    _reportTypeList = @[@"ยอดขายรวมทั้งหมด",@"ยอดขายตามหมวดอาหาร",@"ยอดขายตามรายการอาหาร",@"ยอดขายตามหมายเลขสมาชิก"];
    
    
    
    [self loadViewProcess];
    
}

- (void)loadViewProcess
{
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndexReportGroup inSection:0];
        [tbvReportNameList selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    {
        NSString *strFrequency = _frequencyList[_selectedIndexFrequency];
        txtFrequency.text = strFrequency;
    }
    
    {
        NSString *strReportType = _reportTypeList[_selectedIndexReportType];
        txtReportType.text = strReportType;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    if([txtFrequency isFirstResponder])
    {
        _selectedIndexFrequency = row;
        NSString *strFrequency = _frequencyList[row];
        txtFrequency.text = strFrequency;
        [txtFrequency resignFirstResponder];
    }
    else if([txtReportType isFirstResponder])
    {
        _selectedIndexReportType = row;
        NSString *strReportType = _reportTypeList[row];
        txtReportType.text = strReportType;
        [txtReportType resignFirstResponder];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([txtFrequency isFirstResponder])
    {
        return [_frequencyList count];
    }
    else if([txtReportType isFirstResponder])
    {
        return [_reportTypeList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *strText = @"";
    if([txtFrequency isFirstResponder])
    {
        strText = _frequencyList[row];
    }
    else if([txtReportType isFirstResponder])
    {
        strText = _reportTypeList[row];
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    //    int sectionWidth = 300;
    
    return self.view.frame.size.width;
}

-(void)sendParamToReportDetail
{
    UINavigationController *nav = self.splitViewController.viewControllers[1];
    CustomReportViewController *vc = (CustomReportViewController *)nav.topViewController;
    vc.startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    vc.endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    vc.frequency = _selectedIndexFrequency;
    vc.reportType = _selectedIndexReportType;
    vc.reportGroup = _selectedIndexReportGroup;
    
    
    [vc unwindToReportDetail];
    
}


-(void) exportCsv: (NSString*) filename
{
    [super exportCsv:filename];
    
    
    
    NSOutputStream* output = [[NSOutputStream alloc] initToFileAtPath: filename append: YES];
    [output open];
    if (![output hasSpaceAvailable]) {
        NSLog(@"No space available in %@", filename);
        // TODO: UIAlertView?
    }
    else
    {
        NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
        NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
        NSString *strStartDate = [Utility dateToString:startDate toFormat:@"d MMM yyyy"];
        NSString *strEndDate = [Utility dateToString:endDate toFormat:@"d MMM yyyy"];
        NSString *criteria = [NSString stringWithFormat:@"ช่วงเวลา: %@ to %@\n",strStartDate, strEndDate];
        NSString *header0 = @"วันที่,เวลา,ชั่วโมง,หมวดอาหาร,รายการอาหาร,จำนวน,รวมราคา(บาท)\n";
        NSString* header = [NSString stringWithFormat:@"%@%@",criteria,header0];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatinThai);
        NSData *data = [header dataUsingEncoding:encoding];
        NSInteger result = [output write:[data bytes] maxLength:[data length]];
        if (result <= 0) {
            NSLog(@"exportCsv encountered error=%ld from header write", (long)result);
        }
        
        BOOL errorLogged = NO;
        
        
        
        // Loop through the results and write them to the CSV file
        for(SalesTransaction *item in _salesTransactionList)
        {
            NSString *strDate = [Utility dateToString:item.receiptDate toFormat:@"dd/MM/yyyy"];
            NSString *strTime = [Utility dateToString:item.receiptDate toFormat:@"HH:mm"];
            NSString *strHour = [Utility dateToString:item.receiptDate toFormat:@"HH"];
            NSString *strMenuType = item.menuType;
            NSString *strMenu = item.menu;
            NSString *strQuantity = [NSString stringWithFormat:@"%f",item.quantity];
            NSString *strTotalAmount = [NSString stringWithFormat:@"%f",item.totalAmount];
            
            
            NSString* line = [[NSString alloc] initWithFormat: @"%@,%@,%@,%@,%@,%@,%@\n",strDate, strTime,strHour,strMenuType,strMenu,strQuantity,strTotalAmount];
            NSData *data = [line dataUsingEncoding:encoding];
            result = [output write:[data bytes] maxLength:[data length]];
            
            
            if (!errorLogged && (result <= 0)) {
                NSLog(@"exportCsv write returned %ld", (long)result);
                errorLogged = YES;
            }
        }
    }
    [output close];
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbReportOrderTransaction)
    {
        _salesTransactionList = items[0];
        
        
        [self removeOverlayViews];
        [self exportImpl:@"รายงานรายการสั่งอาหาร"];
    }
    else if(self.homeModel.propCurrentDB == dbReportEndDay)
    {
        _reportEndDayList = items[0];
        _saleAndDiscountList = items[1];
        _countReceiptAndServingPersonList = items[2];
        _cashAmountList = items[3];
        _creditCardAmountList = items[4];
        
        
        [self viewEndDay];
    }
}

-(void)viewEndDay
{
    [self loadingOverlayView];
    
    
    //prepare data to print main
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *endDay = txtEndDate.text;



    //create html invoice
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    NSString *invoiceHtml = [invoiceComposer renderReportEndDayWithRestaurantName:restaurantName endDayDate:endDay reportEndDayList:_reportEndDayList salesAndDiscountList:_saleAndDiscountList countReceiptAndServingPersonList:_countReceiptAndServingPersonList cashAmountList:_cashAmountList creditCardAmountList:_creditCardAmountList];
    
    
    
    //load into webview in order to calculate height of content to prepare pdf
    [_webview loadHTMLString:invoiceHtml baseURL:NULL];

}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:@"endday.pdf"];
    
    
    
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
        [self removeOverlayViews];
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
             [self removeOverlayViews];
         }
     }];
}

@end
