//
//  CustomViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "LogInViewController.h"
#import "OrderTakingViewController.h"
#import "ReceiptViewController.h"
#import "CustomerTableViewController.h"
#import "CustomerKitchenViewController.h"

#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"
#import "Setting.h"
#import "Receipt.h"
#import "ReceiptPrint.h"
#import "OrderNote.h"
#import "OrderTaking.h"
#import "OrderKitchen.h"
#import "Menu.h"
#import "MenuType.h"
#import "Printer.h"
#import "CredentialsDb.h"



#import <AudioToolbox/AudioToolbox.h>
#import <sys/utsname.h>
#import "InvoiceComposer.h"



//cash drawer
#import "CashDrawerFunctions.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"


@interface CustomViewController ()
{
    UILabel *_lblStatus;
    
    
    //print kitchen
    NSMutableArray *_webViewList;
    UIView *_backgroundView;
    NSMutableArray *_arrOfHtmlContentList;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
    NSMutableArray *_statusCellArray;
    NSMutableArray *_firmwareInfoCellArray;
    
    HomeModel *_homeModelSyncItems;
    
    
}
@end

@implementation CustomViewController
CGFloat animatedDistance;



@synthesize homeModel;
@synthesize homeModelPushSyncUpdate;
@synthesize homeModelPushSyncUpdateByDevice;
@synthesize homeModelPrintKitchenBill;
@synthesize indicator;
@synthesize overlayView;
@synthesize receiptKitchenBill;
@synthesize lblAlertMsg;


-(void) blinkAlertMsg:(NSString *)alertMsg
{
    lblAlertMsg.text = alertMsg;
    lblAlertMsg.backgroundColor = [UIColor darkGrayColor];
    lblAlertMsg.textColor = [UIColor whiteColor];
    lblAlertMsg.textAlignment = NSTextAlignmentCenter;
    lblAlertMsg.layer.cornerRadius = 8;
    lblAlertMsg.layer.masksToBounds = YES;
    lblAlertMsg.alpha = 1;
    [self.view addSubview:lblAlertMsg];
    
    
    
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [UIView animateWithDuration:0.5
                                        animations:^{
                                            lblAlertMsg.alpha = 0.0;
                                        }
                                        completion:^(BOOL finished){
                                            dispatch_async(dispatch_get_main_queue(),^ {
                                                [lblAlertMsg removeFromSuperview];
                                            } );
                                        }
                        ];
                   });
}

-(void)setCurrentVc
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.vc = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [self setCurrentVc];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
}

- (void)loadView
{
    [super loadView];
    
    
    [self setCurrentVc];
    homeModel = [[HomeModel alloc]init];
    homeModel.delegate = self;
    homeModelPushSyncUpdate = [[HomeModel alloc]init];
    homeModelPushSyncUpdate.delegate = self;
    _homeModelSyncItems = [[HomeModel alloc]init];
    _homeModelSyncItems.delegate = self;
    homeModelPushSyncUpdateByDevice = [[HomeModel alloc]init];
    homeModelPushSyncUpdateByDevice.delegate = self;
    homeModelPrintKitchenBill = [[HomeModel alloc]init];
    homeModelPrintKitchenBill.delegate = self;
    
    {
        overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];

        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.view.bounds.size.width/2-indicator.frame.size.width/2,self.view.bounds.size.height/2-indicator.frame.size.height/2,indicator.frame.size.width,indicator.frame.size.height);        
    }
    
    
    _lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    
    
    
    
    //print kitchen
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webViewList = [[NSMutableArray alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];

}

-(void) loadingOverlayView
{
    [indicator startAnimating];
    indicator.alpha = 1;
    overlayView.alpha = 1;
    indicator.layer.zPosition = 1;
    
    
    // and just add them to navigationbar view
    [self.view addSubview:overlayView];
    [self.view addSubview:indicator];
}

-(void) removeOverlayViews{
    UIView *view = overlayView;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.alpha = 0.0;
                         indicator.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(),^ {
                             [view removeFromSuperview];
                             [indicator stopAnimating];
                             [indicator removeFromSuperview];
                         } );
                     }
     ];
}

