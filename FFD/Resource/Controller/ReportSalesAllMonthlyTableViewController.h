//
//  ReportSalesAllMonthlyTableViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/8/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"

@interface ReportSalesAllMonthlyTableViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwData;
@property (strong, nonatomic) IBOutlet UIButton *btnGraphView;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;


- (IBAction)showGraphView:(id)sender;
- (IBAction)exportData:(id)sender;

@end
