//
//  SubIngredientTypeReorderViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "ConfirmAndCancelView.h"
#import "IngredientSetUpViewController.h"
#import "IngredientType.h"
#import "SubIngredientType.h"


@interface SubIngredientTypeReorderViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IngredientSetUpViewController *vc;
@property (strong, nonatomic) NSMutableArray *subIngredientTypeList;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;


@property (strong, nonatomic) IBOutlet UITableView *tbvSubIngredientType;

@end
