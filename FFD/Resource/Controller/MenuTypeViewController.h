//
//  MenuTypeViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "MenuViewController.h"
#import "MenuType.h"


@interface MenuTypeViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) MenuViewController *vc;
@property (strong, nonatomic) MenuType *editMenuType;
@property (strong, nonatomic) IBOutlet UITableView *tbvMenuType;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;

@end
