//
//  PromotionViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 3/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PromotionViewController.h"
#import "AddPromotionViewController.h"
#import "PromotionDateViewController.h"
#import "CustomCollectionViewCellReceiptHistoryListHeader.h"
#import "CustomCollectionViewCellReceiptHistoryList.h"
#import "Menu.h"
#import "SpecialPriceProgram.h"
#import "Utility.h"


@interface PromotionViewController ()
{
    NSMutableArray *_specialPriceProgramList;
    SpecialPriceProgram *_editSpecialPriceProgram;
}

@end

@implementation PromotionViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionViewCellReceiptHistoryListHeader";
static NSString * const reuseIdentifierReceiptHistoryList = @"CustomCollectionViewCellReceiptHistoryList";
@synthesize colVwPromotion;
@synthesize lblStartDate;
@synthesize lblEndDate;
@synthesize txtStartDate;
@synthesize txtEndDate;
@synthesize dtPicker;
@synthesize btnAdd;
@synthesize btnSelect;
@synthesize settingGroup;
@synthesize btnAction;

- (void)unwindToSettingDetail
{
    [self performSegueWithIdentifier:@"segUnwindToSettingDetail" sender:self];
}

- (IBAction)unwindToPromotion:(UIStoryboardSegue *)segue
{
    [self getDataList];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
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
    
    
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setStartOfTheDay:endDate];
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbSpecialPriceProgram withData:@[startDate,endDate]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:txtStartDate] || [textField isEqual:txtEndDate])
    {
        NSDate *datePeriod = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
        [dtPicker setDate:datePeriod];
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    if([txtStartDate isFirstResponder])
    {
        txtStartDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
    if([txtEndDate isFirstResponder])
    {
        txtEndDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

- (void)loadView
{
    [super loadView];
    
    
    
    
    txtStartDate.text = [Utility dateToString:[Utility setStartOfTheDay:[Utility currentDateTime]] toFormat:@"d MMM yyyy"];
    txtEndDate.text = [Utility dateToString:[Utility setStartOfTheDay:[Utility currentDateTime]] toFormat:@"d MMM yyyy"];
    txtStartDate.delegate = self;
    txtEndDate.delegate = self;
    txtStartDate.inputView = dtPicker;
    txtEndDate.inputView = dtPicker;
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    [self setShadow:colVwPromotion];
    [self setButtonDesign:btnAdd];
    [self setButtonDesign:btnSelect];
    [self setButtonDesign:btnAction];
    btnAction.enabled = NO;
    
    
    
    
    [self getDataList];
}

- (void)loadViewProcess
{
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    
    
    startDate = [Utility setStartOfTheDay:startDate];
    endDate = [Utility setStartOfTheDay:endDate];
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbSpecialPriceProgram withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    colVwPromotion.delegate = self;
    colVwPromotion.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptHistoryList bundle:nil];
        [colVwPromotion registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwPromotion registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwPromotion.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

-(void)viewDidLayoutSubviews
{
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_specialPriceProgramList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger item = indexPath.item;
    
    CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    
    SpecialPriceProgram *specialPriceProgram = _specialPriceProgramList[item];
    Menu *menu = [Menu getMenu:specialPriceProgram.menuID];
    NSString *strStartDate = [Utility dateToString:specialPriceProgram.startDate toFormat:@"dd MMM yyyy"];
    NSString *strEndDate = [Utility dateToString:specialPriceProgram.endDate toFormat:@"dd MMM yyyy"];
    cell.lblDateTime.text = [NSString stringWithFormat:@"%@ - %@",strStartDate,strEndDate];
    cell.lblReceiptNo.text = menu.titleThai;
    cell.lblTableName.text = [Utility formatDecimal:menu.price withMinFraction:0 andMaxFraction:2];
    cell.lblTotalAmount.text = [Utility formatDecimal:specialPriceProgram.specialPrice withMinFraction:0 andMaxFraction:2];
    [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressEditPromotion:)];
    [cell addGestureRecognizer:cell.longPressGestureRecognizer];
    
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    NSInteger item = indexPath.item;
    size = CGSizeMake(colVwPromotion.frame.size.width,44);
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwPromotion.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwPromotion reloadData];
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
        if([collectionView isEqual:colVwPromotion])
        {
            CustomCollectionViewCellReceiptHistoryListHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            headerView.backgroundColor = mLightBlueColor;
            headerView.lblDateTime.text = @"วันที่";
            headerView.lblReceiptNo.text = @"รายการอาหาร";
            headerView.lblTableName.text = @"ราคาปกติ";
            headerView.lblTotalAmount.text = @"ราคาลด";
            
            
            reusableview = headerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerPayment" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
    headerSize = CGSizeMake(collectionView.bounds.size.width, 44);
    
    return headerSize;
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbSpecialPriceProgram)
    {
        _specialPriceProgramList = [items[0] mutableCopy];
        [SpecialPriceProgram addList:_specialPriceProgramList];
        [self getDataList];
        
        
        
        [self removeOverlayViews];
    }
}

- (IBAction)addPromotion:(id)sender
{
    [self performSegueWithIdentifier:@"segAddPromotion" sender:self];
}

- (IBAction)copyPromotion:(id)sender
{
    
}

- (void)handleLongPressEditPromotion:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:colVwPromotion];
    NSIndexPath * tappedIP = [colVwPromotion indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwPromotion cellForItemAtIndexPath:tappedIP];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          _editSpecialPriceProgram = _specialPriceProgramList[tappedIP.item];
          [self performSegueWithIdentifier:@"segEditPromotion" sender:self];
          
      }]];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          UIAlertController* alert2 = [UIAlertController alertControllerWithTitle:nil
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยืนยันลบรายการ"
                                    style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
            {                
                _editSpecialPriceProgram = _specialPriceProgramList[tappedIP.item];
                [SpecialPriceProgram removeObject:_editSpecialPriceProgram];
                [self.homeModel deleteItems:dbSpecialPriceProgram withData:_editSpecialPriceProgram actionScreen:@"delete specialPriceProgram in promotion screen"];
                
                [self getDataList];
            }]];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยกเลิก"
                                    style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action) {}]];
          
          
          
          if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
          {
              [alert2 setModalPresentationStyle:UIModalPresentationPopover];
              
              UIPopoverPresentationController *popPresenter = [alert2 popoverPresentationController];
              CGRect frame = cell.bounds;
              frame.origin.y = frame.origin.y-15;
              popPresenter.sourceView = cell;
              popPresenter.sourceRect = frame;
          }
          
          
          [self presentViewController:alert2 animated:YES completion:nil];
          
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segEditPromotion"])
    {
        AddPromotionViewController *vc = segue.destinationViewController;
        vc.editSpecialPriceProgram = _editSpecialPriceProgram;
    }
}

