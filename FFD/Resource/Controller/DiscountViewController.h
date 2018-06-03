//
//  DiscountViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"


@interface DiscountViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvDiscount;

@end
