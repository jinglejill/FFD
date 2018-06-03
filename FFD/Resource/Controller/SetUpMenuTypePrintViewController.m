//
//  SetUpMenuTypePrintViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SetUpMenuTypePrintViewController.h"
#import "MenuTypeListViewController.h"
#import "CustomCollectionViewCellPrinter.h"
#import "Printer.h"
#import "MenuType.h"


@interface SetUpMenuTypePrintViewController ()
{
    NSArray *_printerCodeList;
}
@end

@implementation SetUpMenuTypePrintViewController
static NSString * const reuseIdentifierPrinter = @"CustomCollectionViewCellPrinter";

@synthesize colVwSetUpMenuTypePrint;

-(void)loadView
{
    [super loadView];
    _printerCodeList = @[@"Kitchen",@"Kitchen2",@"Drinks",@"Cashier"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    colVwSetUpMenuTypePrint.delegate = self;
    colVwSetUpMenuTypePrint.dataSource = self;
 
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPrinter bundle:nil];
        [colVwSetUpMenuTypePrint registerNib:nib forCellWithReuseIdentifier:reuseIdentifierPrinter];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if([collectionView isEqual:colVwSetUpMenuTypePrint])
    {
        return  [_printerCodeList count]>0;
    }
   
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwSetUpMenuTypePrint])
    {
        return [_printerCodeList count];
    }
   
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    
    if([collectionView isEqual:colVwSetUpMenuTypePrint])
    {
        CustomCollectionViewCellPrinter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierPrinter forIndexPath:indexPath];
        cell.contentView.userInteractionEnabled = NO;
        
        
        Printer *printer = [Printer getPrinterWithCode:_printerCodeList[item]];
        cell.vwWidthConstant.constant = collectionView.frame.size.width - 2*16;
        cell.lblPrinterName.text = printer.name;
        cell.lblModel.text = [Utility isStringEmpty:printer.menuTypeIDListInText]?@"เลือกหมวดรายการอาหาร":[Printer getMenuTypeListInTextWithPrinter:printer];
        cell.lblPortAndMacAddress.text = @"";
        cell.imVwStatus.hidden = YES;
        cell.btnTrash.hidden = YES;
        
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwSetUpMenuTypePrint])
    {

        // grab the view controller we want to show
        NSMutableArray *menuTypeList = [MenuType getMenuTypeListWithStatus:1];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuTypeListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuTypeListViewController"];
        controller.preferredContentSize = CGSizeMake(300, 44*[menuTypeList count]+58+60);
        controller.vc = self;
        controller.selectedPrinter = [Printer getPrinterWithCode:_printerCodeList[indexPath.item]];
        
        
        
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:controller animated:YES completion:nil];
        
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [controller popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.delegate = self;
        
        
        CustomCollectionViewCellPrinter *cell = (CustomCollectionViewCellPrinter *)[colVwSetUpMenuTypePrint cellForItemAtIndexPath:indexPath];
        CGRect frame = cell.frame;
        frame.origin.y = frame.origin.y-15;
        popController.sourceView = cell;
        popController.sourceRect = frame;
    }
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwSetUpMenuTypePrint])
    {
        return CGSizeMake(collectionView.frame.size.width, 80);
    }
    
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwSetUpMenuTypePrint.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwSetUpMenuTypePrint reloadData];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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

- (IBAction)backToSetting:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return NO;
}

-(void)reloadCollectionView
{
    [colVwSetUpMenuTypePrint reloadData];
}
@end
