//
//  ReportSalesAllDailyTableViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/3/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportSalesAllDailyTableViewController.h"
#import "CustomCollectionViewCell.h"
#import "SalesDaily.h"
#import "SalesByItemData.h"



@interface ReportSalesAllDailyTableViewController ()
{
    NSMutableArray *_salesDailyList;
    NSMutableArray *_salesAvgYTDList;
    NSMutableArray *_salesAvgYTDWeekDayList;
    NSMutableArray *_salesAvgYTDWeekendList;
    NSMutableArray *_columnHeaderList;
}

@end

@implementation ReportSalesAllDailyTableViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCell";


@synthesize colVwData;
@synthesize colVwSummary;
@synthesize startDate;
@synthesize endDate;
@synthesize reportView;
@synthesize frequency;
@synthesize reportType;
@synthesize reportGroup;
@synthesize btnGraphView;
@synthesize btnExportData;

- (void)unwindToReportDetail
{
    reportView = reportViewTable;
    [self performSegueWithIdentifier:@"segUnwindToReportDetail" sender:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    {
        CGRect frame = colVwData.frame;
        frame.size.width = self.view.frame.size.width*0.45;
        colVwData.frame = frame;
    }
    
    {
        CGRect frame = colVwSummary.frame;
        frame.origin.x = colVwData.frame.size.width+20+8;
        frame.size.width = self.view.frame.size.width*0.55-2*20-8;
        colVwSummary.frame = frame;
    }
    
    
}

-(void)loadView
{
    [super loadView];
    
    
    _salesDailyList = [[NSMutableArray alloc]init];
    _columnHeaderList = [[NSMutableArray alloc]init];
    [self setButtonDesign:btnGraphView];
    [self setButtonDesign:btnExportData];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    
    
    
    [self.homeModel downloadItems:dbReportSalesAllDaily withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    colVwData.delegate = self;
    colVwData.dataSource = self;
    colVwSummary.delegate = self;
    colVwSummary.dataSource = self;
    
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
        [colVwData registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
        [colVwSummary registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_salesDailyList count] > 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwData])
    {
        [_columnHeaderList removeAllObjects];
        [_columnHeaderList addObject:@"วัน"];
        [_columnHeaderList addObject:@"วันที่"];
        [_columnHeaderList addObject:@"ส่วนลด (บาท)"];
        [_columnHeaderList addObject:@"ยอดขายสุทธิ(รวมvat)"];
        NSInteger countColumn = [_columnHeaderList count];
        
                
        return ([_salesDailyList count]+1)*countColumn;
    }
    else if([collectionView isEqual:colVwSummary])
    {
        return 6;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger item = indexPath.item;
    {
        CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        if([collectionView isEqual:colVwData])
        {
            NSInteger countColumn = [_columnHeaderList count];
            if(item/countColumn == 0)
            {
                cell.lblTextLabel.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor grayColor];
                cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                cell.lblTextLabel.text = _columnHeaderList[item];                
            }
            else
            {
                cell.lblTextLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = mLightBlueColor;
                
                SalesDaily *salesDaily = _salesDailyList[item/countColumn-1];
                switch (item%countColumn) {
                    case 0:
                    {
                        cell.lblTextLabel.text = [Utility getDay:salesDaily.dayOfWeek];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 1:
                    {
                        cell.lblTextLabel.text = [Utility dateToString:salesDaily.salesDate toFormat:@"d-MMM"];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 2:
                    {
                        cell.lblTextLabel.text = [Utility formatDecimal:salesDaily.discountValue withMinFraction:0 andMaxFraction:0];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                    }
                        break;
                    case 3:
                    {
                        cell.lblTextLabel.text = [Utility formatDecimal:salesDaily.sales withMinFraction:0 andMaxFraction:0];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                    }
                    break;
                    default:
                        break;
                }
            }
        }
        else if([collectionView isEqual:colVwSummary])
        {
            cell.lblTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = mLightBlueColor;
            switch (item) {
                case 0:
                {
                    cell.lblTextLabel.text = @"ยอดขายเฉลี่ย YTD";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                case 1:
                {
                    SalesDaily *salesDaily = _salesAvgYTDList[0];
                    float avgSales = salesDaily.sales;
                    NSString *strAvgSales = [Utility formatDecimal:avgSales withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strAvgSales;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                    break;
                case 2:
                {
                    cell.lblTextLabel.text = @"ยอดขายเฉลี่ยวันธรรมดา YTD";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                case 3:
                {
                    SalesDaily *salesDaily = _salesAvgYTDWeekDayList[0];
                    float avgSales = salesDaily.sales;
                    NSString *strAvgSales = [Utility formatDecimal:avgSales withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strAvgSales;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                    break;
                case 4:
                {
                    cell.lblTextLabel.text = @"ยอดขายเฉลี่ยเสาร์อาทิตย์ YTD";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                case 5:
                {
                    SalesDaily *salesDaily = _salesAvgYTDWeekendList[0];
                    float avgSales = salesDaily.sales;
                    NSString *strAvgSales = [Utility formatDecimal:avgSales withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strAvgSales;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    
    return nil;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    
    if([collectionView isEqual:colVwData])
    {
        NSInteger countColumn = [_columnHeaderList count];
        switch (indexPath.item%countColumn) {
//            case 0:
//            case 1:
//            {
//                float columnWidth = floorf(colVwData.frame.size.width*0.25);
//                size = CGSizeMake(columnWidth,44);
//            }
//            
//            break;
//            case 2:
//            {
//                float columnWidth = floorf(colVwData.frame.size.width*0.25);
//                columnWidth = floorf(colVwData.frame.size.width - 2*columnWidth);
//                size = CGSizeMake(columnWidth,44);
//            }
//            
//            break;
            case 0:
            {
                float columnWidth = floorf(colVwData.frame.size.width*0.16);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            case 1:
            case 2:
            {
                float columnWidth = floorf(colVwData.frame.size.width*0.25);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            case 3:
            {
                float columnWidth = floorf(colVwData.frame.size.width*0.34);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            default:
            {
//                float columnWidth = floorf(colVwData.frame.size.width*0.25);
//                size = CGSizeMake(columnWidth,44);
            }
            break;
        }
        
    }
    else if([collectionView isEqual:colVwSummary])
    {
        if(indexPath.item%2 == 0)
        {
            float columnWidth = floorf(colVwSummary.frame.size.width/3*2);
            size = CGSizeMake(columnWidth,44);
        }
        else
        {
            float columnWidth = floorf(colVwSummary.frame.size.width/3*2);
            columnWidth = floorf(colVwSummary.frame.size.width - columnWidth);
            size = CGSizeMake(columnWidth,44);
        }
    }
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwData.collectionViewLayout;
            [layout invalidateLayout];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [colVwData reloadData];
        }];
    }
    {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwSummary.collectionViewLayout;
            [layout invalidateLayout];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [colVwSummary reloadData];
        }];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
    return headerSize;
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbReportSalesAllDaily)
    {
        _salesDailyList = [items[0] mutableCopy];
        _salesAvgYTDList = [items[1] mutableCopy];
        _salesAvgYTDWeekDayList = [items[2] mutableCopy];
        _salesAvgYTDWeekendList = [items[3] mutableCopy];
        
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self removeOverlayViews];
            
            [colVwData reloadData];
            [colVwSummary reloadData];
        } );
    }
}

- (IBAction)exportData:(id)sender
{
    [self loadingOverlayView];
    [self exportImpl:@"ยอดขายรายวัน"];
}

- (IBAction)showGraphView:(id)sender
{
    reportView = reportViewGraph;
    [self performSegueWithIdentifier:@"segUnwindToReportDetail" sender:self];
}

-(void) exportCsv: (NSString*) filename
{
    [super exportCsv:filename];
    
    
    
    NSOutputStream* output = [[NSOutputStream alloc] initToFileAtPath: filename append: YES];
    [output open];
    if (![output hasSpaceAvailable]) {
        NSLog(@"No space available in %@", filename);
        // TODO: UIAlertView?
    }
    else
    {
        NSString *strStartDate = [Utility dateToString:startDate toFormat:@"d MMM yyyy"];
        NSString *strEndDate = [Utility dateToString:endDate toFormat:@"d MMM yyyy"];
        NSString *criteria = [NSString stringWithFormat:@"ช่วงเวลา: %@ to %@\n",strStartDate, strEndDate];
        NSString *header0 = @"วัน,วันที่,ส่วนลด(บาท),ยอดขายสุทธิ(รวมvat)\n";
        NSString* header = [NSString stringWithFormat:@"%@%@",criteria,header0];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatinThai);
        NSData *data = [header dataUsingEncoding:encoding];
        NSInteger result = [output write:[data bytes] maxLength:[data length]];
        if (result <= 0) {
            NSLog(@"exportCsv encountered error=%ld from header write", (long)result);
        }
        
        BOOL errorLogged = NO;
        
        
        
        // Loop through the results and write them to the CSV file
        for(SalesDaily *item in _salesDailyList)
        {
            NSString *strDay = [Utility getDay:item.dayOfWeek];
            NSString *strDate = [Utility dateToString:item.salesDate toFormat:@"d MMM yyyy"];
            NSString *strSales = [NSString stringWithFormat:@"%f",item.sales];
            NSString *strDiscountValue = [NSString stringWithFormat:@"%f",item.discountValue];
            
            
            NSString* line = [[NSString alloc] initWithFormat: @"%@,%@,%@\n",
                              strDay, strDate, strDiscountValue, strSales];
            NSData *data = [line dataUsingEncoding:encoding];
            result = [output write:[data bytes] maxLength:[data length]];
            
            
            if (!errorLogged && (result <= 0)) {
                NSLog(@"exportCsv write returned %ld", (long)result);
                errorLogged = YES;
            }
        }
        
        
        //summary table
        {
            SalesDaily *salesDailyYTD = _salesAvgYTDList[0];
            float avgSalesYTD = salesDailyYTD.sales;
            SalesDaily *salesDailyYTDWeekDay = _salesAvgYTDWeekDayList[0];
            float avgSalesYTDWeekDay = salesDailyYTDWeekDay.sales;
            SalesDaily *salesDailyYTDWeekend = _salesAvgYTDWeekendList[0];
            float avgSalesYTDWeekend = salesDailyYTDWeekend.sales;
            
            
            NSString *line = [NSString stringWithFormat:@"\n\n\nยอดขายเฉลี่ย YTD,%f\n",avgSalesYTD];
            line = [NSString stringWithFormat:@"%@ยอดขายเฉลี่ยวันธรรมดา YTD,%f\n",line,avgSalesYTDWeekDay];
            line = [NSString stringWithFormat:@"%@ยอดขายเฉลี่ยเสาร์อาทิตย์ YTD,%f\n",line,avgSalesYTDWeekend];
            NSData *data = [line dataUsingEncoding:encoding];
            result = [output write:[data bytes] maxLength:[data length]];
            
            
            if (!errorLogged && (result <= 0)) {
                NSLog(@"exportCsv write returned %ld", (long)result);
                errorLogged = YES;
            }
        }        
    }
    [output close];
}
@end
