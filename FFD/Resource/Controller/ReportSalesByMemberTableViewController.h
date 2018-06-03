//
//  ReportSalesByMemberTableViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomReportViewController.h"

@interface ReportSalesByMemberTableViewController : CustomReportViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwData;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwSummary;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;




- (IBAction)exportData:(id)sender;
@end
