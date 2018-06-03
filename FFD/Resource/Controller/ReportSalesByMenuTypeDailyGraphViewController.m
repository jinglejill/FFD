//
//  ReportSalesByMenuTypeDailyGraphViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportSalesByMenuTypeDailyGraphViewController.h"
#import "SalesDaily.h"
#import "SalesByItemData.h"
#import "MenuType.h"




@interface ReportSalesByMenuTypeDailyGraphViewController ()
{
    NSMutableArray *_salesDailyList;
    NSMutableArray *_salesByItemDataList;
    NSMutableArray *_menuTypeList;
    NSArray *_barPlotList;
    NSInteger _dataCount;
}
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *salesByItemPlot;
@property (nonatomic, strong) NSMutableArray *arrValueAnnotation;
@property (nonatomic, strong) NSMutableArray *arrLabelAnnotation;
@property (nonatomic, strong) NSMutableArray *arrLabelAnnotation2;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
@end

@implementation ReportSalesByMenuTypeDailyGraphViewController
@synthesize btnTableView;
@synthesize hostView;
@synthesize salesByItemPlot;
@synthesize arrValueAnnotation;
@synthesize arrLabelAnnotation;
@synthesize arrLabelAnnotation2;
@synthesize startDate;
@synthesize endDate;
@synthesize reportView;
@synthesize frequency;
@synthesize reportType;
@synthesize reportGroup;


- (void)unwindToReportDetail
{
    reportView = reportViewGraph;
    [self performSegueWithIdentifier:@"segUnwindToReportDetail" sender:self];
}

- (IBAction)showTableView:(id)sender
{
    reportView = reportViewTable;
    [self performSegueWithIdentifier:@"segUnwindToReportDetail" sender:self];
}

- (void)loadView
{
    [super loadView];
    
    
    _salesDailyList = [[NSMutableArray alloc]init];
    _salesByItemDataList = [[NSMutableArray alloc]init];
    _menuTypeList = [[NSMutableArray alloc]init];
    [self setButtonDesign:btnTableView];
    [self loadViewProcess];
    
}

- (void)loadViewProcess
{
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    

    
    [self.homeModel downloadItems:dbReportSalesByMenuTypeDaily withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    
    if(self.homeModel.propCurrentDB == dbReportSalesByMenuTypeDaily)
    {
        _salesDailyList = [items[0] mutableCopy];
        
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self removeOverlayViews];
            [self setData];
            [self initPlot];
        } );
    }
}

-(void)setData
{
    [_salesByItemDataList removeAllObjects];
    
    
    NSDate *previousSalesDate = nil;
    for(SalesDaily *item in _salesDailyList)
    {
        if(![previousSalesDate isEqual:item.salesDate])
        {
            SalesByItemData *salesByItem = [[SalesByItemData alloc]init];
            salesByItem.item = [Utility dateToString:item.salesDate toFormat:@"d-MMM"];
            salesByItem.item2 = [Utility getDay:item.dayOfWeek];
            salesByItem.salesDate = item.salesDate;
            [_salesByItemDataList addObject:salesByItem];
            previousSalesDate = item.salesDate;
        }
    }
    
    
    
    
    NSSet *menuTypeIDSet = [NSSet setWithArray:[_salesDailyList valueForKey:@"_menuTypeID"]];
    [_menuTypeList removeAllObjects];
    for(NSNumber *item in menuTypeIDSet)
    {
        MenuType *menuType = [MenuType getMenuType:[item integerValue]];
        [_menuTypeList addObject:menuType];
    }
    _menuTypeList = [MenuType sort:_menuTypeList];
    
    
    
    _dataCount = [_salesByItemDataList count];
    _dataCount = _dataCount>15?15:_dataCount;
}

#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self configureLegend];
}

