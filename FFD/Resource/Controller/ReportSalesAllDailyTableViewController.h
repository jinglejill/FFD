//
//  ReportSalesAllDailyTableViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"

@interface ReportSalesAllDailyTableViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwData;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwSummary;
@property (strong, nonatomic) IBOutlet UIButton *btnGraphView;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;


- (IBAction)showGraphView:(id)sender;
- (IBAction)exportData:(id)sender;




@end
