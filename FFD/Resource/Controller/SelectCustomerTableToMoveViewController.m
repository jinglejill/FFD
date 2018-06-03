//
//  SelectCustomerTableToMoveViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SelectCustomerTableToMoveViewController.h"
#import "CustomCollectionViewCellCustomerTable.h"
#import "TableTaking.h"
#import "OrderTaking.h"
#import "OrderKitchen.h"
#import "OrderNote.h"


@interface SelectCustomerTableToMoveViewController ()
{
    NSMutableArray *_customerTableList;
}
@end

@implementation SelectCustomerTableToMoveViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCellCustomerTable";
@synthesize colVwCustomerTable;
@synthesize selectedReceipt;
@synthesize selectedCustomerTable;
@synthesize selectedOrderTakingList;
@synthesize moveOrder;
@synthesize needSeparateOrder;


- (void)loadView
{
    [super loadView];
    colVwCustomerTable.allowsMultipleSelection = NO;
    
    
    
    
    _customerTableList = [CustomerTable getCustomerTableListWithStatus:1];

    
    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [colVwCustomerTable registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Register cell classes
    colVwCustomerTable.delegate = self;
    colVwCustomerTable.dataSource = self;
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
    
    
    
    cell.backgroundColor = mLightBlueColor;
    cell.lblTableName.textColor = [UIColor blackColor];
    
    
    
    //set table name
    CustomerTable *customerTable = _customerTableList[item];
    NSString *tableName = customerTable.tableName;
    cell.lblTableName.text = tableName;
    
    
    
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
    
    
    
    
    //set general ui
    [self setCornerAndShadow:cell cornerRadius:8];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.vwLeftBorder.backgroundColor = [UIColor clearColor];
    cell.vwRightBorder.backgroundColor = [UIColor clearColor];
    cell.vwTopBorder.backgroundColor = [UIColor clearColor];
    cell.vwBottomBorder.backgroundColor = [UIColor clearColor];
    
    
    

    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
    cell.backgroundColor = [color colorWithAlphaComponent:0.2];
    cell.lblTableName.textColor = mDarkGrayColor;
    
    
    
    
    
    if([customerTable isEqual:selectedCustomerTable])
    {
        cell.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(moveOrder)
    {
        CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];
        
        
        CustomerTable *customerTable = _customerTableList[indexPath.item];
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
        cell.backgroundColor = color;
        cell.lblTableName.textColor = [UIColor whiteColor];
        
        
        
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:
         [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"ยืนยันย้ายรายการไปที่โต๊ะ %@",customerTable.tableName]
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
              //move ordr process
              //ordertaking
              //orderkitchen
              //update ordertaking
              NSInteger customerTableIDSource = ((OrderTaking *)selectedOrderTakingList[0]).customerTableID;
//              NSMutableArray *inDbOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
              NSMutableArray *inDbOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTableIDSource status:2];
              NSMutableArray *inDbOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:inDbOrderTakingList];
              NSMutableArray *inDbOrderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:inDbOrderTakingList];
              NSMutableArray *moveOrderTakingList = [[NSMutableArray alloc]init];
              NSMutableArray *moveOrderNoteList = [[NSMutableArray alloc]init];
              NSMutableArray *moveOrderKitchenList = [[NSMutableArray alloc]init];
              
              
              
              
              if(needSeparateOrder)
              {
                  //split item one by one
                  for(OrderTaking *item in inDbOrderTakingList)
                  {
                      for(int i=0; i<item.quantity; i++)
                      {
                          OrderTaking *orderTaking = [item copy];
                          orderTaking.orderTakingID = [OrderTaking getNextID];
                          orderTaking.quantity = 1;
                          [OrderTaking addObject:orderTaking];
                          [moveOrderTakingList addObject:orderTaking];
                          
                          
                          
                          //create new orderNote
                          NSMutableArray *newOrderNoteList = [[NSMutableArray alloc]init];
                          NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
                          for(OrderNote *item in orderNoteList)
                          {
                              OrderNote *orderNote = [item copy];
                              orderNote.orderNoteID = [OrderNote getNextID];
                              orderNote.orderTakingID = orderTaking.orderTakingID;
                              [OrderNote addObject:orderNote];
                              [newOrderNoteList addObject:orderNote];
                          }
                          [moveOrderNoteList addObjectsFromArray:newOrderNoteList];
                          
                          
                          
                          
                          //create new orderKitchen
                          OrderKitchen *selectedOrderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:item.orderTakingID];
                          OrderKitchen *orderKitchen = [selectedOrderKitchen copy];
                          orderKitchen.orderKitchenID = [OrderKitchen getNextID];
                          orderKitchen.orderTakingID = orderTaking.orderTakingID;
                          [OrderKitchen addObject:orderKitchen];
                          [moveOrderKitchenList addObject:orderKitchen];
                      }
                  }
                  
                  
                  [OrderTaking removeList:inDbOrderTakingList];
                  [OrderNote removeList:inDbOrderNoteList];
                  [OrderKitchen removeList:inDbOrderKitchenList];
              }
              
              NSMutableArray *orderTakingToMoveOrderList = [[NSMutableArray alloc]init];
              for(OrderTaking *item in selectedOrderTakingList)
              {
                  OrderTaking *orderTakingToMoveOrder = [OrderTaking getOrderTakingWithCustomerTableID:item.customerTableID menuID:item.menuID takeAway:item.takeAway noteIDListInText:item.noteIDListInText status:item.status];
                  orderTakingToMoveOrder.customerTableID = customerTable.customerTableID;
                  orderTakingToMoveOrder.modifiedUser = [Utility modifiedUser];
                  orderTakingToMoveOrder.modifiedDate = [Utility currentDateTime];
                  [orderTakingToMoveOrderList addObject:orderTakingToMoveOrder];
              }
              
        
              
              
              //to update customerTable in orderkitchenList
              NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:orderTakingToMoveOrderList];
              for(OrderKitchen *item in orderKitchenList)
              {
                  item.customerTableIDOrder = item.customerTableIDOrder != 0?item.customerTableIDOrder:customerTableIDSource;
                  item.customerTableID = customerTable.customerTableID;
              }
              
              
            
              
              
              if(needSeparateOrder)
              {
                  NSArray *dataList = @[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,moveOrderTakingList,moveOrderNoteList,moveOrderKitchenList];
                  [self.homeModel insertItems:dbMoveOrderInsert withData:dataList actionScreen:@"move order(insert) in selectCustomerTableToMove screen"];
              }
              else
              {
                  NSArray *dataList = @[orderTakingToMoveOrderList,orderKitchenList];
                  [self.homeModel updateItems:dbMoveOrderUpdate withData:dataList actionScreen:@"move order(update) in selectCustomerTableToMove screen"];
              }
              
            
              [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
              
          }]];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ยกเลิก"
                                  style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action)
          {
              UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
              cell.backgroundColor = [color colorWithAlphaComponent:0.2];
              cell.lblTableName.textColor = mDarkGrayColor;
              NSLog(@"dismiss actionstylecancel");
          }]];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [alert setModalPresentationStyle:UIModalPresentationPopover];
            
            UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
            CGRect frame = cell.bounds;
            frame.origin.y = frame.origin.y-15;
            popPresenter.sourceView = cell;
            popPresenter.sourceRect = frame;
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else //move table
    {
        CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];
        
        
        CustomerTable *customerTable = _customerTableList[indexPath.item];
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
        cell.backgroundColor = color;
        cell.lblTableName.textColor = [UIColor whiteColor];
        
        
        
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:
         [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"ยืนยันย้ายไปที่โต๊ะ %@",customerTable.tableName]
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
              //move table process
              //ordertaking
              //orderkitchen
              //tabletaking
              //receipt
              
              
              //to update customerTable in ordertakingList
              NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:selectedReceipt.customerTableID statusList:@[@1,@2,@3]];
              for(OrderTaking *item in orderTakingList)
              {
                  item.customerTableID = customerTable.customerTableID;
                  item.modifiedUser = [Utility modifiedUser];
                  item.modifiedDate = [Utility currentDateTime];
              }
              
              
              //to update customerTable in orderkitchenList
              NSMutableArray *orderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:orderTakingList];
              for(OrderKitchen *item in orderKitchenList)
              {
                  item.customerTableIDOrder = item.customerTableIDOrder != 0?item.customerTableIDOrder:item.customerTableID;
                  item.customerTableID = customerTable.customerTableID;
                  item.modifiedUser = [Utility modifiedUser];
                  item.modifiedDate = [Utility currentDateTime];
              }
              
              
              
              //to update customerTable in tableTaking
              NSMutableArray *tableTakingList = [[NSMutableArray alloc]init];
              TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:selectedReceipt.customerTableID receiptID:0];
              if(tableTaking)
              {
                  tableTaking.customerTableID = customerTable.customerTableID;
                  tableTaking.modifiedUser = [Utility modifiedUser];
                  tableTaking.modifiedDate = [Utility currentDateTime];
                  [tableTakingList addObject:tableTaking];
              }
              
              
              //update customerTable and customerType in receipt
              selectedReceipt.customerTableID = customerTable.customerTableID;
              selectedReceipt.customerType = customerTable.type;
              selectedReceipt.modifiedUser = [Utility modifiedUser];
              selectedReceipt.modifiedDate = [Utility currentDateTime];
              
              
              
              [self.homeModel updateItems:dbOrderTakingOrderKitchenTableTakingReceiptList withData:@[orderTakingList,orderKitchenList,tableTakingList,selectedReceipt] actionScreen:@"update customerTableID in ordertakingList in selectCustomerTableToMove screen"];
              
              
              [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
              
          }]];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ยกเลิก"
                                  style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action)
          {
              UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
              cell.backgroundColor = [color colorWithAlphaComponent:0.2];
              cell.lblTableName.textColor = mDarkGrayColor;
              NSLog(@"dismiss actionstylecancel");
          }]];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [alert setModalPresentationStyle:UIModalPresentationPopover];
            
            UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
            CGRect frame = cell.bounds;
            frame.origin.y = frame.origin.y-15;
            popPresenter.sourceView = cell;
            popPresenter.sourceRect = frame;
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //check occupy status
    CustomerTable *customerTable = _customerTableList[indexPath.item];
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2And3List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    
    
    if(moveOrder)
    {
        if(receipt)
        {
            //show image spoon and fork
            return YES;
        }
        else if([orderTakingStatus2And3List count] > 0)
        {
            //show image spoon and fork
            return YES;
        }
        else if([orderTakingStatus1List count] > 0)
        {
            //show image take order
            return YES;
        }
        else if(tableTaking)
        {
            //show image take order
            return YES;
        }
        else if([customerTable isEqual:selectedCustomerTable])
        {
            return NO;
        }
        else
        {
            return NO;
        }
    }
    else//move table
    {
        if(receipt)
        {
            //show image spoon and fork
            return NO;
        }
        else if([orderTakingStatus2And3List count] > 0)
        {
            //show image spoon and fork
            return NO;
        }
        else if([orderTakingStatus1List count] > 0)
        {
            //show image take order
            return NO;
        }
        else if(tableTaking)
        {
            //show image take order
            return NO;
        }
        else if([customerTable isEqual:selectedCustomerTable])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    

    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
}
@end
