//
//  SettingListViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "SettingDetailViewController.h"


@interface SettingListViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tbvSettingNameList;

@end
