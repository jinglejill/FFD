//
//  IngredientReceiveViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientReceiveViewController.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCell.h"
#import "CustomCollectionViewCellTextAndLabel.h"
#import "IngredientType.h"
#import "Ingredient.h"
#import "IngredientReceive.h"



@interface IngredientReceiveViewController ()
{
    NSMutableArray *_ingredientTypeList;
    NSInteger _selectedIndexIngredientType;
    NSInteger _selectedIndexHistory;
    NSMutableArray *_historyIngredientReceiveGroupList;
    NSMutableArray *_historyIngredientReceiveList;
    NSMutableArray *_ingredientReceiveList;
    NSMutableArray *_editIngredientReceive;
    
    
    NSMutableArray *_firstLoadIngredientReceive;
    NSMutableArray *_editingIngredientReceive;
    NSInteger addEditView;//1,2,3
}
@end

@implementation IngredientReceiveViewController
static NSString * const reuseHeaderViewIdentifier = @"Header";
static NSString * const reuseIdentifierTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierCell = @"CustomCollectionViewCell";
static NSString * const reuseIdentifierCellTextAndLabel = @"CustomCollectionViewCellTextAndLabel";



@synthesize lblReceiveDate;
@synthesize txtReceiveDate;
@synthesize colVwIngredientReceive;
@synthesize dtPicker;
@synthesize txtHistoryStartDate;
@synthesize colVwHistory;
@synthesize txtHistoryEndDate;
@synthesize colVwIngredientType;
@synthesize btnAddIngredientReceive;
@synthesize btnConfirm;
@synthesize btnClearData;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    {
        CGRect frame = colVwIngredientType.frame;
        frame.size.width = self.view.frame.size.width-colVwHistory.frame.size.width-8;
        colVwIngredientType.frame = frame;
    }
    {
        CGRect frame = colVwIngredientReceive.frame;
        frame.size.width = self.view.frame.size.width-colVwHistory.frame.size.width-8;
        colVwIngredientReceive.frame = frame;
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
    
    colVwIngredientReceive.dataSource = self;
    colVwIngredientReceive.delegate = self;
    
    
    colVwHistory.dataSource = self;
    colVwHistory.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTabMenuType bundle:nil];
        [colVwIngredientType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierTabMenuType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCell bundle:nil];
        [colVwIngredientReceive registerNib:nib forCellWithReuseIdentifier:reuseIdentifierCell];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCellTextAndLabel bundle:nil];
        [colVwIngredientReceive registerNib:nib forCellWithReuseIdentifier:reuseIdentifierCellTextAndLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCell bundle:nil];
        [colVwHistory registerNib:nib forCellWithReuseIdentifier:reuseIdentifierCell];
    }
    
    
    [colVwIngredientReceive registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    [colVwHistory registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredientReceive.collectionViewLayout;
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwHistory.collectionViewLayout;
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(![textField isEqual:txtReceiveDate] && ![textField isEqual:txtHistoryStartDate] && ![textField isEqual:txtHistoryEndDate])
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
    if([textField isEqual:txtHistoryStartDate] || [textField isEqual:txtHistoryEndDate])
    {
        if([textField isEqual:txtHistoryStartDate])
        {
            NSString *strStartDate = [Utility formatDate:txtHistoryStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            NSString *strEndDate = [Utility formatDate:txtHistoryEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            if(strStartDate>strEndDate)
            {
                txtHistoryEndDate.text = txtHistoryStartDate.text;
            }
        }
        else if([textField isEqual:txtHistoryEndDate])
        {
            NSString *strStartDate = [Utility formatDate:txtHistoryStartDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            NSString *strEndDate = [Utility formatDate:txtHistoryEndDate.text fromFormat:@"d MMM yyyy" toFormat:@"yyyyMMdd"];
            if(strStartDate>strEndDate)
            {
                txtHistoryStartDate.text = txtHistoryEndDate.text;
            }
        }
        
        
        
        //download ingredientReceive
        [self downloadHistoryIngredientReceiveList];
    }
    else if([textField isEqual:txtReceiveDate])
    {
        //do nothing
    }
    else
    {
        UICollectionViewCell *cell = (UICollectionViewCell *)[textField superview];
        NSIndexPath *indexPath = [colVwIngredientReceive indexPathForCell:cell];
        
        
        
        NSInteger countColumn = 4;
        NSInteger row = indexPath.item/countColumn;
        IngredientReceive *ingredientReceive = _ingredientReceiveList[row];
        switch (indexPath.item%countColumn)
        {
            case 1:
            {
                //amount
                ingredientReceive.amount = [Utility floatValue:textField.text];
            }
                break;
            case 2:
            {
                //amount small
                ingredientReceive.amountSmall = [Utility floatValue:textField.text];
            }
                break;
            case 3:
            {
                //price
                ingredientReceive.price = [Utility floatValue:textField.text];
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
    if([textField isEqual:txtReceiveDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy HH:mm"];
        dtPicker.datePickerMode = UIDatePickerModeDateAndTime;
        [dtPicker setDate:datePeriod];
    }
    else if([textField isEqual:txtHistoryStartDate] || [textField isEqual:txtHistoryEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        dtPicker.datePickerMode = UIDatePickerModeDate;
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
    if([txtReceiveDate isFirstResponder])
    {
        txtReceiveDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy HH:mm"];
    }
    else if([txtHistoryStartDate isFirstResponder])
    {
        txtHistoryStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    else if([txtHistoryEndDate isFirstResponder])
    {
        txtHistoryEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (void)loadView
{
    [super loadView];
    
    
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnClearData];
    [self setButtonDesign:btnAddIngredientReceive];
    [btnClearData setTitleColor:mRed forState:UIControlStateNormal];
    _selectedIndexIngredientType = 0;
    _selectedIndexHistory = 0;
    addEditView = 1;
    btnConfirm.hidden = NO;
    btnClearData.hidden = NO;
    
    
    
    txtReceiveDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy HH:mm"];
    txtHistoryStartDate.text = [Utility dateToString:[Utility getPrevious14Days] toFormat:@"d MMM yyyy"];
    txtHistoryEndDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
    txtReceiveDate.delegate = self;
    txtHistoryStartDate.delegate = self;
    txtHistoryEndDate.delegate = self;
    txtReceiveDate.inputView = dtPicker;
    txtHistoryStartDate.inputView = dtPicker;
    txtHistoryEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    
    btnAddIngredientReceive.enabled = NO;
    _firstLoadIngredientReceive = [IngredientReceive getIngredientReceiveList];
    _editingIngredientReceive = [IngredientReceive copy:_firstLoadIngredientReceive];
    
    
    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    [super loadViewProcess];
    
    _ingredientTypeList = [IngredientType getIngredientTypeListWithStatus:1];
    [self selectIngredientType];
    [self downloadHistoryIngredientReceiveList];
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

- (void)selectHistoryReceiveDate
{
    if([_historyIngredientReceiveGroupList count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexHistory inSection:0];
        [colVwHistory selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:colVwHistory didSelectItemAtIndexPath:indexPath];
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
    else if([collectionView isEqual:colVwIngredientReceive])
    {
        NSInteger countColumn = 4;
        return ([_ingredientReceiveList count])*countColumn;
    }
    else if([collectionView isEqual:colVwHistory])
    {
        NSInteger countColumn = 1;
        return ([_historyIngredientReceiveGroupList count])*countColumn;
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
    else if([collectionView isEqual:colVwIngredientReceive])
    {
        NSInteger countColumn = 4;
        {
            CustomCollectionViewCellTextAndLabel *cell = (CustomCollectionViewCellTextAndLabel*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCellTextAndLabel forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            if((item/countColumn)%2 == 0)
            {
                cell.backgroundColor = mColVwBgColor;
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            if(addEditView == 1 || addEditView == 2)
            {
                IngredientReceive *ingredientReceive = _ingredientReceiveList[item/countColumn];
                Ingredient *ingredient = [Ingredient getIngredient:ingredientReceive.ingredientID];
                switch (item%countColumn) {
                    case 0:
                    {
                        
                        CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
                        cell.contentView.userInteractionEnabled = NO;


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
                        
                        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                        cell.lblTextLabel.text = ingredient.name;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                        
                        
                        return cell;
                    }
                        break;
                    case 1:
                    {
                        cell.txtText.keyboardType = UIKeyboardTypeDecimalPad;
                        cell.txtText.delegate = self;
                        cell.txtText.text = [Utility removeComma:[Utility formatDecimal:ingredientReceive.amount]];
                        cell.lblTextLabel.text = ingredient.uom;
                    }
                        break;
                    case 2:
                    {
                        cell.txtText.keyboardType = UIKeyboardTypeDecimalPad;
                        cell.txtText.delegate = self;
                        cell.txtText.text = [Utility removeComma:[Utility formatDecimal:ingredientReceive.amountSmall]];
                        cell.lblTextLabel.text = ingredient.uomSmall;
                    }
                        break;
                    case 3:
                    {
                        cell.txtText.keyboardType = UIKeyboardTypeDecimalPad;
                        cell.txtText.delegate = self;
                        cell.txtText.text = [Utility formatDecimal:ingredientReceive.price withMinFraction:0 andMaxFraction:9];
                        cell.lblTextLabel.text = @"บาท";
                    }
                        break;
                    default:
                        break;
                }
            }
            else if(addEditView == 3)//view
            {
                CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
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
                
                
                IngredientReceive *ingredientReceive = _ingredientReceiveList[item/countColumn];
                Ingredient *ingredient = [Ingredient getIngredient:ingredientReceive.ingredientID];
                switch (item%countColumn)
                {
                    case 0:
                    {
                        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                        cell.lblTextLabel.text = ingredient.name;
                        cell.lblTextLabel.textAlignment = NSTextAlignmentLeft;
                    }
                        break;
                    case 1:
                    {
                        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];                        
                        
                        
                        NSString *strAmount = [Utility formatDecimal:ingredientReceive.amount withMinFraction:0 andMaxFraction:9];
                        cell.lblTextLabel.text = [NSString stringWithFormat:@"%@ %@",strAmount,ingredient.uom];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 2:
                    {
                        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                        
                        
                        NSString *strAmountSmall = [Utility formatDecimal:ingredientReceive.amountSmall withMinFraction:0 andMaxFraction:9];
                        cell.lblTextLabel.text = [NSString stringWithFormat:@"%@ %@",strAmountSmall,ingredient.uomSmall];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 3:
                    {
                        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
                        
                        
                        NSString *strPrice = [Utility formatDecimal:ingredientReceive.price withMinFraction:0 andMaxFraction:9];
                        cell.lblTextLabel.text = [NSString stringWithFormat:@"%@ บาท",strPrice];
                        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                        
                    default:
                        break;
                }
                return cell;
            }
            
            return cell;
        }
    }
    else if([collectionView isEqual:colVwHistory])
    {
        CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
        
        
        NSInteger countColumn = 1;
        cell.contentView.userInteractionEnabled = NO;
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
        
        IngredientReceive *ingredientReceive = _historyIngredientReceiveGroupList[indexPath.item];
        cell.lblTextLabel.font = [UIFont systemFontOfSize:15];
        cell.lblTextLabel.text = [Utility dateToString:ingredientReceive.receiveDate toFormat:@"d MMM yyyy HH:mm"];
        cell.lblTextLabel.textAlignment = NSTextAlignmentCenter;
        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
        [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressHistoryIngredientReceive:)];
        [cell addGestureRecognizer:cell.longPressGestureRecognizer];
        
        
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
        _ingredientReceiveList = [IngredientReceive getIngredientReceiveListWithIngredientTypeID:ingredientType.ingredientTypeID ingredientReceiveList:_editingIngredientReceive];
        _ingredientReceiveList = [IngredientReceive sortList:_ingredientReceiveList];
        
        
        [colVwIngredientReceive reloadData];
        
    }
    else if([collectionView isEqual:colVwHistory])
    {
        _selectedIndexHistory = indexPath.item;
        addEditView = 3;//view
        txtReceiveDate.enabled = NO;
        btnConfirm.hidden = YES;
        btnClearData.hidden = YES;
        CustomCollectionViewCell * cell = (CustomCollectionViewCell *)[colVwHistory cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = mLightBlueColor;
        
        
        if(indexPath.item > [_historyIngredientReceiveGroupList count])
        {
            _editIngredientReceive = [[NSMutableArray alloc]init];
            txtReceiveDate.text = @"";
        }
        else
        {
            IngredientReceive *ingredientReceive = _historyIngredientReceiveGroupList[indexPath.item];
            txtReceiveDate.text = [Utility dateToString:ingredientReceive.receiveDate toFormat:@"d MMM yyyy HH:mm"];
            _editIngredientReceive = [IngredientReceive getIngredientReceiveListWithReceiveDate:ingredientReceive.receiveDate ingredientReceiveList:_historyIngredientReceiveList];
            [IngredientReceive copyFrom:_editIngredientReceive to:_editingIngredientReceive];
        }
        
        
        [self selectIngredientType];
        
        btnAddIngredientReceive.enabled = YES;
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
    else if([collectionView isEqual:colVwHistory])
    {
        CustomCollectionViewCell * cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor clearColor];
        NSInteger countColumn = 1;
        if((indexPath.item/countColumn)%2 == 0)
        {
            cell.backgroundColor = mColVwBgColor;
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
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
    else if([collectionView isEqual:colVwIngredientReceive])
    {
        NSInteger countColumn = 4;
        size = CGSizeMake(colVwIngredientReceive.frame.size.width/countColumn,44);
    }
    else if([collectionView isEqual:colVwHistory])
    {
        size = CGSizeMake(colVwHistory.frame.size.width, 44);
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
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwIngredientReceive.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwIngredientReceive reloadData];
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
        if([collectionView isEqual:colVwIngredientReceive])
        {
            headerColumn = @[@"รายการ",@"จำนวน(หน่วยหลัก)",@"จำนวน(หน่วยย่อย)",@"ราคา"];
        }
        else
        {
            headerColumn = @[@"วันที่"];
        }
        
        
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
    if([collectionView isEqual:colVwIngredientReceive] || [collectionView isEqual:colVwHistory])
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

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbIngredientReceiveList)
    {
        _historyIngredientReceiveGroupList = [items[0] mutableCopy];
        _historyIngredientReceiveList = [items[1] mutableCopy];
        _historyIngredientReceiveGroupList = [IngredientReceive sortListByReceiveDate:_historyIngredientReceiveGroupList];
        
        
        _selectedIndexHistory = 0;
        [self removeOverlayViews];
        
        
        [colVwHistory reloadData];
    }
}

-(void)downloadHistoryIngredientReceiveList
{
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    NSDate *historyStartDate = [Utility stringToDate:txtHistoryStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *historyEndDate = [Utility stringToDate:txtHistoryEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    historyStartDate = [Utility setStartOfTheDay:historyStartDate];
    historyEndDate = [Utility setStartOfTheDay:historyEndDate];
    
    
    [self.homeModel downloadItems:dbIngredientReceiveList withData:@[historyStartDate,historyEndDate]];
}

- (IBAction)addIngredientReceive:(id)sender
{
    addEditView = 1;
    txtReceiveDate.enabled = YES;
    btnConfirm.hidden = NO;
    btnClearData.hidden = NO;
    txtReceiveDate.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy HH:mm"];
    btnAddIngredientReceive.enabled = NO;
    _firstLoadIngredientReceive = [IngredientReceive getIngredientReceiveList];
    _editingIngredientReceive = [IngredientReceive copy:_firstLoadIngredientReceive];
    [self selectIngredientType];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexHistory inSection:0];
    [self collectionView:colVwHistory didDeselectItemAtIndexPath:indexPath];

}

- (void)handleLongPressHistoryIngredientReceive:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:colVwHistory];
    NSIndexPath * tappedIP = [colVwHistory indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwHistory cellForItemAtIndexPath:tappedIP];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexHistory inSection:0];
          [self collectionView:colVwHistory didDeselectItemAtIndexPath:indexPath];
          _selectedIndexHistory = tappedIP.item;
          
          
          
          [self selectHistoryReceiveDate];
          btnConfirm.hidden = NO;
          btnClearData.hidden = NO;
          addEditView = 2;
          
          [colVwIngredientReceive reloadData];
          

      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action)
                            {                                
                                IngredientReceive *ingredientReceive = _historyIngredientReceiveGroupList[tappedIP.item-1];
                                [self.homeModel deleteItems:dbIngredientReceiveList withData:ingredientReceive.receiveDate actionScreen:@"delete ingredientReceive with receiptDate"];
                                [_historyIngredientReceiveGroupList removeObject:ingredientReceive];
                                [colVwHistory reloadData];
                                
                                
                                if(addEditView == 3)
                                {
                                    [self selectHistoryReceiveDate];
                                }
                                else if(addEditView == 2)
                                {
                                
                                }
                                
                                
                            }]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = cell.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)confirmAddEdit:(id)sender
{
    if(addEditView == 1)
    {
        //check edit
        {}
        
        
        
        //add -> copy from _editingIngredientReceive -> _firstLoadIngredientReceive
        for(IngredientReceive *item in _editingIngredientReceive)
        {
            item.receiveDate = [Utility stringToDate:txtReceiveDate.text fromFormat:@"d MMM yyyy HH:mm"];
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        [IngredientReceive copyFrom:_editingIngredientReceive to:_firstLoadIngredientReceive];
        [self loadingOverlayView];
        
        
        
        //download data
        NSDate *historyStartDate = [Utility stringToDate:txtHistoryStartDate.text fromFormat:@"d MMM yyyy"];
        NSDate *historyEndDate = [Utility stringToDate:txtHistoryEndDate.text fromFormat:@"d MMM yyyy"];
        historyStartDate = [Utility setStartOfTheDay:historyStartDate];
        historyEndDate = [Utility setStartOfTheDay:historyEndDate];
        
        
        
        [self.homeModel insertItems:dbIngredientReceiveList withData:@[_editingIngredientReceive,historyStartDate,historyEndDate] actionScreen:@"insert ingredientReceiveList and load ingredientReceiveHistory in ingredientReceive screen"];
        
    }
    else if(addEditView == 2)
    {
        //check edit
        {}
        
        
        
        //edit
        for(IngredientReceive *item in _editingIngredientReceive)
        {            
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
        }
        [IngredientReceive copyFrom:_editingIngredientReceive to:_editIngredientReceive];
        [self.homeModel updateItems:dbIngredientReceiveList withData:_editingIngredientReceive actionScreen:@"update ingredientReceiveList in ingredientReceive screen"];
        addEditView = 3;
        btnConfirm.hidden = YES;
        btnClearData.hidden = YES;
        [self selectIngredientType];
    }
}

- (IBAction)clearData:(id)sender
{
    if(addEditView == 1)//add
    {
        [IngredientReceive copyFrom:_firstLoadIngredientReceive to:_editingIngredientReceive];
        [colVwIngredientReceive reloadData];
    }
    else if(addEditView == 2)//edit
    {
        [IngredientReceive copyFrom:_editIngredientReceive to:_editingIngredientReceive];
        [colVwIngredientReceive reloadData];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToInventory" sender:self];
}

- (void)itemsInsertedWithReturnData:(NSArray *)items
{

    addEditView = 3;
    txtReceiveDate.enabled = NO;
    btnConfirm.hidden = YES;
    btnClearData.hidden = YES;
    [self selectIngredientType];
    btnAddIngredientReceive.enabled = YES;
    
    
    
    
    //items downloaded
    _historyIngredientReceiveGroupList = [items[0] mutableCopy];
    _historyIngredientReceiveList = [items[1] mutableCopy];
    
    
    _selectedIndexHistory = 0;
    [colVwHistory reloadData];
    
    
    [self removeOverlayViews];
    
    
    
    
    
    
    
    
    //download history
//    NSDate *historyStartDate = [Utility stringToDate:txtHistoryStartDate.text fromFormat:@"d MMM yyyy"];
//    NSDate *historyEndDate = [Utility stringToDate:txtHistoryEndDate.text fromFormat:@"d MMM yyyy"];
//    NSDate *receiveDate = [Utility stringToDate:txtReceiveDate.text fromFormat:@"d MMM yyyy HH:mm"];
//    receiveDate = [Utility setStartOfTheDay:receiveDate];
//    if(historyStartDate <= receiveDate && historyEndDate >= receiveDate)
//    {
//        [self downloadHistoryIngredientReceiveList];
//    }
}
@end