- (void) connectionFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility subjectNoConnection]
                                                                   message:[Utility detailNoConnection]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                            {
                                                                if(![indicator isAnimating])
                                                                {
                                                                    [self loadingOverlayView];
                                                                }
                                                                [homeModel downloadItems:dbMaster];
                                                            }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getConnectionLostTitle]
                                                                   message:[Utility getConnectionLostMessage]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if(![indicator isAnimating])
                                                              {
                                                                  [self loadingOverlayView];
                                                              }
                                                              [homeModel downloadItems:dbMaster];
                                                          }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsInserted
{
}

- (void)itemsUpdated
{

}

- (void)syncItems
{
    PushSync *pushSync = [[PushSync alloc]init];
    pushSync.deviceToken = [Utility deviceToken];
    [_homeModelSyncItems syncItems:dbPushSync withData:pushSync];
}

- (void) showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                            {
                                                            }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showAlert:(NSString *)title message:(NSString *)message method:(SEL)method
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self performSelector:method withObject:self afterDelay: 0.0];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)vibrateAndCallPushSync
{
    [self loadingOverlayView];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    
    [self syncItems];
}

- (void) showAlertAndCallPushSync:(NSString *)title message:(NSString *)message
{
    [self loadingOverlayView];
    [self syncItems];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showAlert:(NSString *)title message:(NSString *)message firstResponder:(UIView *)view
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [view becomeFirstResponder];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)itemsSynced:(NSArray *)items
{
    if([items count] == 0)
    {
        [self removeOverlayViews];
        return;
    }
    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
    
    
    
    //type == exit
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        
        
        if([type isEqualToString:@"exitApp"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"มีการปรับปรุงแอพ"
                                                                           message:@"กรุณาเปิดแอพใหม่อีกครั้งเพื่อใช้งาน"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                exit(0);
                                            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
    //type == alert
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        if([type isEqualToString:@"alert"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            
            
            NSString *alertMsg = [NSString stringWithFormat:@"%@ is fail",(NSString *)data];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getSqlFailTitle]
                                                                           message:alertMsg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [self loadingOverlayView];
                                                [homeModel downloadItems:dbMaster];
                                            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
    //type == usernameconflict
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        if([type isEqualToString:@"usernameconflict"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            

            //you have login in another device และ unwind to หน้า sign in
            if(![self isMemberOfClass:[LogInViewController class]])
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"Username นี้กำลังถูกใช้เข้าระบบที่เครื่องอื่น"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
                                                    [UIApplication sharedApplication].keyWindow.rootViewController = logInViewController;
                                                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    
    
    
    
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *action = [payload objectForKey:@"action"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
        if([PushSync alreadySynced:[strPushSyncID integerValue]])
        {
            continue;
        }
        else
        {
            //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
            PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
            [PushSync addObject:pushSync];
            [pushSyncList addObject:pushSync];
        }
        
        

        if([data isKindOfClass:[NSArray class]])
        {
            [Utility itemsSynced:type action:action data:data];
        }
    }
    
    
    //update pushsync ที่ sync แล้ว
    if([pushSyncList count]>0)
    {
        [homeModelPushSyncUpdate updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time by id"];
    }
    
    
    //ให้ refresh ข้อมูลที่ Show ที่หน้านั้นหลังจาก sync ข้อมูลมาใหม่ //ใส่ทุกหน้าในนี้
    NSMutableArray *arrAllType = [[NSMutableArray alloc]init];
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        [arrAllType addObject:type];
    }
    if([items count] > 0)
    {
        //ใส่ทุกหน้าในนี้
        BOOL loadViewProcess = NO;
        NSArray *arrReferenceTable;
        if([self isMemberOfClass:[OrderTakingViewController class]])
        {
            arrReferenceTable = @[@"MenuType",@"Menu",@"TableTaking",@"CustomerTable",@"OrderTaking",@"MenuTypeNote",@"OrderNote"];
            loadViewProcess = NO;
        }
        else if([self isMemberOfClass:[ReceiptViewController class]])
        {
            arrReferenceTable = @[@"OrderTaking",@"Menu",@"OrderNote",@"Member",@"Address",@"Receipt",@"Discount",@"Setting",@"UserAccount",@"RewardProgram",@"RewardPoint",@"ReceiptNo",@"ReceiptNoTax",@"ReceiptCustomerTable",@"TableTaking"];
            loadViewProcess = YES;
        }
        else if([self isMemberOfClass:[CustomerTableViewController class]])
        {
            arrReferenceTable = @[@"UserAccount",@"UserAccount",@"TableTaking",@"OrderTaking",@"UserTabMenu",@"Board"];
            loadViewProcess = YES;
        }
        else if([self isMemberOfClass:[CustomerKitchenViewController class]])
        {
            arrReferenceTable = @[@"OrderTaking",@"Receipt",@"OrderNote",@"PrintReceipt"];
            loadViewProcess = YES;
        }
        NSArray *resultArray = [Utility intersectArray1:arrAllType array2:arrReferenceTable];
        if([resultArray count] > 0)
        {
            //                [self loadingOverlayView];
            if(loadViewProcess)
            {
                [self loadViewProcess];
            }
//            [self removeOverlayViews];
        }
    }
    [self removeOverlayViews];
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(homeModel.propCurrentDB == dbMaster || homeModel.propCurrentDB == dbMasterWithProgressBar)
    {
        PushSync *pushSync = [[PushSync alloc]init];
        pushSync.deviceToken = [Utility deviceToken];
        [homeModelPushSyncUpdateByDevice updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"Update synced time by device token"];
        
        
        [Utility itemsDownloaded:items];
        [self removeOverlayViews];
        [self loadViewProcess];//call child process
    }
}

-(void)loadViewProcess
{

}

-(void)setShadow:(UIView *)view
{
    [self setShadow:view radius:2];
}

-(void)setShadow:(UIView *)view radius:(NSInteger)radius
{
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, radius);
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;
}

-(void)setButtonDesign:(UIView *)view
{
    UIButton *button = (UIButton *)view;
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [button setTitleColor:mBlueColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    button.layer.cornerRadius = 4;
    
}

-(void)setCornerAndShadow:(UIView *)view cornerRadius:(NSInteger)cornerRadius
{
    view.layer.cornerRadius = cornerRadius;
    [self setShadow:view];
}

-(CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode forString:(NSString *)text
{
    if(!text)
    {
        text = @"";
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font,       NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect bounds = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return bounds.size;
}

- (void)setImageAndTitleCenter:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

-(UIImage *)pdfToImage:(NSURL *)sourcePDFUrl
{
    CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourcePDFUrl);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    
    for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
    {
        CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
        // CoreGraphics: MUST retain the Page-Refernce manually
        CGPDFPageRetain(SourcePDFPage);
        
        
        CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage,kCGPDFMediaBox);
        UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width,sourceRect.size.height));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height); //596,842 //640×960,
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context
        
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    return nil;
}

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
//    {     // 10000mS!!!
//        if(![message isEqualToString:@"พิมพ์สำเร็จ"])
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//            alertView.tag = 22;
//            alertView.delegate = self;
//            [alertView show];
//        }
//    }];
//}

- (void) exportImpl:(NSString *)reportName
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *csvFileName = [NSString stringWithFormat:@"%@.csv",reportName];
    NSString *csvPath = [documentsDir stringByAppendingPathComponent:csvFileName];
    
    
    [self exportCsv: csvPath];
    
    
    // mail is graphical and must be run on UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mail:csvPath mailSubject:reportName];
    });
}

