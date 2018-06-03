//
//  ReportSalesByMenuTypeDailyTableViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"



@interface ReportSalesByMenuTypeDailyTableViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwData;
@property (strong, nonatomic) IBOutlet UIButton *btnGraphView;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;
@property (strong, nonatomic) IBOutlet UIButton *btnPercent;


- (IBAction)showGraphView:(id)sender;
- (IBAction)exportData:(id)sender;
- (IBAction)showPercent:(id)sender;


@end
