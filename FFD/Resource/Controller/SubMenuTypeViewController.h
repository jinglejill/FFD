//
//  SubMenuTypeViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "MenuViewController.h"
#import "MenuType.h"
#import "SubMenuType.h"


@interface SubMenuTypeViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) MenuViewController *vc;
@property (strong, nonatomic) MenuType *editMenuType;
@property (strong, nonatomic) SubMenuType *editSubMenuType;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;


@property (strong, nonatomic) IBOutlet UITableView *tbvSubMenuType;

@end
