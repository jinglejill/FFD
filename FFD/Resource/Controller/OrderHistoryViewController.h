//
//  OrderHistoryViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomerTable.h"


@interface OrderHistoryViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvOrderHistory;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)closeVc:(id)sender;

@end
