//
//  ReportSalesByMenuTableViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportSalesByMenuTableViewController.h"
#import "CustomCollectionViewCell.h"
#import "SalesDaily.h"
#import "MenuType.h"
#import "SubMenuType.h"
#import "Menu.h"


@interface ReportSalesByMenuTableViewController ()
{
    NSMutableArray *_salesDailyList;
    NSMutableArray *_columnHeaderList;
    NSMutableArray *_tableList;
}

@end

@implementation ReportSalesByMenuTableViewController
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
@synthesize btnSortValue;



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
    [self setData];
    [colVwData reloadData];
}

- (IBAction)sortValue:(id)sender
{
    btnSortValue.selected = !btnSortValue.selected;
    if(btnSortValue.selected)
    {
        [btnSortValue setTitle:@"เรียงตามหมวดอาหาร" forState:UIControlStateNormal];
    }
    else
    {
        [btnSortValue setTitle:@"เรียงจากมากไปน้อย" forState:UIControlStateNormal];
    }
    [self setData];
    [colVwData reloadData];
}

-(void)loadView
{
    [super loadView];
    
    
    _tableList = [[NSMutableArray alloc]init];
    _salesDailyList = [[NSMutableArray alloc]init];
    _columnHeaderList = [[NSMutableArray alloc]init];
    [self setButtonDesign:btnGraphView];
    [self setButtonDesign:btnExportData];
    [self setButtonDesign:btnPercent];
    [self setButtonDesign:btnSortValue];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    
    
    [self.homeModel downloadItems:dbReportSalesByMenu withData:@[startDate,endDate]];
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
        [_columnHeaderList removeAllObjects];
        [_columnHeaderList addObject:@"หมวดอาหาร"];
        [_columnHeaderList addObject:@"รายการอาหาร"];
        [_columnHeaderList addObject:@"ยอดขายเฉลี่ย(บาท)"];
        [_columnHeaderList addObject:@"ยอดขายเฉลี่ย(บาท) YTD"];
        NSInteger countColumn = [_columnHeaderList count];
        
        return ([_salesDailyList count]+1)*countColumn;
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
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
            
            
            
            NSMutableArray *row = _tableList[item/countColumn-1];
            switch (item%countColumn) {
                case 0:
                {
                    cell.lblTextLabel.text = row[item%countColumn];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                break;
                case 1:
                {
                    cell.lblTextLabel.text = row[item%countColumn];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                break;
                case 2:
                {
                    float value = [row[item%countColumn] floatValue];
                    NSString *strValue = [Utility formatDecimal:value withMinFraction:0 andMaxFraction:0];
                    if(btnPercent.selected)
                    {
                        strValue = [NSString stringWithFormat:@"%@%%",strValue];
                    }
                    
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                break;
                case 3:
                {
                    float value = [row[item%countColumn] floatValue];
                    NSString *strValue = [Utility formatDecimal:value withMinFraction:0 andMaxFraction:0];
                    if(btnPercent.selected)
                    {
                        strValue = [NSString stringWithFormat:@"%@%%",strValue];
                    }
                    
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                break;
                default:
                break;
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
        NSInteger countColumn = [_columnHeaderList count];
        if(indexPath.item%countColumn != (countColumn-1))
        {
            
            float columnWidth = round(10000*colVwData.frame.size.width/countColumn)/10000;
            size = CGSizeMake(columnWidth,44);
        }
        else
        {
            float columnWidth = round(10000*colVwData.frame.size.width/countColumn)/10000;
            size = CGSizeMake(colVwData.frame.size.width-columnWidth*(countColumn-1),44);
        }
    }
    NSLog(@"colvwData width: %f",colVwData.frame.size.width);
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
    
    
    if(self.homeModel.propCurrentDB == dbReportSalesByMenu)
    {
        _salesDailyList = [items[0] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self removeOverlayViews];
            [self setData];
            [colVwData reloadData];
        } );
    }
}

- (IBAction)exportData:(id)sender
{
    [self loadingOverlayView];
    [self exportImpl:@"ยอดขายแยกตามรายการอาหาร"];
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
        for(int i=0; i<[_columnHeaderList count]; i++)
        {
            NSString *columnName = _columnHeaderList[i];
            if(i == [_columnHeaderList count]-1)
            {
                header0 = [NSString stringWithFormat:@"%@%@",header0,columnName];
            }
            else
            {
                header0 = [NSString stringWithFormat:@"%@%@,",header0,columnName];
            }
        }
        NSString* header = [NSString stringWithFormat:@"%@%@\n",criteria,header0];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatinThai);
        NSData *data = [header dataUsingEncoding:encoding];
        NSInteger result = [output write:[data bytes] maxLength:[data length]];
        if (result <= 0) {
            NSLog(@"exportCsv encountered error=%ld from header write", (long)result);
        }
        
        BOOL errorLogged = NO;
        
        
        
        
        for(NSMutableArray *row in _tableList)
        {
            NSString *line = @"";
            for(int i=0; i<[row count]; i++)
            {
                NSString *item = row[i];
                if(btnPercent.selected)
                {
                    if(i == [row count]-1)
                    {
                        line = [NSString stringWithFormat:@"%@%@%%\n",line,item];
                    }
                    else if(i == [row count]-2)
                    {
                        line = [NSString stringWithFormat:@"%@%@%%,",line,item];
                    }
                    else
                    {
                        line = [NSString stringWithFormat:@"%@%@,",line,item];
                    }
                }
                else
                {
                    if(i == [row count]-1)
                    {
                        line = [NSString stringWithFormat:@"%@%@\n",line,item];
                    }
                    else
                    {
                        line = [NSString stringWithFormat:@"%@%@,",line,item];
                    }
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

-(void)setData
{
    for(SalesDaily *item in _salesDailyList)
    {
        MenuType *menuType = [MenuType getMenuType:item.menuTypeID];
        Menu *menu = [Menu getMenu:item.menuID];
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.menuTypeOrderNo = menuType.orderNo;
        item.subMenuTypeOrderNo = subMenuType.orderNo;
        item.menuOrderNo = menu.orderNo;
    }
    
    if(btnSortValue.selected)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_sales" ascending:NO];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_menuTypeOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuTypeOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
        NSArray *sortArray = [_salesDailyList sortedArrayUsingDescriptors:sortDescriptors];
        _salesDailyList = [sortArray mutableCopy];
    }
    else
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_menuTypeOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuTypeOrderNo" ascending:YES];
        NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3, nil];
        NSArray *sortArray = [_salesDailyList sortedArrayUsingDescriptors:sortDescriptors];
        _salesDailyList = [sortArray mutableCopy];
    }
    
    
    if(btnPercent.selected)
    {
        [_tableList removeAllObjects];
        for(SalesDaily *item in _salesDailyList)
        {
            NSMutableArray *row = [[NSMutableArray alloc]init];
            MenuType *menuType = [MenuType getMenuType:item.menuTypeID];
            Menu *menu = [Menu getMenu:item.menuID];
            float sum = [SalesDaily getSumSales:_salesDailyList];
            float sumYTD = [SalesDaily getSumSalesYTD:_salesDailyList];
            [row addObject:menuType.name];
            [row addObject:menu.titleThai];
            [row addObject:[NSString stringWithFormat:@"%f",item.sales*100/sum]];
            [row addObject:[NSString stringWithFormat:@"%f",item.salesYTD*100/sumYTD]];
            [_tableList addObject:row];
        }
    }
    else
    {
        [_tableList removeAllObjects];
        for(SalesDaily *item in _salesDailyList)
        {
            NSMutableArray *row = [[NSMutableArray alloc]init];
            MenuType *menuType = [MenuType getMenuType:item.menuTypeID];
            Menu *menu = [Menu getMenu:item.menuID];
            [row addObject:menuType.name];
            [row addObject:menu.titleThai];
            [row addObject:[NSString stringWithFormat:@"%f",item.sales]];
            [row addObject:[NSString stringWithFormat:@"%f",item.salesYTD]];
            [_tableList addObject:row];
        }
    }
}

@end
