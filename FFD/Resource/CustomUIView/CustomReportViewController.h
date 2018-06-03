//
//  CustomReportViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CPDConstants.h"
#import "CPDStockPriceStore.h"
#import "CPTGraphHostingView.h"
#import "CPTTheme.h"


@interface CustomReportViewController : CustomViewController<CPTBarPlotDataSource, CPTBarPlotDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) enum reportView reportView;
@property (nonatomic) enum frequency frequency;
@property (nonatomic) enum reportType reportType;
@property (nonatomic) enum reportGroup reportGroup;

- (void)unwindToReportDetail;
@end
