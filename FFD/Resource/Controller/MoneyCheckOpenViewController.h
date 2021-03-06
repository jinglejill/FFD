//
//  MoneyCheckOpenViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 2/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CorrectIncorrectCancelView.h"


@interface MoneyCheckOpenViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvMoneyCheckOpen;
@property (strong, nonatomic) CorrectIncorrectCancelView *vwCorrectIncorrectCancel;
@property (nonatomic) NSInteger period;
@end
