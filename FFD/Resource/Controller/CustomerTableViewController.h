//
//  CustomerTableViewController.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/5/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomerTableViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UIButton *btnEatIn;
@property (strong, nonatomic) IBOutlet UIButton *btnTakeAway;
@property (strong, nonatomic) IBOutlet UIButton *btnDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblHello;
- (IBAction)logOut:(id)sender;
- (IBAction)eatIn:(id)sender;
- (IBAction)takeAway:(id)sender;
- (IBAction)delivery:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *colVwCustomerTable;
- (IBAction)unwindToCustomerTable:(UIStoryboardSegue *)segue;

@end
