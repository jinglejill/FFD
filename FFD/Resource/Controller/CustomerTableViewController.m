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
#import "MoneyCheckCloseViewController.h"
#import "CustomerKitchenViewController.h"
#import "CustomCollectionViewCellCustomerTable.h"
#import "UserAccount.h"
#import "CustomerTable.h"
#import "TableTaking.h"
#import "OrderTaking.h"
#import "RoleTabMenu.h"
#import "Board.h"
#import "Receipt.h"
#import "Setting.h"


@interface CustomerTableViewController ()
{
    NSIndexPath *_selectedIndexPath;
    CustomerTable *_customerTable;
    NSMutableArray *_customerTableList;
    NSString *_previousTypeAndZone;
}
@end

@implementation CustomerTableViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCellCustomerTable";


@synthesize colVwCustomerTable;
@synthesize lblHello;
@synthesize btnLogOut;
@synthesize imgLogo;
@synthesize btnReceiptHistory;
@synthesize txvBoard;
@synthesize btnEditBoard;
@synthesize btnConfirm;
@synthesize btnCancel;
@synthesize btnCheckMoney;
@synthesize lblOrderPushCount;
@synthesize credentialsDb;


- (IBAction)unwindToCustomerTable:(UIStoryboardSegue *)segue
{
    [self loadViewProcess];
    [self setCurrentVc];
}

- (IBAction)viewReceiptHistory:(id)sender
{
    [self performSegueWithIdentifier:@"segReceiptHistory" sender:self];
}

- (IBAction)confirmEditBoard:(id)sender
{
    Board *board = [Board getBoard:1];
    board.content = [Utility replaceNewLineForDB:txvBoard.text];
    board.modifiedUser = [Utility modifiedUser];
    board.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbBoard withData:board actionScreen:@"update board content in customerTable screen"];
    
    txvBoard.editable = NO;
    btnEditBoard.hidden = NO;
    btnConfirm.hidden = YES;
    btnCancel.hidden = YES;
}

- (IBAction)cancelEditBoard:(id)sender
{
    Board *board = [Board getBoard:1];
    txvBoard.text = [Utility replaceNewLineForApp:board.content];
    txvBoard.editable = NO;
    btnEditBoard.hidden = NO;
    btnConfirm.hidden = YES;
    btnCancel.hidden = YES;
}

- (IBAction)editBoard:(id)sender
{
    txvBoard.editable = YES;
    btnEditBoard.hidden = YES;
    btnConfirm.hidden = NO;
    btnCancel.hidden = NO;
}