-(void)configureGraph
{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingBottom = 38.0f;
    graph.paddingLeft  = 13.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = 13.0f;
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 14.0f;
    // 4 - Set up title
    NSString *title = @"ยอดขายตามหมวดรายการอาหารรายวัน";//@"Sales by Channel";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = _dataCount;
    CGFloat yMin = 0.0f;
    
    
    float maxValue = [self getMaxValue];
    CGFloat yMax = maxValue*1.5;// should determine dynamically based on max price
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots
{

    // 1 - Set up the three plots
    NSMutableArray *barPlotArr = [[NSMutableArray alloc]init];
    for(MenuType *item in _menuTypeList)
    {
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:item.color]);
        CPTColor *cptColor = [CPTColor colorWithCGColor:color.CGColor];
        CPTBarPlot *barPlot = [[CPTBarPlot alloc]init];
        barPlot.fill =  [CPTFill fillWithColor:cptColor];
        barPlot.identifier = [NSString stringWithFormat:@"%ld",item.menuTypeID];
        barPlot.title = item.name;
        [barPlotArr addObject:barPlot];
        
    }
    
    
    // 2 - Set up line style
    CPTColor *cptColor = [CPTColor colorWithComponentRed:0/255.0 green:123/255.0 blue:255/255.0 alpha:0];
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = cptColor;
    barLineStyle.lineWidth = 0.5;
    
    
    
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = barPlotArr;
    _barPlotList = barPlotArr;
    BOOL firstPlot = YES;
    for (CPTBarPlot *plot in plots)
    {
        if(firstPlot)
        {
            plot.barBasesVary = NO;
        }
        else
        {
            plot.barBasesVary = YES;
        }
        
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        //            plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        
        
        
        //initial annotation for value
        if(_dataCount>0)
        {
            arrValueAnnotation = [[NSMutableArray alloc]init];
            for(int index=0; index<_dataCount; index++)
            {
                NSNumber *x = [NSNumber numberWithInt:0];
                NSNumber *y = [NSNumber numberWithInt:0];
                NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
                CPTPlotSpaceAnnotation *priceAnnotation = (CPTPlotSpaceAnnotation*)[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
                
                [arrValueAnnotation addObject:priceAnnotation];
            }
        }
        
        //annotation for value
        for(int index=0; index<_dataCount; index++)
        {
            // 1 - Is the plot hidden?
            if (plot.isHidden == YES) {
                return;
            }
            // 2 - Create style, if necessary
            static CPTMutableTextStyle *style = nil;
            if (!style) {
                style = [CPTMutableTextStyle textStyle];
                CPTColor *cptColor = [CPTColor blackColor];
                style.color= cptColor;
                style.fontSize = 12.0f;
                style.fontName = @"HelveticaNeue-Medium";
            }
//                            // 3 - Create annotation, if necessary
//                            NSNumber *value = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
//                            CPTPlotSpaceAnnotation *priceAnnotation = self.arrValueAnnotation[index];
//            
//            
//                            // 4 - Create number formatter, if needed
//                            static NSNumberFormatter *formatter = nil;
//                            if (!formatter) {
//                                formatter = [[NSNumberFormatter alloc] init];
//                                formatter.numberStyle = NSNumberFormatterDecimalStyle;
//                            }
//                            // 5 - Create text layer for annotation
//                            NSString *strValue = [formatter stringFromNumber:value];
//                            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:strValue style:style];
//                            priceAnnotation.contentLayer = textLayer;
//                            // 6 - Get plot index based on identifier
//                            NSInteger plotIndex = 0;
//                            if ([plot.identifier isEqual:CPDSalesByCat] == YES) {
//                                plotIndex = 0;
//                            }
//                            // 7 - Get the anchor point for annotation
//                            CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
//                            NSNumber *anchorX = [NSNumber numberWithFloat:x];
//            
//                            float maxValue = [self getMaxValue];
//                            //            if(segConType.selectedSegmentIndex==0){maxValue = [self getMaxSumValue];}
//                            //            else if(segConType.selectedSegmentIndex==1){maxValue = [self getMaxPercent];}
//                            CGFloat y = [value floatValue] + .05*maxValue;
//            
//                            NSNumber *anchorY = [NSNumber numberWithFloat:y];
//                            priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
//                            // 8 - Add the annotation
//                            [plot.graph.plotAreaFrame.plotArea addAnnotation:priceAnnotation];
            
        }
        
        
        
        if(firstPlot)
        {
            //initial annotation for label x axis
            if(_dataCount>0)
            {
                arrLabelAnnotation = [[NSMutableArray alloc]init];
                for(int index=0; index<_dataCount; index++)
                {
                    NSNumber *x = [NSNumber numberWithInt:0];
                    NSNumber *y = [NSNumber numberWithInt:0];
                    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
                    CPTPlotSpaceAnnotation *labelAnnotation = (CPTPlotSpaceAnnotation*)[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
                    
                    [arrLabelAnnotation addObject:labelAnnotation];
                }
            }
            
            
            //label x axis
            for(int index=0; index<_dataCount; index++)
            {
                // 1 - Is the plot hidden?
                if (plot.isHidden == YES) {
                    return;
                }
                // 2 - Create style, if necessary
                static CPTMutableTextStyle *style = nil;
                if (!style) {
                    style = [CPTMutableTextStyle textStyle];
                    
                    CPTColor *cptColor = [CPTColor blackColor];
                    style.color= cptColor;
                    style.fontSize = 10.0f;
                    style.fontName = @"HelveticaNeue-Medium";
                }
                // 3 - Create annotation, if necessary
                NSString *label = ((SalesByItemData *)_salesByItemDataList[index]).item;
                CPTPlotSpaceAnnotation *labelAnnotation = self.arrLabelAnnotation[index];
                
                
                // 4 - Create number formatter, if needed
                static NSNumberFormatter *formatter = nil;
                if (!formatter) {
                    formatter = [[NSNumberFormatter alloc] init];
                    [formatter setMaximumFractionDigits:2];
                }
                // 5 - Create text layer for annotation
                CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:label style:style];
                labelAnnotation.contentLayer = textLayer;
                // 6 - Get plot index based on identifier
                NSInteger plotIndex = 0;
                if ([plot.identifier isEqual:CPDSalesByCat] == YES) {
                    plotIndex = 0;
                }
                // 7 - Get the anchor point for annotation
                CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
                NSNumber *anchorX = [NSNumber numberWithFloat:x];
                CGFloat y;
                float maxValue = [self getMaxValue];
                {
                    y = .04*maxValue*-1;
                }
                
                
                NSNumber *anchorY = [NSNumber numberWithFloat:y];
                labelAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
                // 8 - Add the annotation
                [plot.graph.plotAreaFrame.plotArea addAnnotation:labelAnnotation];
                
            }
            
            
            ///////second line for x-axis
            //initial annotation for label x axis
            if(_dataCount>0)
            {
                arrLabelAnnotation2 = [[NSMutableArray alloc]init];
                for(int index=0; index<_dataCount; index++)
                {
                    NSNumber *x = [NSNumber numberWithInt:0];
                    NSNumber *y = [NSNumber numberWithInt:0];
                    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
                    CPTPlotSpaceAnnotation *labelAnnotation = (CPTPlotSpaceAnnotation*)[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
                    
                    [arrLabelAnnotation2 addObject:labelAnnotation];
                }
            }
            //label x axis
            for(int index=0; index<_dataCount; index++)
            {
                // 1 - Is the plot hidden?
                if (plot.isHidden == YES) {
                    return;
                }
                // 2 - Create style, if necessary
                static CPTMutableTextStyle *style = nil;
                if (!style) {
                    style = [CPTMutableTextStyle textStyle];
                    
                    CPTColor *cptColor = [CPTColor blackColor];
                    style.color= cptColor;
                    style.fontSize = 10.0f;
                    style.fontName = @"HelveticaNeue-Medium";
                }
                // 3 - Create annotation, if necessary
                NSString *label = ((SalesByItemData *)_salesByItemDataList[index]).item2;
                CPTPlotSpaceAnnotation *labelAnnotation = self.arrLabelAnnotation2[index];
                
                
                // 4 - Create number formatter, if needed
                static NSNumberFormatter *formatter = nil;
                if (!formatter) {
                    formatter = [[NSNumberFormatter alloc] init];
                    [formatter setMaximumFractionDigits:2];
                }
                // 5 - Create text layer for annotation
                CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:label style:style];
                labelAnnotation.contentLayer = textLayer;
                // 6 - Get plot index based on identifier
                NSInteger plotIndex = 0;
                if ([plot.identifier isEqual:CPDSalesByCat] == YES) {
                    plotIndex = 0;
                }
                // 7 - Get the anchor point for annotation
                CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
                NSNumber *anchorX = [NSNumber numberWithFloat:x];
                CGFloat y;
                float maxValue = [self getMaxValue];
                {
                    y = .08*maxValue*-1;
                }
                
                
                NSNumber *anchorY = [NSNumber numberWithFloat:y];
                labelAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
                // 8 - Add the annotation
                [plot.graph.plotAreaFrame.plotArea addAnnotation:labelAnnotation];
                
            }
            firstPlot = NO;
        }
    }
}