- (void) mail: (NSString*) filePath mailSubject:(NSString *)mailSubject
{
    [self removeOverlayViews];
    BOOL success = NO;
    if ([MFMailComposeViewController canSendMail]) {
        // TODO: autorelease pool needed ?
        NSData* database = [NSData dataWithContentsOfFile: filePath];
        
        if (database != nil) {
            MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:mailSubject];
            
            NSString* filename = [filePath lastPathComponent];
            [picker addAttachmentData: database mimeType:@"application/octet-stream" fileName: filename];
            NSString* emailBody = @"";
            [picker setMessageBody:emailBody isHTML:YES];
            
            
            [self presentViewController:picker animated:YES completion:nil];
            success = YES;
        }
    }
    
    if (!success)
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Unable to send attachment!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) exportCsv: (NSString*) filename
{
    [self createTempFile: filename];
}

-(void) createTempFile: (NSString*) filename {
    NSFileManager* fileSystem = [NSFileManager defaultManager];
    [fileSystem removeItemAtPath: filename error: nil];
    
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    NSNumber* permission = [NSNumber numberWithLong: 0640];
    [attributes setObject: permission forKey: NSFilePosixPermissions];
    if (![fileSystem createFileAtPath: filename contents: nil attributes: attributes]) {
        NSLog(@"Unable to create temp file for exporting CSV.");
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
        // TODO: UIAlertView?
    }
}