- (void)getDataList
{
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    _specialPriceProgramList = [SpecialPriceProgram getSpecialPriceProgramListWithStartDate:startDate endDate:endDate];
    [colVwPromotion reloadData];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

- (IBAction)selectItems:(id)sender
{
    //clear selected row
    for (NSIndexPath *indexPath in [colVwPromotion indexPathsForSelectedItems])
    {
        [colVwPromotion deselectItemAtIndexPath:indexPath animated:NO];
        [self collectionView:colVwPromotion didDeselectItemAtIndexPath:indexPath];
    }
    if([btnSelect.titleLabel.text isEqualToString:@"เลือก"])
    {
        colVwPromotion.allowsMultipleSelection = YES;
        btnAction.enabled = YES;
        [btnSelect setTitle:@"ยกเลิก" forState:UIControlStateNormal];
    }
    else
    {
        colVwPromotion.allowsMultipleSelection = NO;
        btnAction.enabled = NO;
        [btnSelect setTitle:@"เลือก" forState:UIControlStateNormal];
    }
}

- (IBAction)doAction:(id)sender
{
    if(![self validateSelect])
    {
        return;
    }
    NSMutableArray *selectedPromotion = [[NSMutableArray alloc]init];
    NSArray *selectedIndexPath = colVwPromotion.indexPathsForSelectedItems;
    for(NSIndexPath *indexPath in selectedIndexPath)
    {
        SpecialPriceProgram *specialPriceProgram = _specialPriceProgramList[indexPath.item];
        [selectedPromotion addObject:specialPriceProgram];
    }
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"คัดลอก"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          PromotionDateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDateViewController"];
          controller.preferredContentSize = CGSizeMake(320, 44*4+58);
          controller.vc = self;
          controller.selectedSpecialPriceProgramList = [selectedPromotion mutableCopy];
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationFormSheet;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          
          
          
          CGRect frame = btnAction.frame;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = btnAction;
          popController.sourceRect = frame;
      }]];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {

          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          PromotionDateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDateViewController"];
          controller.preferredContentSize = CGSizeMake(320, 44*5+58);
          controller.vc = self;
          controller.selectedSpecialPriceProgramList = [selectedPromotion mutableCopy];
          controller.edit = 1;
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationFormSheet;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          
          
          
          CGRect frame = btnAction.frame;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = btnAction;
          popController.sourceRect = frame;
      }]];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          UIAlertController* alert2 = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยืนยันลบรายการ"
                                    style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
            {
                
                
                [SpecialPriceProgram removeList:selectedPromotion];
                [self.homeModel deleteItems:dbSpecialPriceProgramList withData:selectedPromotion actionScreen:@"deleteList specialPriceProgram"];
                [self getDataList];
            }]];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยกเลิก"
                                    style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action) {}]];
          
          
          
          if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
          {
              [alert2 setModalPresentationStyle:UIModalPresentationPopover];
              
              UIPopoverPresentationController *popPresenter = [alert2 popoverPresentationController];
              CGRect frame = btnAction.bounds;
              frame.origin.y = frame.origin.y-15;
              popPresenter.sourceView = btnAction;
              popPresenter.sourceRect = frame;
          }
          
          
          [self presentViewController:alert2 animated:YES completion:nil];
      }]];


    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];

        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = btnAction.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = btnAction;
        popPresenter.sourceRect = frame;
    }

    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)validateSelect
{
    NSArray *selectedPromotion = colVwPromotion.indexPathsForSelectedItems;
    if([selectedPromotion count] == 0)
    {
        [self showAlert:@"" message:@"กรุณาเลือกรายการโปรโมชั่น"];
        return NO;
    }
    return YES;
}
@end
