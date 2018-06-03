//
//  PromotionDateViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 7/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "PromotionViewController.h"
#import "ConfirmAndCancelView.h"


@interface PromotionDateViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblDirection;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) NSMutableArray *selectedSpecialPriceProgramList;
@property (strong, nonatomic) PromotionViewController *vc;
@property (nonatomic) NSInteger edit;//copy=0,edit=1
- (IBAction)datePickerChanged:(id)sender;




@property (strong, nonatomic) IBOutlet UITableView *tbvPromotionDate;
@end
