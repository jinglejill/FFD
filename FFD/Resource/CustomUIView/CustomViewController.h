//
//  CustomViewController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "Utility.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface CustomViewController : UIViewController<HomeModelProtocol,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIWebViewDelegate>
@property (nonatomic,retain) HomeModel *homeModel;
@property (nonatomic,retain) HomeModel *homeModelPushSyncUpdate;
@property (nonatomic,retain) HomeModel *homeModelPushSyncUpdateByDevice;
@property (nonatomic,retain) HomeModel *homeModelPrintKitchenBill;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UIView *overlayView;
@property (nonatomic) NSInteger receiptKitchenBill;
@property (nonatomic,retain) UILabel *lblAlertMsg;


-(void) blinkAlertMsg:(NSString *)alertMsg;
-(void)setCurrentVc;
-(void)loadingOverlayView;
-(void)removeOverlayViews;
-(void)connectionFail;
-(void)itemsFail;
-(void)itemsInserted;
-(void)itemsUpdated;
-(void) showAlert:(NSString *)title message:(NSString *)message;
-(void) showAlert:(NSString *)title message:(NSString *)message method:(SEL)method;
-(void)vibrateAndCallPushSync;
-(void)showAlertAndCallPushSync:(NSString *)title message:(NSString *)message;
-(void) showAlert:(NSString *)title message:(NSString *)message firstResponder:(UIView *)view;
-(void)loadViewProcess;
-(void)setShadow:(UIView *)view;
-(void)setShadow:(UIView *)view radius:(NSInteger)radius;
-(void)setButtonDesign:(UIView *)view;
-(void)setCornerAndShadow:(UIView *)view cornerRadius:(NSInteger)cornerRadius;
-(CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode forString:(NSString *)text;
-(void)setImageAndTitleCenter:(UIButton *)button;
-(UIImage *)pdfToImage:(NSURL *)sourcePDFUrl;
-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName;
- (void) exportImpl:(NSString *)reportName;
-(void) exportCsv: (NSString*) filename;
-(void)openCashDrawer;
-(void)makeBottomRightRoundedCorner:(UIView *)view;
-(void)showStatus:(NSString *)status;
-(void)hideStatus;
- (void)syncItems;
-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
-(BOOL)inPeriod:(NSInteger)period;
-(NSString*) deviceName;
-(void)printReceiptKitchenBill:(NSMutableArray *)receiptList;
-(NSAttributedString *)setAttributedString:(NSString *)title text:(NSString *)text;
-(void)reloadTableView;
@end
