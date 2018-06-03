//
//  SelectCustomerTableToMergeViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"
#import "CustomerTable.h"


@interface SelectCustomerTableToMergeViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) Receipt *selectedReceipt;
@property (strong, nonatomic) CustomerTable *selectedCustomerTable;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwCustomerTable;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnClearMergeReceipt;



- (IBAction)goBack:(id)sender;
- (IBAction)confirmMergeReceipt:(id)sender;
- (IBAction)clearMergeReceipt:(id)sender;

@end
