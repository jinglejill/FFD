//
//  RewardProgramViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 8/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardProgramViewController.h"
#import "RewardProgramAddViewController.h"
#import "CustomCollectionViewCellReceiptHistoryListHeader.h"
#import "CustomCollectionViewCellReceiptHistoryList.h"
#import "RewardProgram.h"
#import "Utility.h"


@interface RewardProgramViewController ()
{
    NSMutableArray *_rewardProgramList;
    RewardProgram *_editRewardProgram;
}
@end

@implementation RewardProgramViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionViewCellReceiptHistoryListHeader";
static NSString * const reuseIdentifierReceiptHistoryList = @"CustomCollectionViewCellReceiptHistoryList";
@synthesize colVwRewardProgram;
@synthesize lblStartDate;
@synthesize lblEndDate;
@synthesize txtStartDate;
@synthesize txtEndDate;
@synthesize dtPicker;
@synthesize btnAdd;
@synthesize settingGroup;
@synthesize segConType;

- (void)unwindToSettingDetail
{
    [self performSegueWithIdentifier:@"segUnwindToSettingDetail" sender:self];
}

- (IBAction)unwindToRewardProgram:(UIStoryboardSegue *)segue
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
    [self.homeModel downloadItems:dbRewardProgram withData:@[startDate,endDate]];
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
    
    
    
    [self setShadow:colVwRewardProgram];
    [self setButtonDesign:btnAdd];
    
    
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
    [self.homeModel downloadItems:dbRewardProgram withData:@[startDate,endDate]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    colVwRewardProgram.delegate = self;
    colVwRewardProgram.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptHistoryList bundle:nil];
        [colVwRewardProgram registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwRewardProgram registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwRewardProgram.collectionViewLayout;
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
    return [_rewardProgramList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    CustomCollectionViewCellReceiptHistoryList *cell = (CustomCollectionViewCellReceiptHistoryList*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptHistoryList forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    

    RewardProgram *rewardProgram = _rewardProgramList[item];
    
    NSString *strStartDate = [Utility dateToString:rewardProgram.startDate toFormat:@"dd MMM yyyy"];
    NSString *strEndDate = [Utility dateToString:rewardProgram.endDate toFormat:@"dd MMM yyyy"];
    cell.lblDateTime.text = [NSString stringWithFormat:@"%@ - %@",strStartDate,strEndDate];
    cell.lblReceiptNo.text = rewardProgram.type == 1?@"สะสมแต้ม":@"ใช้แต้ม";
    if(rewardProgram.type == 1)
    {
        cell.lblTotalAmount.textAlignment = NSTextAlignmentCenter;
        cell.lblTableName.text = [Utility formatDecimal:rewardProgram.salesSpent withMinFraction:0 andMaxFraction:0];
        cell.lblTotalAmount.text = [Utility formatDecimal:rewardProgram.receivePoint withMinFraction:0 andMaxFraction:2];
    }
    else
    {
        NSString *strDiscountAmount = [Utility formatDecimal:rewardProgram.discountAmount withMinFraction:0 andMaxFraction:2];
        NSString *strDiscountType = rewardProgram.discountType==1?@" บาท":@"%";
        cell.lblTotalAmount.textAlignment = NSTextAlignmentCenter;
        cell.lblTableName.text = [Utility formatDecimal:rewardProgram.pointSpent withMinFraction:0 andMaxFraction:0];
        cell.lblTotalAmount.text = [NSString stringWithFormat:@"%@%@",strDiscountAmount,strDiscountType];
    }
    
    [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressEditRewardProgram:)];
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
    size = CGSizeMake(colVwRewardProgram.frame.size.width,44);
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwRewardProgram.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwRewardProgram reloadData];
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
        if([collectionView isEqual:colVwRewardProgram])
        {
            CustomCollectionViewCellReceiptHistoryListHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            headerView.backgroundColor = mLightBlueColor;
            headerView.lblDateTime.text = @"วันที่";
            headerView.lblReceiptNo.text = @"ประเภท";//สะสมแต้ม,ใช้แต้ม
            headerView.lblTableName.text = @"ใช้จ่าย(บาท)";
            headerView.lblTotalAmount.text = @"ได้รับแต้ม";
            
            
            headerView.lblDateTime.text = @"วันที่";
            headerView.lblReceiptNo.text = @"ประเภท";
            headerView.lblTableName.text = @"ใช้แต้ม";
            headerView.lblTotalAmount.text = @"แลกส่วนลด";
            
            
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
    
    if(self.homeModel.propCurrentDB == dbRewardProgram)
    {
        _rewardProgramList = [items[0] mutableCopy];
        [RewardProgram addList:_rewardProgramList];
        [self getDataList];
        
        
        
        [self removeOverlayViews];
    }
}

- (void)handleLongPressEditRewardProgram:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:colVwRewardProgram];
    NSIndexPath * tappedIP = [colVwRewardProgram indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwRewardProgram cellForItemAtIndexPath:tappedIP];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          _editRewardProgram = _rewardProgramList[tappedIP.item];
          [self performSegueWithIdentifier:@"segAddEditRewardProgram" sender:self];
          
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
                _editRewardProgram = _rewardProgramList[tappedIP.item];
                [RewardProgram removeObject:_editRewardProgram];
                [self.homeModel deleteItems:dbRewardProgram withData:_editRewardProgram actionScreen:@"delete rewardProgram in rewardProgram screen"];
                
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
    if([[segue identifier] isEqualToString:@"segAddEditRewardProgram"])
    {
        NSInteger type = segConType.selectedSegmentIndex == 0?1:-1;
        RewardProgramAddViewController *vc = segue.destinationViewController;
        vc.editRewardProgram = _editRewardProgram;
        vc.type = type;
    }
}

- (void)getDataList
{
    NSInteger type = segConType.selectedSegmentIndex == 0?1:-1;
    NSDate *startDate = [Utility stringToDate:txtStartDate.text fromFormat:@"d MMM yyyy"];
    NSDate *endDate = [Utility stringToDate:txtEndDate.text fromFormat:@"d MMM yyyy"];
    _rewardProgramList = [RewardProgram getRewardProgramListWithStartDate:startDate endDate:endDate type:type];
    [colVwRewardProgram reloadData];
}

- (IBAction)segConValueChanged:(id)sender
{
    [self getDataList];
}

- (IBAction)addRewardProgram:(id)sender
{
    _editRewardProgram = nil;
    [self performSegueWithIdentifier:@"segAddEditRewardProgram" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

@end