- (void) orientationChanged:(NSNotification *)note
{  
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

-(void)openCashDrawer
{
    //open drawer
    NSString *openCashDrawer = [Setting getSettingValueWithKeyName:@"openCashDrawer"];
    if([openCashDrawer integerValue])
    {
        NSString *portName = [Setting getSettingValueWithKeyName:@"printerPortCashier"];
        NSString *portSettings = [AppDelegate getPortSettings];
        NSData *commands = [CashDrawerFunctions createData:[AppDelegate getEmulation] channel:SCBPeripheralChannelNo1];
        [Communication sendCommandsDoNotCheckCondition:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message)
         {
             if(![message isEqualToString:@"Success"])
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 [alertView show];
             }
         }];
    }
}

-(void)makeBottomRightRoundedCorner:(UIView *)view
{
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(100.0, 100.0)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}

-(void)showStatus:(NSString *)status
{
    [_lblStatus setFont:[UIFont systemFontOfSize:14]];
    [_lblStatus setText:@"กำลังพิมพ์..."];
    [_lblStatus sizeToFit];
    _lblStatus.center = self.view.center;
    CGRect frame = _lblStatus.frame;
    frame.origin.y = frame.origin.y+40;
    _lblStatus.frame = frame;
    
    
    
    
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_lblStatus];
}

-(void)hideStatus
{
    overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];
    [_lblStatus removeFromSuperview];
}

-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    UIWebView *webView = (UIWebView*)aView;
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    CGRect frameTest = webView.frame;
    frameTest.size.height = [heightStr integerValue];
    webView.frame = frameTest;
    
    
    int height = [heightStr intValue];
    //  CGRect screenRect = [[UIScreen mainScreen] bounds];
    //  CGFloat screenHeight = (self.contentWebView.hidden)?screenRect.size.width:screenRect.size.height;
    CGFloat screenHeight = webView.bounds.size.height;
    int pages = ceil(height / screenHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, webView.bounds, nil);
    CGRect frame = [webView frame];
    for (int i = 0; i < pages; i++) {
        // Check to screenHeight if page draws more than the height of the UIWebView
        if ((i+1) * screenHeight  > height) {
            CGRect f = [webView frame];
            f.size.height -= (((i+1) * screenHeight) - height);
            [webView setFrame: f];
        }
        
        UIGraphicsBeginPDFPage();
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        //      CGContextTranslateCTM(currentContext, 72, 72); // Translate for 1" margins
        
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, screenHeight * i) animated:NO];
        [webView.layer renderInContext:currentContext];
    }
    
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    [webView setFrame:frame];
    
    
    
    return documentDirectoryFilename;
    //    [self removeOverlayViews];
}

