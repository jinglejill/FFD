//
//  SelectCustomerTableToMergeViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SelectCustomerTableToMergeViewController.h"
#import "CustomCollectionViewCellCustomerTable.h"
#import "CustomerTable.h"
#import "TableTaking.h"
#import "OrderTaking.h"
#import "ReceiptCustomerTable.h"
#import "RewardPoint.h"


@interface SelectCustomerTableToMergeViewController ()
{
    NSMutableArray *_customerTableList;
    NSInteger _mergeReceiptID;
}
@end

@implementation SelectCustomerTableToMergeViewController
static NSString * const reuseIdentifier = @"CustomCollectionViewCellCustomerTable";


@synthesize colVwCustomerTable;
@synthesize btnConfirm;
@synthesize btnClearMergeReceipt;
@synthesize selectedReceipt;
@synthesize selectedCustomerTable;



- (void)loadView
{
    [super loadView];
    colVwCustomerTable.allowsMultipleSelection = YES;
    
    
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnClearMergeReceipt];
    
    
    
    _customerTableList = [CustomerTable getCustomerTableListWithStatus:1];
    _mergeReceiptID = selectedReceipt.mergeReceiptID;
    
    
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
    

    
    
    
    
    if(_mergeReceiptID == 0)
    {
        NSInteger selectedIndex = [CustomerTable getSelectedIndexWithCustomerTableList:_customerTableList customerTableID:selectedReceipt.customerTableID];
        


        if(indexPath.item == selectedIndex)
        {
            UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
            cell.backgroundColor = color;
            cell.lblTableName.textColor = [UIColor whiteColor];
            [colVwCustomerTable selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        else
        {
            UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
            cell.backgroundColor = [color colorWithAlphaComponent:0.2];
            cell.lblTableName.textColor = mDarkGrayColor;
        }
    }
    else
    {
        NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
        for(ReceiptCustomerTable *item in receiptCustomerTableList)
        {
            NSInteger selectedIndex = [CustomerTable getSelectedIndexWithCustomerTableList:_customerTableList customerTableID:item.customerTableID];
            

            if(indexPath.item == selectedIndex)
            {
                if([selectedCustomerTable isEqual:[CustomerTable getCustomerTable:item.customerTableID]])
                {
                    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
                    cell.backgroundColor = color;
                    cell.lblTableName.textColor = [UIColor whiteColor];
                    [colVwCustomerTable selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
                else
                {
                    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
                    cell.backgroundColor = color;
                    cell.lblTableName.textColor = [UIColor whiteColor];
                    cell.selected = YES;
                    [colVwCustomerTable selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
                break;
            }
            else
            {
                UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
                cell.backgroundColor = [color colorWithAlphaComponent:0.2];
                cell.lblTableName.textColor = mDarkGrayColor;
                [colVwCustomerTable deselectItemAtIndexPath:indexPath animated:NO];
            }
        }
    }
    
    
    
    if([customerTable isEqual:selectedCustomerTable])
    {
        cell.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];


    CustomerTable *customerTable = _customerTableList[indexPath.item];
    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
    cell.backgroundColor = color;
    cell.lblTableName.textColor = [UIColor whiteColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //check occupy status
    CustomerTable *customerTable = _customerTableList[indexPath.item];
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    NSMutableArray *orderTakingStatus1List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    NSMutableArray *orderTakingStatus2And3List = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    
    
    if(receipt && receipt.mergeReceiptID == -999)//split bill
    {
        return NO;
    }
    else if([orderTakingStatus2And3List count] > 0)
    {
        //show image spoon and fork
        return YES;
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
    else
    {
        //not show image
        return NO;
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerTable *customerTable = _customerTableList[indexPath.item];
    if([customerTable isEqual:selectedCustomerTable])
    {
        return NO;
    }

    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellCustomerTable* cell = (CustomCollectionViewCellCustomerTable *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    CustomerTable *customerTable = _customerTableList[indexPath.item];
    UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
    cell.backgroundColor = [color colorWithAlphaComponent:0.2];
    cell.lblTableName.textColor = mDarkGrayColor;
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

- (IBAction)clearMergeReceipt:(id)sender
{
    //ปุ่มลบการรวมบิล
    NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
    for(NSIndexPath *indexPath in selectedCustomerTableList)
    {
        NSInteger selectedIndex = [CustomerTable getSelectedIndexWithCustomerTableList:_customerTableList customerTableID:selectedReceipt.customerTableID];
        
        if(indexPath.item != selectedIndex)
        {
            CustomCollectionViewCellCustomerTable *cell = (CustomCollectionViewCellCustomerTable *)[colVwCustomerTable cellForItemAtIndexPath:indexPath];

            
            CustomerTable *customerTable = _customerTableList[indexPath.item];
            UIColor *color = UIColorFromRGB([Utility hexStringToInt:customerTable.color]);
            cell.backgroundColor = [color colorWithAlphaComponent:0.2];
            cell.lblTableName.textColor = mDarkGrayColor;
            
            
            [colVwCustomerTable deselectItemAtIndexPath:indexPath animated:NO];
        }
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
}

- (IBAction)confirmMergeReceipt:(id)sender
{
    //insert ลง receiptCustomerTable
    //ถ้ามี 1 โต๊ะ คือเท่าเดิมหีือลดจำนวน
    //ถ้ามี 2 โต๊ะ คือเท่าเดิม มากขึ้น หรือลดลง
    
    //ลบ แล้ว เพิ่มใหม่
    //receipt
    //receiptcustomertable
    if(_mergeReceiptID == 0)
    {
        NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
        if([selectedCustomerTableList count] > 1)
        {
            //new receipt
            Receipt *mergeReceipt = [[Receipt alloc]initWithCustomerTableID:0 memberID:0 servingPerson:0 customerType:0 openTableDate:[Utility notIdentifiedDate] cashAmount:0 cashReceive:0 creditCardType:0 creditCardNo:@"" creditCardAmount:0 transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:@"" discountType:0 discountAmount:0 discountReason:@"" status:1 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility notIdentifiedDate] mergeReceiptID:0];
            mergeReceipt.openTableDate = selectedReceipt.openTableDate;
            mergeReceipt.receiptNoID = selectedReceipt.receiptNoID;
            [Receipt addObject:mergeReceipt];


      
            //update merge receipt in receipt ย่อย
            NSMutableArray *receiptList = [[NSMutableArray alloc]init];
            for(NSIndexPath *item in selectedCustomerTableList)
            {
                CustomerTable *customerTable = _customerTableList[item.item];
                Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
                receipt.memberID = 0;
                receipt.discountType = 0;
                receipt.discountAmount = 0;
                receipt.discountReason = @"";
                receipt.mergeReceiptID = mergeReceipt.receiptID;
                receipt.modifiedUser = [Utility modifiedUser];
                receipt.modifiedDate = [Utility currentDateTime];
                [receiptList addObject:receipt];
                
                
                RewardPoint *rewardPoint = [RewardPoint getRewardPointWithReceiptID:receipt.receiptID status:0];
                if(rewardPoint)
                {
                    [RewardPoint removeObject:rewardPoint];
                }
            }

            
            
            //insert receiptCustomerTable
            NSMutableArray *receiptCustomerTableList = [[NSMutableArray alloc]init];
            for(NSIndexPath *item in selectedCustomerTableList)
            {
                CustomerTable *customerTable = _customerTableList[item.item];
                Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
                ReceiptCustomerTable *receiptCustomerTable = [[ReceiptCustomerTable alloc]initWithMergeReceiptID:mergeReceipt.receiptID receiptID:receipt.receiptID customerTableID:customerTable.customerTableID];
                [receiptCustomerTableList addObject:receiptCustomerTable];
                [ReceiptCustomerTable addObject:receiptCustomerTable];
            }
        }
    }
    else//_mergeReceiptID != 0
    {
        NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
        if([selectedCustomerTableList count] == 1)
        {
            {
                //update mergeReceiptID in receipt to 0
                NSMutableArray *receiptList = [[NSMutableArray alloc]init];
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                for(ReceiptCustomerTable *item in receiptCustomerTableList)
                {
                    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:item.customerTableID status:1];
                    receipt.mergeReceiptID = 0;
                    receipt.modifiedUser = [Utility modifiedUser];
                    receipt.modifiedDate = [Utility currentDateTime];
                    [receiptList addObject:receipt];
                }
            }
            
            
            
            {
                //delete receiptCustomerTable where receipt = mergeReceiptID
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                [ReceiptCustomerTable removeList:receiptCustomerTableList];
            }
            
            
            
            {
                //delete merge receipt
                Receipt *mergeReceipt = [Receipt getReceipt:_mergeReceiptID];
                [Receipt removeObject:mergeReceipt];
            }
        }
        else
        {
            //merge receipt คงไว้
            //delete receiptCustomerTable where customertable not in selectedCustomerTableList
            {
                NSMutableArray *customerTableListNew = [[NSMutableArray alloc]init];
                NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
                NSMutableArray *customerTableListOld = [[NSMutableArray alloc]init];
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                
                
                for(NSIndexPath *indexPath in selectedCustomerTableList)
                {
                    CustomerTable *customerTable = _customerTableList[indexPath.item];
                    [customerTableListNew addObject:customerTable];
                }
                for(ReceiptCustomerTable *item in receiptCustomerTableList)
                {
                    CustomerTable *customerTable = [CustomerTable getCustomerTable:item.customerTableID];
                    [customerTableListOld addObject:customerTable];
                }
                [customerTableListOld removeObjectsInArray:customerTableListNew];
                
                
                NSMutableArray *deleteReceiptCustomerTableList = [[NSMutableArray alloc]init];
                for(CustomerTable *item in customerTableListOld)
                {
                    ReceiptCustomerTable *receiptCustomerTable = [ReceiptCustomerTable getReceiptCustomerTableWithReceiptID:_mergeReceiptID customerTableID:item.customerTableID];
                    [deleteReceiptCustomerTableList addObject:receiptCustomerTable];
                }
                
                [ReceiptCustomerTable removeList:deleteReceiptCustomerTableList];
            }
            
            
            
            //insert receiptCustomerTable where selectedCustomerTableList not in customertable
            {
                NSMutableArray *customerTableListNew = [[NSMutableArray alloc]init];
                NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
                NSMutableArray *customerTableListOld = [[NSMutableArray alloc]init];
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                
                
                for(NSIndexPath *indexPath in selectedCustomerTableList)
                {
                    CustomerTable *customerTable = _customerTableList[indexPath.item];
                    [customerTableListNew addObject:customerTable];
                }
                for(ReceiptCustomerTable *item in receiptCustomerTableList)
                {
                    CustomerTable *customerTable = [CustomerTable getCustomerTable:item.customerTableID];
                    [customerTableListOld addObject:customerTable];
                }
                [customerTableListNew removeObjectsInArray:customerTableListOld];
                
                
                
                NSMutableArray *insertReceiptCustomerTableList = [[NSMutableArray alloc]init];
                for(CustomerTable *item in customerTableListNew)
                {
                    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:item.customerTableID status:1];
                    ReceiptCustomerTable *receiptCustomerTable = [[ReceiptCustomerTable alloc]initWithMergeReceiptID:_mergeReceiptID receiptID:receipt.receiptID customerTableID:item.customerTableID];
                    [insertReceiptCustomerTableList addObject:receiptCustomerTable];
                    [ReceiptCustomerTable addObject:receiptCustomerTable];
                }
            }
            
            
            
            //update mergereceiptid = 0 where customertable not in selectedCustomerTableList
            {
                NSMutableArray *customerTableListNew = [[NSMutableArray alloc]init];
                NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
                NSMutableArray *customerTableListOld = [[NSMutableArray alloc]init];
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                
                
                for(NSIndexPath *indexPath in selectedCustomerTableList)
                {
                    CustomerTable *customerTable = _customerTableList[indexPath.item];
                    [customerTableListNew addObject:customerTable];
                }
                for(ReceiptCustomerTable *item in receiptCustomerTableList)
                {
                    CustomerTable *customerTable = [CustomerTable getCustomerTable:item.customerTableID];
                    [customerTableListOld addObject:customerTable];
                }
                [customerTableListOld removeObjectsInArray:customerTableListNew];
                
                
                
                NSMutableArray *updateReceiptList = [[NSMutableArray alloc]init];
                for(CustomerTable *item in customerTableListOld)
                {
                    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:item.customerTableID status:1];
                    receipt.mergeReceiptID = 0;
                    receipt.modifiedUser = [Utility modifiedUser];
                    receipt.modifiedDate = [Utility currentDateTime];
                    [updateReceiptList addObject:receipt];
                }
            }
            
            
            
            
            //update mergereceiptid = existedMergeReceiptID where selectedCustomerTableList not in customertable
            {
                NSMutableArray *customerTableListNew = [[NSMutableArray alloc]init];
                NSArray *selectedCustomerTableList = colVwCustomerTable.indexPathsForSelectedItems;
                NSMutableArray *customerTableListOld = [[NSMutableArray alloc]init];
                NSMutableArray *receiptCustomerTableList = [ReceiptCustomerTable getReceiptCustomerTableListWithMergeReceiptID:_mergeReceiptID];
                
                
                for(NSIndexPath *indexPath in selectedCustomerTableList)
                {
                    CustomerTable *customerTable = _customerTableList[indexPath.item];
                    [customerTableListNew addObject:customerTable];
                }
                for(ReceiptCustomerTable *item in receiptCustomerTableList)
                {
                    CustomerTable *customerTable = [CustomerTable getCustomerTable:item.customerTableID];
                    [customerTableListOld addObject:customerTable];
                }
                [customerTableListNew removeObjectsInArray:customerTableListOld];
                
                
                
                NSMutableArray *updateReceiptList = [[NSMutableArray alloc]init];
                for(CustomerTable *item in customerTableListOld)
                {
                    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:item.customerTableID status:1];
                    receipt.mergeReceiptID = _mergeReceiptID;
                    receipt.modifiedUser = [Utility modifiedUser];
                    receipt.modifiedDate = [Utility currentDateTime];
                    [updateReceiptList addObject:receipt];
                }
            }
        }
    }
    
    [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
}
@end
