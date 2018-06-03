//
//  ReportListViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportDetailViewController.h"


@interface ReportListViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbvReportNameList;

@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtEndDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblFrequency;
@property (strong, nonatomic) IBOutlet UITextField *txtFrequency;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
@property (strong, nonatomic) IBOutlet UITextField *txtReportType;
@property (strong, nonatomic) IBOutlet UILabel *lblReportType;

- (IBAction)datePickerChanged:(id)sender;
- (IBAction)exportOrderTransaction:(id)sender;
- (IBAction)printReportEndDay:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnExportOrderTransaction;
@property (strong, nonatomic) IBOutlet UIButton *btnReportEndDay;
@end
