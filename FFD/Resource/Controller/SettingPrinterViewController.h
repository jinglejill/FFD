//
//  SettingPrinterViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomSettingViewController.h"

@interface SettingPrinterViewController : CustomSettingViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtPrinterPortKitchen;
@property (strong, nonatomic) IBOutlet UITextField *txtPrinterPortKitchen2;
@property (strong, nonatomic) IBOutlet UITextField *txtPrinterPortDrinks;
@property (strong, nonatomic) IBOutlet UITextField *txtPrinterPortCashier;
- (IBAction)unwindToSettingPrinter:(UIStoryboardSegue *)segue;


@end
