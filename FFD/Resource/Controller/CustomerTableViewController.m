//
//  CustomerTableViewController.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/5/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "OrderTakingViewController.h"
#import "ReceiptViewController.h"
#import "CustomCollectionViewCellCustomerTable.h"
#import "UserAccount.h"
#import "CustomerTable.h"
#import "TableTaking.h"
#import "OrderTaking.h"


@interface CustomerTableViewController ()
{
    NSIndexPath *_selectedIndexPath;
    CustomerTable *_customerTable;
    NSMutableArray *_customerTableList;
}
@end

@implementation CustomerTableViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCellCustomerTable";
static NSString * const reuseHeaderViewIdentifier = @"HeaderView";
static NSString * const reuseFooterViewIdentifier = @"FooterView";


@synthesize colVwCustomerTable;
@synthesize lblHello;
@synthesize btnLogOut;
@synthesize btnEatIn;
@synthesize btnTakeAway;
@synthesize btnDelivery;



- (IBAction)unwindToCustomerTable:(UIStoryboardSegue *)segue
{
    [self loadViewProcess];
}

- (void)loadView
{
    [super loadView];
    

    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    lblHello.text = [NSString stringWithFormat:@"สวัสดี คุณ%@",[UserAccount getFirstNameWithFullName:userAccount.fullName]];
    lblHello.textColor = mDarkGrayColor;
    
    
    [self setCornerAndShadow:btnLogOut];
    [self setCornerAndShadow:btnEatIn];
    [self setCornerAndShadow:btnTakeAway];
    [self setCornerAndShadow:btnDelivery];
    
    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    _customerTableList = [CustomerTable getCustomerTableListWithStatus:1];
    [colVwCustomerTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [colVwCustomerTable registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Register cell classes
    [colVwCustomerTable registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    [colVwCustomerTable registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterViewIdentifier];
    colVwCustomerTable.delegate = self;
    colVwCustomerTable.dataSource = self;
}

- (IBAction)logOut:(id)sender
{
    [UserAccount setCurrentUserAccount:nil];
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (IBAction)eatIn:(id)sender {
}

- (IBAction)takeAway:(id)sender {
}

- (IBAction)delivery:(id)sender {
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_customerTableList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCellCustomerTable *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSInteger item = indexPath.item;
    

    [self setCornerAndShadow:cell radius:8];
    cell.backgroundColor = mLightBlueColor;
    
    
    CustomerTable *customerTable = _customerTableList[item];
    NSString *tableName = customerTable.tableName;
    cell.lblTableName.text = tableName;
    
    
    //check occupy status
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    
    if([orderTakingStatus1List count] > 0)
    {
        //show image take order
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Add note dark blue.png"];
    }
    else if([orderTakingStatus2List count] > 0)
    {
        //show image spoon and fork
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Table reserve.png"];
    }
    else if(tableTaking)
    {
        //show image take order
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Add note dark blue.png"];
    }
    else
    {
        //not show image
        cell.imgVwOccupying.hidden = YES;
    }
    
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.vwLeftBorder.backgroundColor = [UIColor clearColor];
    cell.vwRightBorder.backgroundColor = [UIColor clearColor];
    cell.vwTopBorder.backgroundColor = [UIColor clearColor];
    cell.vwBottomBorder.backgroundColor = [UIColor clearColor];
    
    if([indexPath isEqual:_selectedIndexPath])
    {
        cell.backgroundColor = mBlueColor;
        cell.lblTableName.textColor = [UIColor whiteColor];
        
    }
    else
    {
        cell.backgroundColor = mLightBlueColor;
        cell.lblTableName.textColor = mDarkGrayColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectionView:collectionView didDeselectItemAtIndexPath:_selectedIndexPath];
    _selectedIndexPath = indexPath;

    
    CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = mBlueColor;
    cell.lblTableName.textColor = [UIColor whiteColor];
    
    
    
    CustomerTable *customerTable = _customerTableList[indexPath.item];
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    
    
    _customerTable = customerTable;
    if([orderTakingStatus1List count] > 0)
    {
        //show image take order
        [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
    }
    else if([orderTakingStatus2List count] > 0)
    {
        //show image spoon and fork
        [self performSegueWithIdentifier:@"segReceipt" sender:self];
    }
    else if(tableTaking)
    {
        //show image take order
        [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
    }
    else
    {
        //not show image
        [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];

    cell.backgroundColor = mLightBlueColor;
    cell.lblTableName.textColor = mDarkGrayColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderTaking"])
    {
        OrderTakingViewController *vc = segue.destinationViewController;
        vc.customerTable = _customerTable;
    }
    else if([[segue identifier] isEqualToString:@"segReceipt"])
    {
        ReceiptViewController *vc = segue.destinationViewController;
        vc.customerTable = _customerTable;
    }
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float column = 10;
    NSInteger row = ceil([_customerTableList count]/column);
    NSInteger collectionViewOriginY = 86;
    NSInteger ipadTabBarHeight = 56;
    CGSize size = CGSizeMake((self.view.frame.size.width)/column-5, (self.view.frame.size.height-collectionViewOriginY-ipadTabBarHeight-1)/row-5);
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwCustomerTable.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwCustomerTable reloadData];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 5);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
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
    return headerSize;
}
@end