-(BOOL)inPeriod:(NSInteger)period
{
    NSString *strKeyNameOpen = [NSString stringWithFormat:@"shift%ldOpenTime",period];
    NSString *strKeyNameClose = [NSString stringWithFormat:@"shift%ldCloseTime",period];
    
    NSString *strShiftOpenTime = [Setting getSettingValueWithKeyName:strKeyNameOpen];
    NSString *strShiftCloseTime = [Setting getSettingValueWithKeyName:strKeyNameClose];
    
    NSInteger intShiftOpenTime = [[strShiftOpenTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSInteger intShiftCloseTime = [[strShiftCloseTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSDate *dtShiftOpenTime;
    NSDate *dtShiftCloseTime;
    NSDate *dtShiftOpenTimeMinus30Min;
    NSDate *dtStartNextDay;
    if(intShiftOpenTime <= intShiftCloseTime)
    {
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
    }
    else
    {
        NSDate *currentDate = [Utility currentDateTime];
        NSDate *nextDay = [Utility getPreviousOrNextDay:1];
        NSDate *yesterday = [Utility getPreviousOrNextDay:-1];
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        NSString *strNextDay = [Utility dateToString:nextDay toFormat:@"yyyy/MM/dd"];
        NSString *strYesterday = [Utility dateToString:yesterday toFormat:@"yyyy/MM/dd"];
        dtStartNextDay = [Utility setStartOfTheDay:nextDay];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
        NSComparisonResult result = [dtShiftOpenTimeMinus30Min compare:currentDate];
        NSComparisonResult result2 = [currentDate compare:dtStartNextDay];
        BOOL compareResult = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
        if(compareResult)
        {
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strNextDay,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
        else
        {
            dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strYesterday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
            dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
    }
    NSDate *currentDate = [Utility currentDateTime];
    NSComparisonResult result = [dtShiftOpenTimeMinus30Min compare:currentDate];
    NSComparisonResult result2 = [currentDate compare:dtShiftCloseTime];
    BOOL compareResult = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
    
    return compareResult;
}

-(NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"iOSDeviceModelMapping" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    return [iOSDevices valueForKey:deviceModel];
}


///print kitchen bill-----------------------------
-(void)printReceiptKitchenBill:(NSMutableArray *)receiptList
{
    //print customer kitchen ต่างจาก print kitchen FFD 2 จุด คือ 1.print ทีเดียวหลายโต๊ะ 2.ordertaking จาก jummum จะเป็น order ละ 1 รายการ(FFD จะตามจำนวนรายการที่สั่งพร้อมกัน)
//    if(![self checkPrinterStatus])
//    {
//        return;
//    }
    
    receiptKitchenBill = 1;
    NSMutableArray *receiptPrintList = [[NSMutableArray alloc]init];
    for(Receipt *item in receiptList)
    {
        item.status = 5;
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
        
        ReceiptPrint *receiptPrint = [[ReceiptPrint alloc]initWithReceiptID:item.receiptID];
        [ReceiptPrint addObject:receiptPrint];
        [receiptPrintList addObject:receiptPrint];
    }
    
    [homeModelPrintKitchenBill insertItems:dbReceiptPrintList withData:receiptPrintList actionScreen:@"insert receiptPrintList in customerKitchen screen"];
    
    
    
    _countPrint = 0;
    _countingPrint = 0;
    _arrOfHtmlContentList = [[NSMutableArray alloc]init];
    _printBillWithPortName = [[NSMutableDictionary alloc]init];
    NSMutableArray *arrPrintDic = [[NSMutableArray alloc]init];
    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
    
    
    
    
    
    for(Receipt *item in receiptList)
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:item.receiptID branchID:[Utility branchID]];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
        for(OrderTaking *orderTaking in orderTakingList)
        {
            OrderKitchen *orderKitchen = [[OrderKitchen alloc]initWithCustomerTableID:orderTaking.customerTableID orderTakingID:orderTaking.orderTakingID sequenceNo:1 customerTableIDOrder:0];
            orderKitchen.quantity = orderTaking.quantity;
            [orderKitchenList addObject:orderKitchen];
        }
        
        
        
        //foodCheckList
        NSInteger printFoodCheckList = [[Setting getSettingValueWithKeyName:@"printFoodCheckList"] integerValue];
        NSInteger printerID = [[Setting getSettingValueWithKeyName:@"foodCheckList"] integerValue];
        if(printFoodCheckList && printerID)
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
                Printer *printer = [Printer getPrinter:printerID];
                NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
                [printDic setValue:printOrderKitchenList forKey:printer.portName];
                [arrPrintDic addObject:printDic];
            }
        }
        
        
        
        //printerKitchenMenuTypeID
        NSMutableArray *printerList = [Printer getPrinterList];
        for(int i=0; i<[printerList count]; i++)
        {
            Printer *printer = printerList[i];
            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
            NSString *printerKitchenMenuTypeID = printer.menuTypeIDListInText;
            NSArray* menuTypeIDList = [printerKitchenMenuTypeID componentsSeparatedByString: @","];
            for(NSString *item in menuTypeIDList)
            {
                NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
                
                if(printOrderKitchenByItem)
                {
                    for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
                    {
                        
                        OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
                        NSInteger quantity = orderKitchen.quantity == 0?orderTaking.quantity:orderKitchen.quantity;
                        for(int i=0; i<quantity; i++)
                        {
                            NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
                            [orderKitchenList addObject:orderKitchen];
                            [printOrderKitchenList addObject:orderKitchenList];
                        }
                    }
                }
                else if(!printOrderKitchenByItem && [orderKitchenMenuTypeIDList count]>0)
                {
                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
                }
            }
            if([printOrderKitchenList count]>0)
            {
                _countPrint = _countPrint+[printOrderKitchenList count];
                NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
                [printDic setValue:printOrderKitchenList forKey:printer.portName];
                [arrPrintDic addObject:printDic];
            }
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
    for(NSMutableDictionary *printDic in arrPrintDic)
    {
        for(NSString *key in printDic)//printDic คือตัวเครื่องพิมพ์
        {
            NSMutableArray *printOrderKitchenList = [printDic objectForKey:key];
            for(NSMutableArray *orderKitchenMenuTypeIDList in printOrderKitchenList)
            {
                [_printBillWithPortName setValue:key forKey:[NSString stringWithFormat:@"%d",i]];
                if([key isEqualToString:@"foodCheckList"])//foodCheckList คือรวมทุกรายการในบิลเดียว หัวบิลแสดงคำว่าทั้งหมด, ถ้าไม่ใช่คือพิมพ์ 1 ที่ต่อ 1 บิล หัวบิลแสดงหมวดอาหารรายการนั้น
                {
                    [self printKitchenBillInCustomView:orderKitchenMenuTypeIDList orderNo:i foodCheckList:YES];
                }
                else
                {
                    [self printKitchenBillInCustomView:orderKitchenMenuTypeIDList orderNo:i foodCheckList:NO];
                }
                i++;
            }
        }
    }
}

-(void)printKitchenBillInCustomView:(NSMutableArray *)orderKitchenList orderNo:(NSInteger)orderNo foodCheckList:(BOOL)foodCheckList
{
    //prepare data to print
    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
    OrderKitchen *orderKitchen = orderKitchenList[0];
    OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
    CustomerTable *customerTable = [CustomerTable getCustomerTable:orderKitchen.customerTableID];
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *customerType = customerTable.tableName;
    NSString *waiterName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *strMenuType = foodCheckList?@"ทั้งหมด":menuType.name;
    NSString *sequenceNo = [NSString stringWithFormat:@"%ld",orderKitchen.sequenceNo];
    NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"yyyy-MM-dd HH:mm"];
    
    
    
    
    //items
    float sumQuantity = 0;
    float quantity = 0;
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for(OrderKitchen *item in orderKitchenList)
    {
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        
        OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
        quantity = orderKitchen.quantity == 0?orderTaking.quantity:orderKitchen.quantity;
        NSString *strQuantity = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        
        
        if(printOrderKitchenByItem)
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
        
        sumQuantity += quantity;
    }
    if(printOrderKitchenByItem)
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
    if(receiptKitchenBill)
    {
        _countingPrint++;
        NSString *strFileName = [NSString stringWithFormat:@"kitchenBill%ld.pdf",aWebView.tag];
        NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:strFileName];
        
        
        
        
        //convert pdf to uiimage
        NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
        UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
        UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
        
        
        NSLog(@"path: %@",pdfFileName);
        //        //TEST
        //        [self removeOverlayViews];
        //        return;
        
        
        NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
        if(![printBill integerValue])
        {
            if(_countingPrint == _countPrint)
            {
//                [self hideStatus];
                [self removeOverlayViews];
                [self reloadTableView];
//                [self loadViewProcess];
                //            [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
            }
        }
        else
        {
            //print process
            NSString *portName = [_printBillWithPortName valueForKey:[NSString stringWithFormat:@"%ld",(long)aWebView.tag]];
            [self doPrintProcess:pdfImagePrint portName:portName];
        }
    }
}

-(void)doPrintProcessInCustomView:(UIImage *)image portName:(NSString *)portName
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
                                                 if(_countingPrint == _countPrint)
                                                 {
                                                     [self hideStatus];
                                                     [self removeOverlayViews];
//                                                     [self loadViewProcess];
                                                     //                                                     [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
                                                 }
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
                 [self reloadTableView];
                 
                 //update receipt status
//                 [self loadViewProcess];
                 //                 [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
             }
         }
     }];
}

-(BOOL)checkPrinterStatus
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

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fail to Open Port"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            
                                        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    [self removeOverlayViews];
    return result;
}
//\\\\\print kitchen bill-----------------------------

-(NSAttributedString *)setAttributedString:(NSString *)title text:(NSString *)text
{
    if(!text || [text isEqualToString:@"0"])
    {
        text = @"";
    }
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title attributes:attribute];
    
    
    UIFont *font2 = [UIFont systemFontOfSize:15];
    UIColor *color2 = [UIColor darkGrayColor];
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:text attributes:attribute2];
    
    
    [attrString appendAttributedString:attrString2];
    
    return attrString;
}

-(void)reloadTableView
{
    
}
@end
