//
//  ReportSalesByMenuTypeMonthlyTableViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/8/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportSalesByMenuTypeMonthlyTableViewController.h"
#import "CustomCollectionViewCell.h"
#import "SalesDaily.h"
#import "SalesByItemData.h"
#import "MenuType.h"


@interface ReportSalesByMenuTypeMonthlyTableViewController ()
{
    NSMutableArray *_salesDailyList;
    NSMutableArray *_salesAvgByMenuTypeYTDList;
    NSMutableArray *_salesAvgYTDList;
    NSMutableArray *_salesByItemDataList;
    NSMutableArray *_menuTypeList;
    NSMutableArray *_columnHeaderList;
}

@end

@implementation ReportSalesByMenuTypeMonthlyTableViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCell";


@synthesize colVwData;
@synthesize startDate;
@synthesize endDate;
@synthesize reportView;
@synthesize frequency;
@synthesize reportType;
@synthesize reportGroup;
@synthesize btnGraphView;
@synthesize btnExportData;
@synthesize btnPercent;



- (void)unwindToReportDetail
{
    reportView = reportViewTable;
    [self performSegueWithIdentifier:@"segUnwindToReportDetail" sender:self];
}

- (IBAction)showPercent:(id)sender
{
    btnPercent.selected = !btnPercent.selected;
    if(btnPercent.selected)
    {
        [btnPercent setTitle:@"จำนวนเต็ม" forState:UIControlStateNormal];
    }
    else
    {
        [btnPercent setTitle:@"%" forState:UIControlStateNormal];
    }
    [colVwData reloadData];
}