- (IBAction)checkMoney:(id)sender
{
    UIButton *button = sender;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"เริ่มต้นกะ"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          //จะแสดงปุ่มเริ่มต้นกะ โดยเริ่มจากเวลา เริ่มต้นกะ-30นาที จนถึงเวลาปิดกะ
          if([self inPeriod:1] || [self inPeriod:2] || [self inPeriod:3])
          {
              NSInteger period = [self inPeriod:1]?1:[self inPeriod:2]?2:[self inPeriod:3]?3:0;
              [self checkMoneyClose:period type:1];
          }
          else
          {
              [self showAlert:@"" message:@"ไม่สามารถตรวจสอบเงินเริ่มต้นกะได้ตอนนี้\n ตรวจสอบได้ก่อนเริ่มเปิดกะ 30 นาที"];
          }
      }]];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"สิ้นสุดกะ"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          NSInteger period = [self inPeriod:1]?1:[self inPeriod:2]?2:[self inPeriod:3]?3:0;
          [self checkMoneyClose:period type:0];
      }]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = button.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = button;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)viewOrderPush:(id)sender
{
    [self performSegueWithIdentifier:@"segCustomerKitchen" sender:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
 
    CGRect frame = imgLogo.frame;
    frame.size.width = frame.size.height*imgLogo.image.size.width/imgLogo.image.size.height;
    imgLogo.frame = frame;
    
    
    {
        NSInteger collectionViewOriginY = 86;
        NSInteger ipadTabBarHeight = 56;
        NSInteger confirmCancelHeight = 46;
        
        CGRect frame = colVwCustomerTable.frame;
        frame.size.height = self.view.frame.size.height-collectionViewOriginY-ipadTabBarHeight-confirmCancelHeight;
        colVwCustomerTable.frame = frame;
    }
}

- (void)loadView
{
    [super loadView];
    

    [self setCurrentVc];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    lblHello.text = [NSString stringWithFormat:@"สวัสดี คุณ%@",[UserAccount getFirstNameWithFullName:userAccount.fullName]];
    lblHello.textColor = mDarkGrayColor;
    _previousTypeAndZone = @"";
    
    
    [self setButtonDesign:btnLogOut];
    [self setButtonDesign:btnReceiptHistory];
    [self setButtonDesign:btnCheckMoney];
    
    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    _customerTableList = [CustomerTable getCustomerTableListWithStatus:1];
    [colVwCustomerTable reloadData];
    
    
    txvBoard.text = [Utility replaceNewLineForApp:[Board getContent]];
    
    
    
    //tab setting
    UserAccount *currentUserAccount = [UserAccount getCurrentUserAccount];
    NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:currentUserAccount.roleID tabMenuType:1];
    NSMutableArray *showVCList = [[NSMutableArray alloc]init];
    for(RoleTabMenu *item in roleTabMenuList)
    {
        [showVCList addObject:self.tabBarController.viewControllers[item.tabMenuID-1]];
    }
    [self.tabBarController setViewControllers:showVCList animated:YES];
    
    
    
    //board setting
    RoleTabMenu *roleTabMenu = [RoleTabMenu getRoleTabMenuWithRoleID:currentUserAccount.roleID tabMenuID:14];
    if(roleTabMenu)
    {
        txvBoard.editable = NO;
        btnEditBoard.hidden = NO;
        btnConfirm.hidden = YES;
        btnCancel.hidden = YES;
    }
    else
    {
        txvBoard.editable = NO;
        btnEditBoard.hidden = YES;
        btnConfirm.hidden = YES;
        btnCancel.hidden = YES;
    }
    
    
    
    //check money setting
    {
        RoleTabMenu *roleTabMenuCheckMoneyShopOpen = [RoleTabMenu getRoleTabMenuWithRoleID:currentUserAccount.roleID tabMenuID:12];
        RoleTabMenu *roleTabMenuCheckMoneyShopClose = [RoleTabMenu getRoleTabMenuWithRoleID:currentUserAccount.roleID tabMenuID:13];
        btnCheckMoney.hidden = !roleTabMenuCheckMoneyShopOpen && !roleTabMenuCheckMoneyShopClose;
    }
    
    
    
    //customer orderPushCount
    NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:2 branchID:credentialsDb.branchID];
    [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:5 branchID:credentialsDb.branchID]];
    [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:7 branchID:credentialsDb.branchID]];
    [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:credentialsDb.branchID]];
    [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:11 branchID:credentialsDb.branchID]];
    lblOrderPushCount.text = [receiptActionList count]==0?@"":@"!";

    
