//
//  ReportDetailViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CPDConstants.h"
#import "CPDStockPriceStore.h"
#import "CPTGraphHostingView.h"
#import "CPTTheme.h"



@interface ReportDetailViewController : CustomViewController<UITextFieldDelegate,CPTBarPlotDataSource, CPTBarPlotDelegate>//CALayerDelegate
@property (strong, nonatomic) IBOutlet UIButton *btnListOrGraph;
@property (strong, nonatomic) IBOutlet UIButton *btnExportData;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) NSInteger frequencyCriteria;



- (IBAction)viewInListOrGraph:(id)sender;
- (IBAction)exportData:(id)sender;




@end
