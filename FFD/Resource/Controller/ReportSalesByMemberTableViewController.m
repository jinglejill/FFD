//
//  ReportSalesByMemberTableViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportSalesByMemberTableViewController.h"
#import "CustomCollectionViewCell.h"
#import "SalesDaily.h"



@interface ReportSalesByMemberTableViewController ()
{
    NSMutableArray *_salesDailyList;
    NSMutableArray *_columnHeaderList;
}

@end

@implementation ReportSalesByMemberTableViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCell";


@synthesize colVwData;
@synthesize colVwSummary;
@synthesize startDate;
@synthesize endDate;
@synthesize reportView;
@synthesize frequency;
@synthesize reportType;
@synthesize reportGroup;
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
        frame.size.width = self.view.frame.size.width*0.7;
        colVwData.frame = frame;
    }
    
    {
        CGRect frame = colVwSummary.frame;
        frame.origin.x = colVwData.frame.size.width+20+8;
        frame.size.width = self.view.frame.size.width*0.3-2*20-8;
        colVwSummary.frame = frame;
    }
}

-(void)loadView
{
    [super loadView];
    
    
    _salesDailyList = [[NSMutableArray alloc]init];
    _columnHeaderList = [[NSMutableArray alloc]init];
    [self setButtonDesign:btnExportData];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    
    
    [self.homeModel downloadItems:dbReportSalesByMember withData:@[startDate,endDate]];
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
    if([collectionView isEqual:colVwData])
    {
        return  [_salesDailyList count] > 0;
    }
    else if([collectionView isEqual:colVwSummary])
    {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if([collectionView isEqual:colVwData])
    {
        [_columnHeaderList removeAllObjects];
        [_columnHeaderList addObject:@"ลูกค้า"];
        [_columnHeaderList addObject:@"วันเริ่มสมาชิก"];
        [_columnHeaderList addObject:@"ทานในร้าน"];
        [_columnHeaderList addObject:@"Take away"];
        [_columnHeaderList addObject:@"Delivery"];
        [_columnHeaderList addObject:@"ยอดขาย(บาท)"];
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
                    cell.lblTextLabel.text = [Utility isStringEmpty:salesDaily.customer]?@"ลูกค้าทั่วไป":[Utility setPhoneNoFormat:salesDaily.customer];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                break;
                case 1:
                {
                    cell.lblTextLabel.text = [Utility dateToString:salesDaily.memberDate toFormat:@"d MMM yyyy"];
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                break;
                case 2:
                {
                    NSString *strValue = [Utility formatDecimal:salesDaily.salesEatIn withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                break;
                case 3:
                {
                    NSString *strValue = [Utility formatDecimal:salesDaily.salesTakeAway withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                break;
                case 4:
                {
                    NSString *strValue = [Utility formatDecimal:salesDaily.salesDelivey withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strValue;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
                }
                break;
                case 5:
                {
                    NSString *strValue = [Utility formatDecimal:salesDaily.sales withMinFraction:0 andMaxFraction:0];
                    cell.lblTextLabel.text = strValue;
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
                cell.lblTextLabel.text = @"ยอดขายรวม";
                cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
            }
            break;
            case 1:
            {
                float sales = [SalesDaily getSumSales:_salesDailyList];
                cell.lblTextLabel.text = [Utility formatDecimal:sales withMinFraction:0 andMaxFraction:0];
                cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
            }
            break;
            case 2:
            {
                cell.lblTextLabel.text = @"ยอดขายจากลูกค้าทั่วไป";
                cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
            }
            break;
            case 3:
            {
                float sales = [SalesDaily getSumSalesCustomerBlank:_salesDailyList];
                cell.lblTextLabel.text = [Utility formatDecimal:sales withMinFraction:0 andMaxFraction:0];
                cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
            }
            break;
            case 4:
            {
                cell.lblTextLabel.text = @"ยอดขายจากสมาชิก";
                cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
            }
            break;
            case 5:
            {
                float sales = [SalesDaily getSumSales:_salesDailyList]-[SalesDaily getSumSalesCustomerBlank:_salesDailyList];
                cell.lblTextLabel.text = [Utility formatDecimal:sales withMinFraction:0 andMaxFraction:0];
                cell.lblTextLabel.textAlignment = NSTextAlignmentRight;
            }
            break;
            
            default:
            break;
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
        switch (indexPath.item%countColumn) {
            case 0:
            {
                size = CGSizeMake(130,44);
            }
            break;
            case 1:
            {
                float columnWidth = floorf((colVwData.frame.size.width - 130)*0.5*0.6);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            case 5:
            {
                float columnWidth = floorf((colVwData.frame.size.width - 130)*0.5*0.4);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            case 2:
            case 3:
            {
                float columnWidth = floorf((colVwData.frame.size.width - 130)*0.5/3);
                size = CGSizeMake(columnWidth,44);
            }
            break;
            case 4:
            {
                float columnWidth = floorf(colVwData.frame.size.width - 130 - 2*floorf((colVwData.frame.size.width - 130)*0.5/2) - 2*floorf((colVwData.frame.size.width - 130)*0.5/3));
                size = CGSizeMake(columnWidth,44);
            }
        }
//        if(indexPath.item%countColumn == 0)
//        {
//            size = CGSizeMake(130,44);
//        }
//        else
//        {
//            float columnWidth = (colVwData.frame.size.width - 130)/5;
//            size = CGSizeMake(columnWidth,44);
//        }
    }
    else if([collectionView isEqual:colVwSummary])
    {
        NSInteger countColumn = 2;
        if(indexPath.item%countColumn == 0)
        {
            float columnWidth = floorf(colVwSummary.frame.size.width/countColumn);
            size = CGSizeMake(columnWidth,44);
        }
        else if(indexPath.item%countColumn == 1)
        {
            float columnWidth = floorf(colVwSummary.frame.size.width - floorf(colVwSummary.frame.size.width/countColumn));
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
    
    
    if(self.homeModel.propCurrentDB == dbReportSalesByMember)
    {
        _salesDailyList = [items[0] mutableCopy];
        
        
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
    [self exportImpl:@"ยอดขายแยกตามหมายเลขสมาชิก"];
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
        
        
        
        
        for(SalesDaily *item in _salesDailyList)
        {
            NSString *strCustomer = [Utility isStringEmpty:item.customer]?@"ลูกค้าทั่วไป":item.customer;
            NSString *strMemberDate = [Utility dateToString:item.memberDate toFormat:@"d MMM yyyy"];
            NSString *line = [NSString stringWithFormat:@"%@,%@,%f,%f,%f,%f\n",strCustomer,strMemberDate,item.salesEatIn,item.salesTakeAway,item.salesDelivey,item.sales];
            NSData *data = [line dataUsingEncoding:encoding];
            result = [output write:[data bytes] maxLength:[data length]];
            
            
            if (!errorLogged && (result <= 0)) {
                NSLog(@"exportCsv write returned %ld", (long)result);
                errorLogged = YES;
            }
        }
        
        
        
        //summary table
        {
            NSString *line = [NSString stringWithFormat:@"\n\n\nยอดขายรวม,%f\n",[SalesDaily getSumSales:_salesDailyList]];
            line = [NSString stringWithFormat:@"%@ยอดขายจากลูกค้าทั่วไป,%f\n",line,[SalesDaily getSumSalesCustomerBlank:_salesDailyList]];
            line = [NSString stringWithFormat:@"%@ยอดขายจากสมาชิก,%f\n",line,[SalesDaily getSumSales:_salesDailyList]-[SalesDaily getSumSalesCustomerBlank:_salesDailyList]];
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