-(void)loadView
{
    [super loadView];
    
    
    _salesDailyList = [[NSMutableArray alloc]init];
    _salesByItemDataList = [[NSMutableArray alloc]init];
    _menuTypeList = [[NSMutableArray alloc]init];
    _columnHeaderList = [[NSMutableArray alloc]init];
    [self setButtonDesign:btnGraphView];
    [self setButtonDesign:btnExportData];
    [self setButtonDesign:btnPercent];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    
    
    [self.homeModel downloadItems:dbReportSalesByMenuTypeMonthly withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    colVwData.delegate = self;
    colVwData.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
        [colVwData registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  [_salesDailyList count] > 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwData])
    {
        //row num
        [_salesByItemDataList removeAllObjects];
        NSDate *previousSalesDate = nil;
        for(SalesDaily *item in _salesDailyList)
        {
            if(![previousSalesDate isEqual:item.salesDate])
            {
                SalesByItemData *salesByItem = [[SalesByItemData alloc]init];
                salesByItem.item = [Utility dateToString:item.salesDate toFormat:@"MMM-yy"];
                //                salesByItem.item2 = [Utility getDay:item.dayOfWeek];
                salesByItem.salesDate = item.salesDate;
                [_salesByItemDataList addObject:salesByItem];
                previousSalesDate = item.salesDate;
            }
        }
        
        
        
        
        //column num
        [_menuTypeList removeAllObjects];
        NSSet *menuTypeIDSet = [NSSet setWithArray:[_salesDailyList valueForKey:@"_menuTypeID"]];
        [_menuTypeList removeAllObjects];
        for(NSNumber *item in menuTypeIDSet)
        {
            MenuType *menuType = [MenuType getMenuType:[item integerValue]];
            [_menuTypeList addObject:menuType];
        }
        _menuTypeList = [MenuType sort:_menuTypeList];
        
        
        
        
        [_columnHeaderList removeAllObjects];
        [_columnHeaderList addObject:@"เดือน"];
        for(MenuType *item in _menuTypeList)
        {
            [_columnHeaderList addObject:item.name];
        }
        [_columnHeaderList addObject:@"ยอดขาย(บาท)"];
        
        
        
        return ([_salesByItemDataList count]+2)*([_menuTypeList count]+2);
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    if([collectionView isEqual:colVwData])
    {
        if(btnPercent.selected)
        {
            NSInteger countColumn = [_menuTypeList count] + 2;
            if(item/countColumn == 0)
            {
                cell.lblTextLabel.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor grayColor];
                cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                
                cell.lblTextLabel.text = _columnHeaderList[item];
            }
            else if(item/countColumn < [_salesByItemDataList count]+1)
            {
                cell.lblTextLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = mLightBlueColor;
                
                
                
                SalesByItemData *salesByItemData = _salesByItemDataList[item/countColumn-1];
                cell.lblTextLabel.text = salesByItemData.item;
                cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                
                if(item%countColumn > 0 && item%countColumn < [_menuTypeList count]+2-1)
                {
                    MenuType *menuType = _menuTypeList[item%countColumn-1];
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithSalesDate:salesByItemData.salesDate menuTypeID:menuType.menuTypeID salesDailyList:_salesDailyList];
                    float sum = [SalesDaily getSumSalesWithSalesDate:salesByItemData.salesDate salesDailyList:_salesDailyList];
                    NSString *strValue = [NSString stringWithFormat:@"%@%%",[Utility formatDecimal:salesDaily.sales*100/sum withMinFraction:0 andMaxFraction:0]];
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                else if(item%countColumn == [_menuTypeList count]+2-1)
                {
                    float sum = [SalesDaily getSumSalesWithSalesDate:salesByItemData.salesDate salesDailyList:_salesDailyList];
                    cell.lblTextLabel.text = [Utility formatDecimal:sum withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
            }
            else
            {
                cell.lblTextLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = mLightBlueColor;
                if(item%countColumn == 0)
                {
                    cell.lblTextLabel.text = @"เฉลี่ย YTD";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                else if(item%countColumn < [_menuTypeList count]+2-1)
                {
                    MenuType *menuType = _menuTypeList[item%countColumn-1];
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithMenuTypeID:menuType.menuTypeID salesDailyList:_salesAvgByMenuTypeYTDList];
                    SalesDaily *salesDailyAll = _salesAvgYTDList[0];
                    NSString *strValue = [NSString stringWithFormat:@"%@%%",[Utility formatDecimal:salesDaily.sales*100/salesDailyAll.sales withMinFraction:0 andMaxFraction:0]];
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                else if(item%countColumn == [_menuTypeList count]+2-1)
                {
                    cell.lblTextLabel.text = @"100%";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
            }
        }
        else
        {
            NSInteger countColumn = [_menuTypeList count] + 2;
            if(item/countColumn == 0)
            {
                cell.lblTextLabel.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor grayColor];
                cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                
                cell.lblTextLabel.text = _columnHeaderList[item];
            }
            else if(item/countColumn < [_salesByItemDataList count]+1)
            {
                cell.lblTextLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = mLightBlueColor;
                
                
                
                SalesByItemData *salesByItemData = _salesByItemDataList[item/countColumn-1];
                cell.lblTextLabel.text = salesByItemData.item;
                cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                if(item%countColumn > 0 && item%countColumn < [_menuTypeList count]+2-1)
                {
                    MenuType *menuType = _menuTypeList[item%countColumn-1];
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithSalesDate:salesByItemData.salesDate menuTypeID:menuType.menuTypeID salesDailyList:_salesDailyList];
                    cell.lblTextLabel.text = [Utility formatDecimal:salesDaily.sales withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                else if(item%countColumn == [_menuTypeList count]+2-1)
                {
                    float sum = [SalesDaily getSumSalesWithSalesDate:salesByItemData.salesDate salesDailyList:_salesDailyList];
                    cell.lblTextLabel.text = [Utility formatDecimal:sum withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
            }
            else
            {
                cell.lblTextLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = mLightBlueColor;
                if(item%countColumn == 0)
                {
                    cell.lblTextLabel.text = @"เฉลี่ย ​YTD";
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                else if(item%countColumn < [_menuTypeList count]+2-1)
                {
                    MenuType *menuType = _menuTypeList[item%countColumn-1];
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithMenuTypeID:menuType.menuTypeID salesDailyList:_salesAvgByMenuTypeYTDList];
                    float avg = salesDaily.sales;
                    cell.lblTextLabel.text = [Utility formatDecimal:avg withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                else if(item%countColumn == [_menuTypeList count]+2-1)
                {
                    SalesDaily *salesDaily = _salesAvgYTDList[0];
                    float avg = salesDaily.sales;
                    cell.lblTextLabel.text = [Utility formatDecimal:avg withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
            }
        }
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    
    if([collectionView isEqual:colVwData])
    {
        NSInteger countColumn = [_menuTypeList count]+2;
        NSLog(@"(colvw width,countColumn): %f,%ld",colVwData.frame.size.width,countColumn);
        if(indexPath.item%countColumn != (countColumn-1))
        {
            
            float columnWidth = floorf(10000*colVwData.frame.size.width/countColumn)/10000;
            size = CGSizeMake(columnWidth,44);
        }
        else
        {
            float columnWidth = floorf(10000*colVwData.frame.size.width/countColumn)/10000;
            columnWidth = floor(colVwData.frame.size.width-columnWidth*(countColumn-1));
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
    
    
    if(self.homeModel.propCurrentDB == dbReportSalesByMenuTypeMonthly)
    {
        _salesDailyList = [items[0] mutableCopy];
        _salesAvgByMenuTypeYTDList = [items[1] mutableCopy];
        _salesAvgYTDList = [items[2] mutableCopy];
        
        
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self removeOverlayViews];
            
            [colVwData reloadData];
        } );
    }
}

- (IBAction)exportData:(id)sender
{
    [self loadingOverlayView];
    [self exportImpl:@"ยอดขายแยกตามหมวดรายการอาหารรายเดือน"];
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
        NSString *header0 = @"";
        for(MenuType *item in _menuTypeList)
        {
            header0 = [NSString stringWithFormat:@"%@,%@",header0,item.name];
        }
        header0 = [NSString stringWithFormat:@"เดือน%@,ยอดขาย(บาท)\n",header0];
        NSString* header = [NSString stringWithFormat:@"%@%@",criteria,header0];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatinThai);
        NSData *data = [header dataUsingEncoding:encoding];
        NSInteger result = [output write:[data bytes] maxLength:[data length]];
        if (result <= 0) {
            NSLog(@"exportCsv encountered error=%ld from header write", (long)result);
        }
        
        BOOL errorLogged = NO;
        
        
        
        NSMutableArray *table = [[NSMutableArray alloc]init];
        if(btnPercent.selected)
        {
            // Loop through the results and write them to the CSV file
            for(SalesByItemData *item in _salesByItemDataList)
            {
                NSMutableArray *row = [[NSMutableArray alloc]init];
                //                [row addObject:item.item2];
                [row addObject:item.item];
                float sum = [SalesDaily getSumSalesWithSalesDate:item.salesDate salesDailyList:_salesDailyList];
                for(MenuType *menuType in _menuTypeList)
                {
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithSalesDate:item.salesDate menuTypeID:menuType.menuTypeID salesDailyList:_salesDailyList];
                    [row addObject:[NSString stringWithFormat:@"%f%%",salesDaily.sales*100/sum]];
                }
                [row addObject:[NSString stringWithFormat:@"%f",sum]];
                [table addObject:row];
            }
            
            
            
            NSMutableArray *row = [[NSMutableArray alloc]init];
            [row addObject:@"เฉลี่ย YTD"];
            SalesDaily *salesDailyAll = _salesAvgYTDList[0];
            for(MenuType *menuType in _menuTypeList)
            {
                SalesDaily *salesDaily = [SalesDaily getSalesDailyWithMenuTypeID:menuType.menuTypeID salesDailyList:_salesAvgByMenuTypeYTDList];
                [row addObject:[NSString stringWithFormat:@"%f%%",salesDaily.sales*100/salesDailyAll.sales]];
            }
            [row addObject:[NSString stringWithFormat:@"%f%%",100.0]];
            [table addObject:row];
        }
        else
        {
            // Loop through the results and write them to the CSV file
            for(SalesByItemData *item in _salesByItemDataList)
            {
                NSMutableArray *row = [[NSMutableArray alloc]init];
                //                [row addObject:item.item2];
                [row addObject:item.item];
                for(MenuType *menuType in _menuTypeList)
                {
                    SalesDaily *salesDaily = [SalesDaily getSalesDailyWithSalesDate:item.salesDate menuTypeID:menuType.menuTypeID salesDailyList:_salesDailyList];
                    [row addObject:[NSString stringWithFormat:@"%f",salesDaily.sales]];
                }
                float sum = [SalesDaily getSumSalesWithSalesDate:item.salesDate salesDailyList:_salesDailyList];
                [row addObject:[NSString stringWithFormat:@"%f",sum]];
                [table addObject:row];
            }
            
            
            
            NSMutableArray *row = [[NSMutableArray alloc]init];
            [row addObject:@"เฉลี่ย YTD"];
            for(MenuType *menuType in _menuTypeList)
            {
                SalesDaily *salesDaily = [SalesDaily getSalesDailyWithMenuTypeID:menuType.menuTypeID salesDailyList:_salesAvgByMenuTypeYTDList];
                [row addObject:[NSString stringWithFormat:@"%f",salesDaily.sales]];
            }
            SalesDaily *salesDailyAll = _salesAvgYTDList[0];
            [row addObject:[NSString stringWithFormat:@"%f",salesDailyAll.sales]];
            [table addObject:row];
        }
        
        
        
        
        for(NSMutableArray *row in table)
        {
            NSString *line = @"";
            for(int i=0; i<[row count]; i++)
            {
                NSString *item = row[i];
                if(i == [row count]-1)
                {
                    line = [NSString stringWithFormat:@"%@%@\n",line,item];
                }
                else
                {
                    line = [NSString stringWithFormat:@"%@%@,",line,item];
                }
            }
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
