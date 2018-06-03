//
//  IngredientCheckViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientCheckViewController.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCell.h"
#import "CustomCollectionViewCellTextAndLabel.h"
#import "IngredientType.h"
#import "Ingredient.h"
#import "IngredientCheck.h"
#import "IngredientCheckOver.h"


@interface IngredientCheckViewController ()
{

    NSMutableArray *_ingredientTypeList;
    NSInteger _selectedIndexIngredientType;
    NSMutableArray *_lastCheckStockList;
    NSMutableArray *_receiveStockBeforePeriodList;
    NSMutableArray *_stockUseBeforePeriodList;
    NSMutableArray *_receiveStockPeriodList;
    NSMutableArray *_checkStockEndDayList;
    NSMutableArray *_stockSupposedToUsePeriodList;
    NSMutableArray *_ingredientList;
    NSMutableArray *_ingredientCheckOverList;
    NSMutableArray *_filterIngredientCheckOverList;
    NSMutableArray *_editingCheckStockEndDayList;
}
@end

@implementation IngredientCheckViewController
static NSString * const reuseHeaderViewIdentifier = @"Header";
static NSString * const reuseIdentifierTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierCell = @"CustomCollectionViewCell";
static NSString * const reuseIdentifierCellTextAndLabel = @"CustomCollectionViewCellTextAndLabel";



@synthesize colVwIngredientType;
@synthesize colVwIngredient;
@synthesize txtStartDate;
@synthesize txtEndDate;
@synthesize dtPicker;
@synthesize btnInventory;
@synthesize btnIngredientOver;
@synthesize btnFillInAmountEndDay;
@synthesize btnConfirm;
@synthesize btnCancel;