//    NSMutableArray *receiptList = [Receipt getReceiptListWithStatus:2 branchID:credentialsDb.branchID];
//    NSInteger countReceipt = [receiptList count];
//    lblOrderPushCount.text = [Utility formatDecimal:countReceipt withMinFraction:0 andMaxFraction:0];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [colVwCustomerTable registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    // Register cell classes
    colVwCustomerTable.delegate = self;
    colVwCustomerTable.dataSource = self;
    
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (IBAction)logOut:(id)sender
{
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    userAccount.deviceToken = @"";
    userAccount.modifiedUser = [Utility modifiedUser];
    userAccount.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbUserAccount withData:userAccount actionScreen:@"log out in customerTable screen"];
    
    
    [UserAccount setCurrentUserAccount:nil];
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  [_customerTableList count]>0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_customerTableList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCellCustomerTable *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSInteger item = indexPath.item;
    

    [self setCornerAndShadow:cell cornerRadius:8];

    
    CustomerTable *customerTable = _customerTableList[item];
    NSString *currentTypeAndZone = [NSString stringWithFormat:@"%ld,%@",customerTable.type,customerTable.zone];
    if(![_previousTypeAndZone isEqualToString:currentTypeAndZone])
    {
        UIFont *font = [UIFont boldSystemFontOfSize:25];
        NSDictionary *attribute = @{NSFontAttributeName: font};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Utility getFirstLetter:customerTable.tableName] attributes:attribute];
        
        
        UIFont *font2 = [UIFont systemFontOfSize:17];
        NSDictionary *attribute2 = @{NSFontAttributeName: font2};
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[Utility getTextOmitFirstLetter:customerTable.tableName] attributes:attribute2];
        
        
        [attrString appendAttributedString:attrString2];
        cell.lblTableName.attributedText = attrString;

    }
    else
    {
        NSString *tableName = customerTable.tableName;
        cell.lblTableName.text = tableName;
    }
    _previousTypeAndZone = currentTypeAndZone;
    
    
    //check occupy status
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2And3List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    
    if(receipt)
    {
        //show image spoon and fork
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Table reserve.png"];
    }
    else if([orderTakingStatus2And3List count] > 0)
    {
        //show image spoon and fork
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Table reserve.png"];
    }
    else if([orderTakingStatus1List count] > 0)
    {
        //show image take order
        cell.imgVwOccupying.hidden = NO;
        cell.imgVwOccupying.image = [UIImage imageNamed:@"Add note dark blue.png"];
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
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
        cell.backgroundColor = color;
        cell.lblTableName.textColor = [UIColor whiteColor];
        
    }
    else
    {
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
        cell.backgroundColor = [color colorWithAlphaComponent:0.2];
        cell.lblTableName.textColor = mDarkGrayColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectionView:collectionView didDeselectItemAtIndexPath:_selectedIndexPath];
    _selectedIndexPath = indexPath;

    
    CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];
    

    NSInteger item = indexPath.item;
    CustomerTable *customerTable = _customerTableList[item];
    
    
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2And3List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    _customerTable = customerTable;
    
    
    
    
    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
    cell.backgroundColor = color;
    cell.lblTableName.textColor = [UIColor whiteColor];
    
    
    
    if(receipt)
    {
        //show image spoon and fork
        [self performSegueWithIdentifier:@"segReceipt" sender:self];
    }
    else if([orderTakingStatus2And3List count] > 0)
    {
        //show image spoon and fork
        [self performSegueWithIdentifier:@"segReceipt" sender:self];
    }
    else if([orderTakingStatus1List count] > 0)
    {
        //show image take order
        [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
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

    
    NSInteger item = indexPath.item;
    CustomerTable *customerTable = _customerTableList[item];
    
    
    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
    cell.backgroundColor = [color colorWithAlphaComponent:0.2];
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
    else if([segue.identifier isEqualToString:@"segCustomerKitchen"])
    {
        CustomerKitchenViewController *vc = segue.destinationViewController;
        vc.credentialsDb = credentialsDb;
    }
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float column = 10;
    NSInteger row = ceil([_customerTableList count]/column);
    CGSize size = CGSizeMake((collectionView.frame.size.width)/column-5, (collectionView.frame.size.height)/row-5);

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
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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

-(void)checkMoneyClose:(NSInteger)period type:(NSInteger)type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoneyCheckCloseViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MoneyCheckCloseViewController"];
    controller.preferredContentSize = CGSizeMake(500, 44*5+58);//type == 0?CGSizeMake(500, 44*5+58):CGSizeMake(500, 44*3+58);
    controller.period = period;
    controller.type = type;
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    CGRect frame = btnCheckMoney.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = btnCheckMoney;
    popController.sourceRect = frame;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}
@end
