//
//  InventoryViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "InventoryViewController.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCell.h"
#import "IngredientType.h"
#import "Ingredient.h"
#import "IngredientCheck.h"



@interface InventoryViewController ()
{
    NSMutableArray *_ingredientTypeList;
    NSInteger _selectedIndexIngredientType;    
    NSMutableArray *_lastCheckStockList;
    NSMutableArray *_receiveStockBeforeTodayList;
    NSMutableArray *_stockUseList;
    NSMutableArray *_receiveStockTodayList;
    NSMutableArray *_stockSalesConList;
    NSMutableArray *_ingredientList;
}
@end

@implementation InventoryViewController
static NSString * const reuseHeaderViewIdentifier = @"Header";
static NSString * const reuseIdentifierTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierCell = @"CustomCollectionViewCell";



@synthesize colVwIngredientType;
@synthesize colVwIngredient;
@synthesize txtDate;
@synthesize txtExpectedSales;
@synthesize dtPicker;
@synthesize txtSalesConStartDate;
@synthesize txtSalesConEndDate;
@synthesize btnIngredientCheck;
@synthesize btnCustomSalesByMenu;
@synthesize btnIngredientReceive;



- (IBAction)unwindToMaterialInventory:(UIStoryboardSegue *)segue
{
    [self loadViewProcess];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    // Now modify bottomView's frame here
    {
        CGRect frame = colVwIngredientType.frame;
        frame.size.width = self.view.frame.size.width-2*20;
        colVwIngredientType.frame = frame;
    }
    
    {
        CGRect frame = colVwIngredient.frame;
        frame.size.width = self.view.frame.size.width-2*20;
        colVwIngredient.frame = frame;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectIngredientType)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
                                               
    colVwIngredientType.dataSource = self;
    colVwIngredientType.delegate = self;
    
    colVwIngredient.dataSource = self;
    colVwIngredient.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTabMenuType bundle:nil];
        [colVwIngredientType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierTabMenuType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCell bundle:nil];
        [colVwIngredient registerNib:nib forCellWithReuseIdentifier:reuseIdentifierCell];
    }
    [colVwIngredient registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredient.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if([textField isEqual:txtDate] && ![Utility isStringEmpty:txtExpectedSales.text])
    {
        //download material inventory
        [self downloadInventory];
    }
    else if([textField isEqual:txtExpectedSales] && ![Utility isStringEmpty:txtExpectedSales.text])
    {
        [Utility setExpectedSales:[Utility floatValue:txtExpectedSales.text]];
        
        
        //download material inventory
        [self downloadInventory];
    }
    else if([textField isEqual:txtSalesConStartDate])
    {
        NSString *strStartDate = [Utility formatDate:txtSalesConStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:txtSalesConEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            txtSalesConEndDate.text = txtSalesConStartDate.text;
        }
    }
    else if([textField isEqual:txtSalesConEndDate])
    {
        NSString *strStartDate = [Utility formatDate:txtSalesConStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        NSString *strEndDate = [Utility formatDate:txtSalesConEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
        if(strStartDate>strEndDate)
        {
            txtSalesConStartDate.text = txtSalesConEndDate.text;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:txtDate] || [textField isEqual:txtSalesConStartDate] || [textField isEqual:txtSalesConEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    
}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if([textField isEqual:txtExpectedSales])
//    {
//        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
//        
//        // The user deleting all input is perfectly acceptable.
//        if ([resultingString length] == 0) {
//            return true;
//        }
//        
//        float holder;
//        
//        NSScanner *scan = [NSScanner scannerWithString: resultingString];
//        
//        return [scan scanFloat: &holder] && [scan isAtEnd];
//    }
//    
//    return YES;
//}

- (IBAction)datePickerChanged:(id)sender
{
    if([txtDate isFirstResponder])
    {
        txtDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    else if([txtSalesConStartDate isFirstResponder])
    {
        txtSalesConStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    else if([txtSalesConEndDate isFirstResponder])
    {
        txtSalesConEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (void)loadView
{
    [super loadView];
    
    
    [self setButtonDesign:btnIngredientReceive];
    [self setButtonDesign:btnCustomSalesByMenu];
    [self setButtonDesign:btnIngredientCheck];
    _selectedIndexIngredientType = 0;
    btnCustomSalesByMenu.hidden = YES;
    
    
    
    txtDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtSalesConStartDate.text = [Utility dateToString:[Utility getPreviousMonthFirstDate] toFormat:@"d MMM yyyy"];
    txtSalesConEndDate.text = [Utility dateToString:[Utility getPreviousMonthLastDate] toFormat:@"d MMM yyyy"];
    txtDate.delegate = self;
    txtSalesConStartDate.delegate = self;
    txtSalesConEndDate.delegate = self;
    txtDate.inputView = dtPicker;
    txtSalesConStartDate.inputView = dtPicker;
    txtSalesConEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    txtExpectedSales.delegate = self;
    txtExpectedSales.text = [Utility formatDecimal:[Utility expectedSales] withMinFraction:0 andMaxFraction:0];
    
    
    
    [self loadViewProcess];
    
}

-(void)loadViewProcess
{
    [super loadViewProcess];
    
    _ingredientTypeList = [IngredientType getIngredientTypeListWithStatus:1];
    [colVwIngredientType reloadData];
    [self selectIngredientType];

    
    if(![Utility isStringEmpty:txtExpectedSales.text])
    {
        //download material inventory
        [self downloadInventory];
    }
}


- (void)selectIngredientType
{
    if([_ingredientTypeList count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexIngredientType inSection:0];
        [colVwIngredientType selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:colVwIngredientType didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwIngredientType])
    {
        return [_ingredientTypeList count];
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        NSInteger countColumn = 6;
        return ([_ingredientList count])*countColumn;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwIngredientType])
    {
        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTabMenuType forIndexPath:indexPath];
        
        IngredientType *ingredientType = _ingredientTypeList[item];
        cell.lblMenuType.text = ingredientType.name;
        if(item == _selectedIndexIngredientType)
        {
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.backgroundColor = mLightBlueColor;
            cell.lblMenuType.textColor = mBlueColor;
            
            
            [colVwIngredientType selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        else
        {
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont systemFontOfSize:15.0f];
            cell.backgroundColor = [UIColor clearColor];
            cell.lblMenuType.textColor = mGrayColor;
        }
        
        
        cell.layer.cornerRadius = 4;
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
        cell.contentView.userInteractionEnabled = NO;
        cell.lblTextLabel.textColor = [UIColor blackColor];

        
        
        NSInteger countColumn = 6;

        cell.vwTopBorder.backgroundColor = [UIColor clearColor];
        cell.vwBottomBorder.backgroundColor = [UIColor clearColor];
        cell.vwLeftBorder.backgroundColor = [UIColor clearColor];
        cell.vwRightBorder.backgroundColor = [UIColor clearColor];
        if((item/countColumn)%2 == 0)
        {
            cell.backgroundColor = mColVwBgColor;
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        {
            Ingredient *ingredient = _ingredientList[item/countColumn];
            cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
            switch (item%countColumn) {
                case 0:
                {
                    cell.lblTextLabel.text = ingredient.name;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                case 1:
                {
                    IngredientCheck *lastCheckStock =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_lastCheckStockList];
                    IngredientCheck *receiveStockBeforeToday =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockBeforeTodayList];
                    IngredientCheck *stockUse =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_stockUseList];
                    float amount = 0;
                    if(lastCheckStock)
                    {
                        amount += lastCheckStock.amount;
                    }
                    if(receiveStockBeforeToday)
                    {
                        amount += receiveStockBeforeToday.amount;
                    }
                    if(stockUse)
                    {
                        amount -= stockUse.amount;
                    }
                    if(lastCheckStock && !receiveStockBeforeToday && !stockUse)
                    {
                        cell.lblTextLabel.textColor = mGreen;
                    }

                    NSString *strAmount = [Utility formatDecimal:amount withMinFraction:0 andMaxFraction:4];
                    cell.lblTextLabel.text = strAmount;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case 2:
                {
                    IngredientCheck *receiveStockToday = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockTodayList];
                    float amount = 0;
                    if(receiveStockToday)
                    {
                        amount = receiveStockToday.amount;
                    }
                    NSString *strAmount = [Utility formatDecimal:amount withMinFraction:0 andMaxFraction:4];
                    cell.lblTextLabel.text = strAmount;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case 3:
                {
                    float stockBeforeToday = 0;
                    {
                        IngredientCheck *lastCheckStock =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_lastCheckStockList];
                        IngredientCheck *receiveStockBeforeToday =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockBeforeTodayList];
                        IngredientCheck *stockUse =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_stockUseList];
                        if(lastCheckStock)
                        {
                            stockBeforeToday += lastCheckStock.amount;
                        }
                        if(receiveStockBeforeToday)
                        {
                            stockBeforeToday += receiveStockBeforeToday.amount;
                        }
                        if(stockUse)
                        {
                            stockBeforeToday -= stockUse.amount;
                        }
                    }
                    
                    
                    float stockToday = 0;
                    {
                        IngredientCheck *receiveStockToday = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockTodayList];
                        if(receiveStockToday)
                        {
                            stockToday = receiveStockToday.amount;
                        }
                    }
                    float amount = stockBeforeToday + stockToday;
                    NSString *strAmount = [Utility formatDecimal:amount withMinFraction:0 andMaxFraction:4];
                    cell.lblTextLabel.text = strAmount;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case 4:
                {
                    float allStock = 0;
                    {
                        float stockBeforeToday = 0;
                        {
                            IngredientCheck *lastCheckStock =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_lastCheckStockList];
                            IngredientCheck *receiveStockBeforeToday =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockBeforeTodayList];
                            IngredientCheck *stockUse =  [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_stockUseList];
                            if(lastCheckStock)
                            {
                                stockBeforeToday += lastCheckStock.amount;
                            }
                            if(receiveStockBeforeToday)
                            {
                                stockBeforeToday += receiveStockBeforeToday.amount;
                            }
                            if(stockUse)
                            {
                                stockBeforeToday -= stockUse.amount;
                            }
                        }
                        
                        
                        float stockToday = 0;
                        {
                            IngredientCheck *receiveStockToday = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_receiveStockTodayList];
                            if(receiveStockToday)
                            {
                                stockToday = receiveStockToday.amount;
                            }
                        }
                        allStock = stockBeforeToday + stockToday;
                    }
                    
                    
                    IngredientCheck *stockSalesCon = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_stockSalesConList];
                    float amount = 0;
                    if(stockSalesCon)
                    {
                        amount = stockSalesCon.amount;
                    }
                    if(amount > allStock)
                    {
//                        cell.backgroundColor = mRed;
                        cell.lblTextLabel.textColor = mRed;
                    }
                    
                    
                    NSString *strAmount = [Utility formatDecimal:amount withMinFraction:0 andMaxFraction:4];
                    cell.lblTextLabel.text = strAmount;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case 5:
                {
                    cell.lblTextLabel.text = ingredient.uom;
                    cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwIngredientType])
    {
        CustomCollectionViewCellTabMenuType * cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.vwBottomBorder.hidden = YES;
        cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.lblMenuType.textColor = mBlueColor;
        cell.backgroundColor = mLightBlueColor;
        
        
        _selectedIndexIngredientType = indexPath.item;
        IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
        _ingredientList = [Ingredient getIngredientListWithIngredientTypeID:ingredientType.ingredientTypeID status:1];
        
        
        [colVwIngredient reloadData];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwIngredientType])
    {
        CustomCollectionViewCellTabMenuType* cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.vwBottomBorder.hidden = YES;
        cell.lblMenuType.font = [UIFont systemFontOfSize:15.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.lblMenuType.textColor = mGrayColor;
    }
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    if([collectionView isEqual:colVwIngredientType])
    {
        NSInteger countColumn = [_ingredientTypeList count];
        size = CGSizeMake(colVwIngredientType.frame.size.width/countColumn,44);
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        NSInteger countColumn = 6;
        size = CGSizeMake(colVwIngredient.frame.size.width/countColumn,44);
    }
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredientType.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwIngredientType reloadData];
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredient.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwIngredient reloadData];
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
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
        NSArray *headerColumn = @[@"\nรายการ",@"A\nสิ้นวันก่อนหน้า",@"B\nรับเข้ามาวันนี้",@"C=A+B\nปริมาณรวมวันนี้",@"D\nปริมาณที่ต้องการวันนี้",@"\nหน่วย"];
        NSInteger countColumn = [headerColumn count];
        float columnWidth = collectionView.frame.size.width/countColumn;
        for(int i=0; i<countColumn; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*columnWidth, 0, columnWidth, 44)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.text = headerColumn[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            label.backgroundColor = mBlueBackGroundColor;
            [headerView addSubview:label];
        }

        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    if([collectionView isEqual:colVwIngredient])
    {
        CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 44);
        return headerSize;
    }
    else
    {
        CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
        return headerSize;
    }
}

