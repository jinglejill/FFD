//
//  SettingViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomCollectionViewCellImageWithText.h"


@interface SettingViewController ()
{
    NSArray *_menuList;
    NSArray *_segueList;
    NSArray *_iconList;
}
@end

@implementation SettingViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCellImageWithText";

@synthesize colVwMenu;
- (IBAction)unwindToSetting:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _menuList = @[@"ทั่วไป",@"เครื่องพิมพ์",@"บิล",@"โปรโมชั่น",@"ลิ้นชักเก็บเงิน",@"ลูกค้า",@"พนักงาน",@"สินค้าคงคลัง",@"เมนู",@"สาขา",@"รายงาน",@"สะสมแต้ม",@"ส่วนลด"];
    _segueList = @[@"",@"segSetUpPrinter",@"",@"segPromotion",@"segSetUpCashDrawer",@"",@"segEmployeeList",@"",@"",@"segBranchList",@"",@"segRewardProgram",@"segDiscountList"];
    _iconList = @[@"noImage.gif",@"printer icon.png",@"noImage.gif",@"promotion.png",@"cashDrawer.png",@"noImage.gif",@"noImage.gif",@"noImage.gif",@"noImage.gif",@"branch.png",@"noImage.gif",@"reward.png",@"discount.png"];
    colVwMenu.delegate = self;
    colVwMenu.dataSource = self;
    
  
    
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [colVwMenu registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  [_menuList count]>0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_menuList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCellImageWithText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSInteger item = indexPath.item;
    
    
    [self setCornerAndShadow:cell cornerRadius:8];
    
    
    cell.lblMenuName.text = _menuList[item];
    cell.imgVwIcon.image = [UIImage imageNamed:_iconList[item]];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:_segueList[indexPath.item] sender:self];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(180, 180);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwMenu.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwMenu reloadData];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
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