- (IBAction)unwindToMaterialInventory:(UIStoryboardSegue *)segue
{
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

- (void)viewDidLoad
{
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
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCellTextAndLabel bundle:nil];
        [colVwIngredient registerNib:nib forCellWithReuseIdentifier:reuseIdentifierCellTextAndLabel];
    }
    [colVwIngredient registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredient.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(![textField isEqual:txtStartDate] && ![textField isEqual:txtEndDate])
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        float holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanFloat: &holder] && [scan isAtEnd];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if([textField isEqual:txtStartDate] || [textField isEqual:txtEndDate])
    {
        if([textField isEqual:txtStartDate])
        {
            NSString *strStartDate = [Utility formatDate:txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            NSString *strEndDate = [Utility formatDate:txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            if(strStartDate>strEndDate)
            {
                txtEndDate.text = txtStartDate.text;
            }
        }
        else if([textField isEqual:txtEndDate])
        {
            NSString *strStartDate = [Utility formatDate:txtStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            NSString *strEndDate = [Utility formatDate:txtEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            if(strStartDate>strEndDate)
            {
                txtStartDate.text = txtEndDate.text;
            }
        }
        
        
        //download material inventory
        [self downloadInventory];
    }
    else
    {
        UICollectionViewCell *cell = (UICollectionViewCell *)[textField superview];
        NSIndexPath *indexPath = [colVwIngredient indexPathForCell:cell];
        
        
        
        NSInteger countColumn = 9;
        NSInteger row = indexPath.item/countColumn;
        Ingredient *ingredient = _ingredientList[row];
        switch (indexPath.item%countColumn) {
            case 3:
            {
                //amount
                IngredientCheck *ingredientCheck = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_editingCheckStockEndDayList];
                ingredientCheck.amount = [Utility floatValue:textField.text];
            }
                break;
            case 4:
            {
                //amount small
                IngredientCheck *ingredientCheck = [IngredientCheck getIngredientCheckWithIngredientID:ingredient.ingredientID ingredientCheckList:_editingCheckStockEndDayList];
                ingredientCheck.amountSmall = [Utility floatValue:textField.text];
            }
                break;
            default:
                break;
        }
        if([Utility isStringEmpty:textField.text])
        {
            textField.text = [NSString stringWithFormat:@"%d",0];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:txtStartDate] || [textField isEqual:txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
    else
    {
        if([Utility floatValue:textField.text] == 0)
        {
            textField.text = @"";
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([txtStartDate isFirstResponder])
    {
        txtStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    else if([txtEndDate isFirstResponder])
    {
        txtEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToInventory" sender:self];
}

- (void)loadView
{
    [super loadView];
    
    
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnCancel];
    [self setButtonDesign:btnInventory];
    [self setButtonDesign:btnIngredientOver];
    [self setButtonDesign:btnFillInAmountEndDay];
    [btnCancel setTitleColor:mRed forState:UIControlStateNormal];
    _selectedIndexIngredientType = 0;
    btnCancel.hidden = YES;
    btnConfirm.hidden = YES;
    btnFillInAmountEndDay.enabled = YES;
    btnIngredientOver.selected = NO;
    _ingredientCheckOverList = [[NSMutableArray alloc]init];
    
    

    txtStartDate.text = [Utility dateToString:[Utility getPreviousOrNextDay:-6 fromDate:[Utility currentDateTime]] toFormat:@"d MMM yyyy"];
    txtEndDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtStartDate.delegate = self;
    txtEndDate.delegate = self;
    txtStartDate.inputView = dtPicker;
    txtEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    [self loadViewProcess];
    
}

-(void)loadViewProcess
{
    [super loadViewProcess];
    
    _ingredientTypeList = [IngredientType getIngredientTypeListWithStatus:1];
    [colVwIngredientType reloadData];
    [self selectIngredientType];
    
    
    [self downloadInventory];
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
        NSInteger countColumn = 9;
        return ([_filterIngredientCheckOverList count])*countColumn;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.vwTopBorder.backgroundColor = [UIColor clearColor];
        cell.vwBottomBorder.backgroundColor = [UIColor clearColor];
        cell.vwLeftBorder.backgroundColor = [UIColor clearColor];
        cell.vwRightBorder.backgroundColor = [UIColor clearColor];
        
        
        NSInteger countColumn = 9;
        if((item/countColumn)%2 == 0)
        {
            cell.backgroundColor = mColVwBgColor;
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        
        if(btnFillInAmountEndDay.enabled)//view
        {
            {
                IngredientCheckOver *ingredientCheckOver = _filterIngredientCheckOverList[item/countColumn];
                cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                switch (item%countColumn) {
                    case 0:
                    {
                        cell.lblTextLabel.text = ingredientCheckOver.ingredientName;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                    }
                        break;
                    case 1:
                    {
                        if(ingredientCheckOver.checkStockAtBeforePeriod)
                        {
                            cell.lblTextLabel.textColor = mGreen;
                        }
                        
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountBeforePeriod withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 2:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountReceivePeriod withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 3:
                    {
                        NSString *strAmount = [Utility formatDecimal:(ingredientCheckOver.amountEndDay+ingredientCheckOver.amountSmallEndDay/ingredientCheckOver.smallAmount) withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 4:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountSupposedToUse withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 5:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountSupposedToBeLeft withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 6:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountActualUse withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 7:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountDiff withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                        if(ingredientCheckOver.amountDiff<0)
                        {
                            cell.lblTextLabel.textColor = mRed;
                        }
                    }
                        break;
                    case 8:
                    {
                        cell.lblTextLabel.text = ingredientCheckOver.uom;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        else//edit
        {
            {
                IngredientCheckOver *ingredientCheckOver = _filterIngredientCheckOverList[item/countColumn];
                cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                switch (item%countColumn) {
                    case 0:
                    {
                        cell.lblTextLabel.text = ingredientCheckOver.ingredientName;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                    }
                        break;
                    case 1:
                    {
                        if(ingredientCheckOver.checkStockAtBeforePeriod)
                        {
                            cell.lblTextLabel.textColor = mGreen;
                        }
                        
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountBeforePeriod withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 2:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountReceivePeriod withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 3:
                    {
                        CustomCollectionViewCellTextAndLabel *cell = (CustomCollectionViewCellTextAndLabel *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCellTextAndLabel forIndexPath:indexPath];
                        cell.contentView.userInteractionEnabled = NO;

                        cell.lblTextLabel.textColor = [UIColor blackColor];
                        
                        
                        
                        IngredientCheck *ingredientCheck = [IngredientCheck getIngredientCheckWithIngredientID:ingredientCheckOver.ingredientID ingredientCheckList:_editingCheckStockEndDayList];
                        NSString *strAmount = [Utility removeComma:[Utility formatDecimal:ingredientCheck.amount]];
                        cell.txtText.text = strAmount;
                        cell.txtText.delegate = self;
                        
                        
                        
                        cell.lblTextLabel.text = ingredientCheckOver.uom;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                        if((item/countColumn)%2 == 0)
                        {
                            cell.backgroundColor = mColVwBgColor;
                        }
                        else
                        {
                            cell.backgroundColor = [UIColor whiteColor];
                        }
                        return  cell;
                    }
                        break;
                    case 4:
                    {
                        CustomCollectionViewCellTextAndLabel *cell = (CustomCollectionViewCellTextAndLabel *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCellTextAndLabel forIndexPath:indexPath];
                        cell.contentView.userInteractionEnabled = NO;

                        cell.lblTextLabel.textColor = [UIColor blackColor];
                        
                        
                        IngredientCheck *ingredientCheck = [IngredientCheck getIngredientCheckWithIngredientID:ingredientCheckOver.ingredientID ingredientCheckList:_editingCheckStockEndDayList];
                        NSString *strAmountSmall = [Utility removeComma:[Utility formatDecimal:ingredientCheck.amountSmall]];
                        cell.txtText.text = strAmountSmall;
                        cell.txtText.delegate = self;
                        
                        
                        
                        cell.lblTextLabel.text = ingredientCheckOver.uomSmall;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                        if((item/countColumn)%2 == 0)
                        {
                            cell.backgroundColor = mColVwBgColor;
                        }
                        else
                        {
                            cell.backgroundColor = [UIColor whiteColor];
                        }
                        return  cell;
                    }
                        break;
                    case 5:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountSupposedToUse withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 6:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountSupposedToBeLeft withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 7:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountActualUse withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                        if(ingredientCheckOver.amountDiff<0)
                        {
                            cell.lblTextLabel.textColor = mRed;
                        }
                    }
                        break;
                    case 8:
                    {
                        NSString *strAmount = [Utility formatDecimal:ingredientCheckOver.amountDiff withMinFraction:0 andMaxFraction:4];
                        cell.lblTextLabel.text = strAmount;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                        
                    }
                        break;
                    default:
                        break;
                }
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
        
        
        
//        [self selectIngredientType];
        [self setIngredientCheckOver];
        [self setFilterIngredientCheckOverList];
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
        NSInteger countColumn = 9;
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
    
        NSArray *headerColumn;
        if(btnFillInAmountEndDay.enabled)
        {
            headerColumn = @[@"รายการ",@"A\nปริมาณเริ่มต้น\n",@"B\nรับเข้าระหว่างสัปดาห์",@"C\nปริมาณสิ้นวัน\n",@"D\nปริมาณที่ควรใช้\n",@"E=A+B-D\nปริมาณที่เหลือในระบบ",@"F=A+B-C\nปริมาณใช้จริง\n",@"G=E-F\nส่วนต่าง\n",@"หน่วย"];
        }
        else
        {
            headerColumn = @[@"รายการ",@"A\nปริมาณเริ่มต้น\n",@"B\nรับเข้าระหว่างสัปดาห์",@"C1\nปริมาณสิ้นวัน(หน่วยใหญ่)",@"C2\nปริมาณสิ้นวัน(หน่วยย่อย)",@"D\nปริมาณที่ควรใช้\n",@"E=A+B-D\nปริมาณที่เหลือในระบบ",@"F=A+B-C\nปริมาณใช้จริง\n",@"G=E-F\nส่วนต่าง\n"];
        }
    

        NSInteger countColumn = [headerColumn count];
        float columnWidth = collectionView.frame.size.width/countColumn;
        for(int i=0; i<countColumn; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*columnWidth, 0, columnWidth, 66)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.text = headerColumn[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 3;
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
        CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 66);
        return headerSize;
    }
    else
    {
        CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
        return headerSize;
    }
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbIngredientCheckList)
    {
        _lastCheckStockList = [items[0] mutableCopy];
        _receiveStockBeforePeriodList = [items[1] mutableCopy];
        _stockUseBeforePeriodList = [items[2] mutableCopy];
        _receiveStockPeriodList = [items[3] mutableCopy];
        _checkStockEndDayList = [items[4] mutableCopy];
        _stockSupposedToUsePeriodList = [items[5] mutableCopy];
        
        
        
        [self selectIngredientType];
        [self setIngredientCheckOver];
        [self setFilterIngredientCheckOverList];
        
        
        [colVwIngredient reloadData];
        [self removeOverlayViews];
    }
}

-(void)setFilterIngredientCheckOverList
{
    if(btnIngredientOver.selected)//สรุปวัตถุดิบใช้เกิน
    {
        _filterIngredientCheckOverList = [IngredientCheckOver getIngredientCheckOverListWithAmountDiffLessThanZero:_ingredientCheckOverList];
    }
    else
    {
        _filterIngredientCheckOverList = _ingredientCheckOverList;
    }
}
-(void)downloadInventory
{
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    [self.homeModel downloadItems:dbIngredientCheckList withData:@[startDate,endDate]];
}

- (IBAction)inventory:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToInventory" sender:self];
}

- (IBAction)ingredientOver:(id)sender
{
    btnIngredientOver.selected = !btnIngredientOver.selected;
    if(btnIngredientOver.selected)//สรุปวัตถุดิบใช้เกิน
    {
        [btnIngredientOver setTitle:@"แสดงวัตถุดิบทั้งหมด" forState:UIControlStateNormal];
        _filterIngredientCheckOverList = [IngredientCheckOver getIngredientCheckOverListWithAmountDiffLessThanZero:_ingredientCheckOverList];
    }
    else
    {
        [btnIngredientOver setTitle:@"สรุปวัตถุดิบใช้เกิน" forState:UIControlStateNormal];
        _filterIngredientCheckOverList = _ingredientCheckOverList;
    }
    [colVwIngredient reloadData];
}

- (IBAction)fillInAmountEndDay:(id)sender
{
    btnFillInAmountEndDay.enabled = NO;
    btnCancel.hidden = NO;
    btnConfirm.hidden = NO;
    
    _editingCheckStockEndDayList = [IngredientCheck copy:_checkStockEndDayList];
    [colVwIngredient reloadData];
}

- (IBAction)confirm:(id)sender
{
    
    
    
    //save -> delete then insert
    for(IngredientCheck *item in _editingCheckStockEndDayList)
    {
        item.checkDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
    }
    [IngredientCheck copyFrom:_editingCheckStockEndDayList to:_checkStockEndDayList];
    [self loadingOverlayView];
    
    
    
    //download data
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setEndOfTheDay:endDate];
    
    
    
    [self.homeModel insertItems:dbIngredientCheckList withData:@[_editingCheckStockEndDayList,startDate,endDate] actionScreen:@"delete if any then insert ingredientCheck"];

}

- (IBAction)cancel:(id)sender
{
    btnFillInAmountEndDay.enabled = YES;
    btnCancel.hidden = YES;
    btnConfirm.hidden = YES;
    [colVwIngredient reloadData];
}

- (void)itemsInsertedWithReturnData:(NSArray *)items
{
    
    btnFillInAmountEndDay.enabled = YES;
    btnCancel.hidden = YES;
    btnConfirm.hidden = YES;

    
    
    
    //items downloaded
    _lastCheckStockList = [items[0] mutableCopy];
    _receiveStockBeforePeriodList = [items[1] mutableCopy];
    _stockUseBeforePeriodList = [items[2] mutableCopy];
    _receiveStockPeriodList = [items[3] mutableCopy];
    _checkStockEndDayList = [items[4] mutableCopy];
    _stockSupposedToUsePeriodList = [items[5] mutableCopy];
    
    

    
    [self selectIngredientType];
    [self setIngredientCheckOver];
    [self setFilterIngredientCheckOverList];
    
    

    
    [colVwIngredient reloadData];
    [self removeOverlayViews];
}

- (void)setIngredientCheckOver
{
    [_ingredientCheckOverList removeAllObjects];
    
    
    for(Ingredient *item in _ingredientList)
    {
        IngredientCheckOver *ingredientCheckOver = [[IngredientCheckOver alloc]init];
        
        
        ingredientCheckOver.ingredientID = item.ingredientID;
        ingredientCheckOver.ingredientName = item.name;
        
        
        //A
        {
            IngredientCheck *lastCheckStock =  [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_lastCheckStockList];
            IngredientCheck *receiveStockBeforePeriod =  [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_receiveStockBeforePeriodList];
            IngredientCheck *stockUse =  [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_stockUseBeforePeriodList];
            float amount = 0;
            if(lastCheckStock)
            {
                amount += lastCheckStock.amount;
            }
            if(receiveStockBeforePeriod)
            {
                amount += receiveStockBeforePeriod.amount;
            }
            if(stockUse)
            {
                amount -= stockUse.amount;
            }
            ingredientCheckOver.amountBeforePeriod = amount;
            ingredientCheckOver.checkStockAtBeforePeriod = lastCheckStock && !receiveStockBeforePeriod && !stockUse;
            
        }
        
        //B
        {
            IngredientCheck *receiveStockPeriod = [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_receiveStockPeriodList];
            float amount = 0;
            if(receiveStockPeriod)
            {
                amount = receiveStockPeriod.amount;
            }
            ingredientCheckOver.amountReceivePeriod = amount;
        }
        
        //C
        {
            IngredientCheck *checkStockEndDay = [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_checkStockEndDayList];
            float amount = 0;
            float amountSmall = 0;
            if(checkStockEndDay)
            {
                amount = checkStockEndDay.amount;
                amountSmall = checkStockEndDay.amountSmall;
            }
            ingredientCheckOver.amountEndDay = amount;
            ingredientCheckOver.amountSmallEndDay = amountSmall;
        }
        
        //D
        {
            IngredientCheck *stockSupposedToUsePeriod = [IngredientCheck getIngredientCheckWithIngredientID:item.ingredientID ingredientCheckList:_stockSupposedToUsePeriodList];
            float amount = 0;
            if(stockSupposedToUsePeriod)
            {
                amount = stockSupposedToUsePeriod.amount;
            }
            ingredientCheckOver.amountSupposedToUse = amount;
        }
        
        
        //E
        ingredientCheckOver.amountSupposedToBeLeft = ingredientCheckOver.amountBeforePeriod + ingredientCheckOver.amountReceivePeriod - ingredientCheckOver.amountSupposedToUse;
        
        
        //F
        ingredientCheckOver.amountActualUse = ingredientCheckOver.amountBeforePeriod + ingredientCheckOver.amountReceivePeriod - (ingredientCheckOver.amountEndDay+ingredientCheckOver.amountSmallEndDay/item.smallAmount);
        
        //G
        ingredientCheckOver.amountDiff = ingredientCheckOver.amountSupposedToBeLeft - ingredientCheckOver.amountActualUse;
        
        
        ingredientCheckOver.uom = item.uom;
        ingredientCheckOver.uomSmall = item.uomSmall;
        ingredientCheckOver.smallAmount = item.smallAmount;
        
        
        
        [_ingredientCheckOverList addObject:ingredientCheckOver];
    }
}
@end
