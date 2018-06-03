//
//  ReportSalesByMenuTypeMonthlyGraphViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/8/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"

@interface ReportSalesByMenuTypeMonthlyGraphViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UIButton *btnTableView;
- (IBAction)showTableView:(id)sender;
@end