- (IBAction)ingredientCheck:(id)sender
{
    [self performSegueWithIdentifier:@"segIngredientCheck" sender:self];
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbIngredientNeeded)
    {
        _lastCheckStockList = [items[0] mutableCopy];
        _receiveStockBeforeTodayList = [items[1] mutableCopy];
        _stockUseList = [items[2] mutableCopy];
        _receiveStockTodayList = [items[3] mutableCopy];
        _stockSalesConList = [items[4] mutableCopy];
        
        
        
       
        [self selectIngredientType];
        [colVwIngredient reloadData];
        [self removeOverlayViews];
    }
}

-(void)downloadInventory
{
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    NSDate *date = [Utility stringToDate:txtDate.text fromFormat:@"d MMM yyyy"];
    NSDate *salesConStartDate = [Utility stringToDate:txtSalesConStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *salesConEndDate = [Utility stringToDate:txtSalesConEndDate.text fromFormat:@"d MMM yyyy"];
    NSNumber *expectedSales = [NSNumber numberWithFloat:[Utility floatValue:txtExpectedSales.text]];
    
    
    salesConStartDate = [Utility setStartOfTheDay:salesConStartDate];
    salesConEndDate = [Utility setEndOfTheDay:salesConEndDate];
    
    
    [self.homeModel downloadItems:dbIngredientNeeded withData:@[date,expectedSales,salesConStartDate,salesConEndDate]];
}
- (IBAction)inputIngredientReceive:(id)sender
{
    [self performSegueWithIdentifier:@"segIngredientReceive" sender:self];
}

- (IBAction)inputCustomSalesByMenu:(id)sender {
}
@end