-(void)configureAxes
{
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:1];
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = @"วันที่";
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 34.0f;
    
    
    // 4 - Configure the y-axis
    //    NSArray *yAxisLabel = @[@"Total amount (Baht)",@"Total amount (Percent)"];
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;//CPTAxisLabelingPolicyNone;
    axisSet.yAxis.title = @"ยอดขาย";//yAxisLabel[segConType.selectedSegmentIndex];
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 10.0f;
}

-(void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = [_menuTypeList count];
    theLegend.numberOfRows = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend              = theLegend;
    graph.legendAnchor        = CPTRectAnchorTopLeft;
    graph.legendDisplacement  = CGPointMake(30.0, -40.0);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return _dataCount;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    if(fieldEnum == 0)
    {
        num = index;
    }
    else
    {
        double offset = 0;
        SalesDaily *salesDaily;
        SalesByItemData *salesByItemData = [_salesByItemDataList objectAtIndex:index];
        NSInteger menuTypeID = [(NSString *)(plot.identifier) integerValue];
        salesDaily = [SalesDaily getSalesDailyWithSalesDate:salesByItemData.salesDate menuTypeID:menuTypeID salesDailyList:_salesDailyList];
        float sales = salesDaily?salesDaily.sales:0;
        
        if (((CPTBarPlot *)plot).barBasesVary)
        {
            for (MenuType *item in _menuTypeList)
            {
                if (menuTypeID == item.menuTypeID)
                {
                    break;
                }
                
                SalesDaily *salesDailyOtherPlot = [SalesDaily getSalesDailyWithSalesDate:salesByItemData.salesDate menuTypeID:item.menuTypeID salesDailyList:_salesDailyList];
                if(salesDailyOtherPlot)
                {
                    offset += salesDailyOtherPlot.sales;
                }
            }
        }
        if(fieldEnum == 1)
        {
            num = sales + offset;
        }
        else
        {
            num = offset;
        }
        
        return [NSDecimalNumber numberWithDouble:num];
    }
    return [NSDecimalNumber numberWithDouble:num];
}

-(CPTLineStyle *)barLineStyleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    return [NSNull null];
}

-(float)getMaxValue
{
    float maxValue = 0;
    
    for(SalesByItemData *item in _salesByItemDataList)//test
    {
        float valueByDate = 0;
        for(MenuType *menuType in _menuTypeList)
        {
            SalesDaily *salesDaily = [SalesDaily getSalesDailyWithSalesDate:item.salesDate menuTypeID:menuType.menuTypeID salesDailyList:_salesDailyList];
            if(salesDaily)
            {
                valueByDate += salesDaily.sales;
            }
        }
        
        
        if(valueByDate>maxValue)
        {
            maxValue = valueByDate;
        }
    }
    return maxValue;
}

@end
