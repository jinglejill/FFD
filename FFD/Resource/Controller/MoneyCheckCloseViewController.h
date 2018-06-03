//
//  MoneyCheckCloseViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"


@interface MoneyCheckCloseViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvMoneyCheckClose;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (nonatomic) NSInteger period;
@property (nonatomic) NSInteger type;

@end
