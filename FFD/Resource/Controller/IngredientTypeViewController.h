//
//  IngredientTypeViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "IngredientSetUpViewController.h"
#import "IngredientType.h"


@interface IngredientTypeViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IngredientSetUpViewController *vc;
@property (strong, nonatomic) IngredientType *editIngredientType;
@property (strong, nonatomic) IBOutlet UITableView *tbvIngredientType;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;

@end
