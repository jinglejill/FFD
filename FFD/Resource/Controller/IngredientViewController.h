//
//  IngredientViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "IngredientSetUpViewController.h"
#import "Ingredient.h"
#import "IngredientType.h"
#import "SubIngredientType.h"


@interface IngredientViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IngredientSetUpViewController *vc;
@property (strong, nonatomic) Ingredient *editIngredient;
@property (strong, nonatomic) IngredientType *editIngredientType;
@property (strong, nonatomic) SubIngredientType *editSubIngredientType;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;


@property (strong, nonatomic) IBOutlet UITableView *tbvIngredient;

@end
