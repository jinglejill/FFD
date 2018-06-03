//
//  DiscountListViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomSettingViewController.h"

@interface DiscountListViewController : CustomSettingViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvDiscountList;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnShowAll;
@property (strong, nonatomic) IBOutlet UIButton *btnReorder;
- (IBAction)addDiscount:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)reorder:(id)sender;
- (IBAction)unwindToDiscountList:(UIStoryboardSegue *)segue;
- (void)getDataList;
- (IBAction)goBack:(id)sender;
@end
