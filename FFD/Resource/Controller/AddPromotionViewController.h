//
//  AddPromotionViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "PromotionViewController.h"
#import "ConfirmAndCancelView.h"
#import "SpecialPriceProgram.h"



@interface AddPromotionViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UITableView *tbvAddPromotion;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@property (strong, nonatomic) SpecialPriceProgram *editSpecialPriceProgram;
@property (strong, nonatomic) PromotionViewController *vc;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)unwindToAddPromotion:(UIStoryboardSegue *)segue;
@end
