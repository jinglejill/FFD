//
//  SelectPrinterViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "SetUpPrinterViewController.h"

@interface SelectPrinterViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SetUpPrinterViewController *vc;
@property (strong, nonatomic) IBOutlet UITableView *tbvSelectPrinter;

@end
