//
//  MenuTypeListViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 26/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "SetUpMenuTypePrintViewController.h"
#import "Printer.h"
#import "ConfirmAndCancelView.h"


@interface MenuTypeListViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvMenuType;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) SetUpMenuTypePrintViewController *vc;
@property (strong, nonatomic) Printer *selectedPrinter;



@end
