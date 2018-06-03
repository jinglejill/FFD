//
//  ReportSalesByMenuTableViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"

@interface ReportSalesByMenuTableViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwData;
@property (strong, nonatomic) IBOutlet UIButton *btnGraphView;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;
@property (strong, nonatomic) IBOutlet UIButton *btnPercent;
@property (strong, nonatomic) IBOutlet UIButton *btnSortValue;



- (IBAction)showGraphView:(id)sender;
- (IBAction)exportData:(id)sender;
- (IBAction)showPercent:(id)sender;
- (IBAction)sortValue:(id)sender;

@end
