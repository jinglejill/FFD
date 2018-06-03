//
//  SearchPortViewController.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "CommonViewController.h"
#import "CustomViewController.h"
#import "Printer.h"


@interface SearchPortViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,HomeModelProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) CustomViewController *customVc;
@property (weak, nonatomic) NSString *printerPortKey;
@property (weak, nonatomic) NSString *printerPort;
@property (weak, nonatomic) Printer *printer;
@property (nonatomic) NSInteger selectPrinter;
- (IBAction)reloadPort:(id)sender;
- (IBAction)goBack:(id)sender;

@end
