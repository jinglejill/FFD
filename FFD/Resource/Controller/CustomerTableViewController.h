//
//  CustomerTableViewController.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/5/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CredentialsDb.h"


@interface CustomerTableViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UILabel *lblHello;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnReceiptHistory;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwCustomerTable;
@property (strong, nonatomic) IBOutlet UITextView *txvBoard;
@property (strong, nonatomic) IBOutlet UIButton *btnEditBoard;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderPushCount;
@property (strong, nonatomic) CredentialsDb *credentialsDb;


- (IBAction)unwindToCustomerTable:(UIStoryboardSegue *)segue;
- (IBAction)logOut:(id)sender;
- (IBAction)viewReceiptHistory:(id)sender;
- (IBAction)confirmEditBoard:(id)sender;
- (IBAction)cancelEditBoard:(id)sender;
- (IBAction)editBoard:(id)sender;
- (IBAction)checkMoney:(id)sender;
- (IBAction)viewOrderPush:(id)sender;

@end
