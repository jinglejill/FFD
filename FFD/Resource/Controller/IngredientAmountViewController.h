//
//  IngredientAmountViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "IngredientSetUpViewController.h"
#import "MenuIngredient.h"



@interface IngredientAmountViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IngredientSetUpViewController *vc;
@property (strong, nonatomic) MenuIngredient *editMenuIngredient;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;


@property (strong, nonatomic) IBOutlet UITableView *tbvIngredientAmount;

@end
