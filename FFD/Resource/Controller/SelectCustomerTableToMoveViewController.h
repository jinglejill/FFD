//
//  SelectCustomerTableToMoveViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"
#import "CustomerTable.h"

@interface SelectCustomerTableToMoveViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) Receipt *selectedReceipt;
@property (strong, nonatomic) CustomerTable *selectedCustomerTable;
@property (strong, nonatomic) NSMutableArray *selectedOrderTakingList;
@property (nonatomic) BOOL moveOrder;
@property (nonatomic) BOOL needSeparateOrder;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwCustomerTable;
- (IBAction)goBack:(id)sender;
@end
